//
//  ViewModel.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import Foundation
import Reachability
import UIKit

class ViewModel {
    
    static let shared = ViewModel()
    
    var reachability: Reachability?
    typealias OperationCompletion = (Bool, String?) -> Void
    
    var onNetworkUnavailable: (() -> Void)?
    var onNetworkAvailable: (() -> Void)?
    var onFetchSuccess: (() -> Void)?
    var onFetchFailure: ((String) -> Void)?
    
    var users: [User] = []
    var positions: [Position] = []
    var page = 1
    var isLoading = false
    var hasMoreUsers = true
    
    
    var userName: String?
    var userEmail: String?
    var userPhone: String?
    var userImage: UIImage?
    
    var selectedPositionIndex: Int?
    var textFieldsContent = [Int: String]()
    
    var isUserDataValid: Bool {
        guard let name = userName, !name.isEmpty,
              let email = userEmail, !email.isEmpty,
              let phone = userPhone, !phone.isEmpty,
              let _ = selectedPositionIndex,
              let _ = userImage else {
            return false
        }
        return true
    }
    
    init() {
        setupReachability()
    }
    
    //MARK: NETWORK
    
    func setupReachability() {
        reachability = try? Reachability()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged, object: reachability)
        do {
            try reachability?.startNotifier()
            print("Reachability notifier started successfully.")
        } catch {
            print("Could not start reachability notifier")
        }
    }
    
    func isNetworkAvailable() -> Bool {
        reset()
        
        let isAvailable = reachability?.connection != .unavailable
        return isAvailable
    }
    
    @objc func reachabilityChanged(notification: Notification) {
        guard let reachability = notification.object as? Reachability else { return }
        switch reachability.connection {
        case .wifi, .cellular:
            DispatchQueue.main.async {
                self.onNetworkAvailable?()
            }
        case .unavailable:
            DispatchQueue.main.async {
                self.onNetworkUnavailable?()
            }
        }
    }
    
    func reset() {
        reachability?.stopNotifier()
        reachability = nil
        setupReachability()
    }
    
    deinit {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    func checkInternetConnectionAndFetchUsers(resetData: Bool, completion: @escaping OperationCompletion) {
        guard let reachability = reachability, reachability.connection != .unavailable else {
            completion(false, "Internet connection is unavailable.")
            onNetworkUnavailable?()
            return
        }
        fetchUsers(resetData: resetData, completion: completion)
    }
    
    //MARK: Users flow
    
    func fetchUsers(resetData: Bool, completion: @escaping OperationCompletion) {
        if resetData {
            page = 1
            users.removeAll()
        }
        
        isLoading = true
        NetworkManager.shared.fetchUsers(page: page, count: 6) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let usersResponse):
                    if resetData {
                        self.users = usersResponse.users
                    } else {
                        self.users.append(contentsOf: usersResponse.users)
                    }
                    self.page += 1
                    self.hasMoreUsers = self.page <= usersResponse.totalPages
                    self.onFetchSuccess?()
                    completion(true, nil)
                case .failure(let error):
                    self.onFetchFailure?(error.localizedDescription)
                    completion(false, error.localizedDescription)
                }
            }
        }
    }
    
    func resetUserData() {
        userName = nil
        userEmail = nil
        userPhone = nil
        userImage = nil
        selectedPositionIndex = nil
        textFieldsContent.removeAll()
    }
    
    //MARK: SignUP
    
    func fetchPositions(completion: @escaping (Bool) -> Void) {
         NetworkManager.shared.fetchPositions { [weak self] result in
             switch result {
             case .success(let positions):
                 self?.positions = positions
                 completion(true)
             case .failure(let error):
                 print("Error fetching positions: \(error.localizedDescription)")
                 completion(false)
             }
         }
     }
    
    func registerUser(completion: @escaping (Bool) -> Void) {
        guard isUserDataValid else {
            completion(false)
            return
        }
        
        let params: [String: Any] = [
            "name": userName!,
            "email": userEmail!,
            "phone": userPhone!,
            "position_id": selectedPositionIndex! + 1
        ]
        
        compressImage(userImage!) { [weak self] compressedImage in
            guard let compressedImage = compressedImage else { return }
            
            NetworkManager.shared.registerUserWithToken(params: params, image: compressedImage, imageName: "userPhoto") { success, error in
                if success {
                    completion(true)
                } else {
                    print("Error registering user: \(error?.localizedDescription ?? "Unknown error")")
                    completion(false)
                }
            }
        }
    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let newSize = targetSize
        let rect = CGRect(origin: .zero, size: newSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? image
    }
    
    func compressImage(_ image: UIImage, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let maxFileSize = 5 * 500 * 500
            var minCompression: CGFloat = 0.1
            var maxCompression: CGFloat = 1.0
            var compression: CGFloat = 1.0
            var imageData = image.jpegData(compressionQuality: compression)
            
            while let data = imageData, data.count > maxFileSize && abs(maxCompression - minCompression) > 0.01 {
                compression = (minCompression + maxCompression) / 2
                imageData = image.jpegData(compressionQuality: compression)
                if data.count > maxFileSize {
                    maxCompression = compression
                } else {
                    minCompression = compression
                }
            }
            
            if let data = imageData, data.count > maxFileSize {
                let newSize = CGSize(width: image.size.width * 0.5, height: image.size.height * 0.5)
                let resizedImage = self.resizeImage(image: image, targetSize: newSize)
                imageData = resizedImage.jpegData(compressionQuality: compression)
            }
            
            if let data = imageData, data.count <= maxFileSize {
                let compressedImage = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(compressedImage)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }


}
