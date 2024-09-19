//
//  NetworkManager.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import Foundation
import UIKit

class NetworkManager {
    
    // MARK: - Singleton Instance
    static let shared = NetworkManager()
    
    // MARK: - Private Methods
    
    private func createRequest(urlString: String, method: String, body: Data?) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        return request
    }
    
    private func generateBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    // MARK: - Public Methods
    
    func performRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        
        if let headers = request.allHTTPHeaderFields {
            print("Request HTTP Headers: \(headers)")
        }
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("Request HTTP Body: \(bodyString)")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No HTTP response"])))
                return
            }
            
            if let data = data, let responseBodyString = String(data: data, encoding: .utf8) {
                print("Received Response Body: \(responseBodyString)")
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received from server"])))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                do {
                    let responseData = try JSONDecoder().decode(T.self, from: data!)
                    completion(.success(responseData))
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(error))
                }
            } else {
                let statusCode = httpResponse.statusCode
                let message = "Server responded with status code \(statusCode)"
                completion(.failure(NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: message])))
            }
        }.resume()
    }
    
    // MARK: - Fetching Data Methods
    
    func fetchUsers(page: Int, count: Int, completion: @escaping (Result<UsersResponse, Error>) -> Void) {
        let urlString = "https://frontend-test-assignment-api.abz.agency/api/v1/users?page=\(page)&count=\(count)"
        guard let request = createRequest(urlString: urlString, method: "GET", body: nil) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create URLRequest"])))
            return
        }
        performRequest(request, completion: completion)
    }
    
    func fetchPositions(completion: @escaping (Result<[Position], Error>) -> Void) {
        let urlString = "https://frontend-test-assignment-api.abz.agency/api/v1/positions"
        
        guard let request = createRequest(urlString: urlString, method: "GET", body: nil) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create URLRequest"])))
            return
        }
        
        performRequest(request) { (result: Result<PositionResponse, Error>) in
            switch result {
            case .success(let positionResponse):
                if positionResponse.success {
                    completion(.success(positionResponse.positions))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch positions"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchToken(completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = "https://frontend-test-assignment-api.abz.agency/api/v1/token"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let token = json["token"] as? String else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode token"])))
                return
            }
            
            completion(.success(token))
        }.resume()
    }
    
    // MARK: - User Registration Methods
    
    func createMultipartRequest(urlString: String, method: String, params: [String: Any], image: UIImage?, imageName: String, token: String) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        let boundary = generateBoundary()
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("\(token)", forHTTPHeaderField: "Token")
        
        let body = NSMutableData()
        
        for (key, value) in params {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        if let image = image, let imageData = image.jpegData(compressionQuality: 1.0) {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"photo\"; filename=\"\(imageName).jpeg\"\r\n")
            body.appendString("Content-Type: image/jpeg\r\n\r\n")
            body.append(imageData)
            body.appendString("\r\n")
        }
        
        body.appendString("--\(boundary)--\r\n")
        request.httpBody = body as Data
        
        return request
    }
    
    func registerUserWithToken(params: [String: Any], image: UIImage?, imageName: String, completion: @escaping (Bool, Error?) -> Void) {
        fetchToken { [weak self] result in
            switch result {
            case .success(let token):
                guard let request = self?.createMultipartRequest(urlString: "https://frontend-test-assignment-api.abz.agency/api/v1/users", method: "POST", params: params, image: image, imageName: imageName, token: token) else {
                    completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create the multipart request"]))
                    return
                }
                self?.performRequest(request) { (result: Result<UserResponse, Error>) in
                    switch result {
                    case .success(let userResponse):
                        print("User registered successfully: \(userResponse)")
                        completion(true, nil)
                    case .failure(let error):
                        print("Error registering user: \(error)")
                        completion(false, error)
                    }
                }
            case .failure(let error):
                print("Error fetching token: \(error)")
                completion(false, error)
            }
        }
    }
}

// MARK: - NSMutableData Extension
extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
