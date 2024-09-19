//
//  SignupViewController.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import UIKit

class SignupViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var workingWithLabel: UILabel!
    
    // MARK: - Properties
    var router: SignupRouting?
    var activityIndicator: UIActivityIndicatorView!
    var overlayView: UIView?
    var viewModel = ViewModel.shared
    var fieldValidationStates = [Int: Bool]() {
        didSet {
            updateSignupButtonState()
        }
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        fetchPositions()
        updateSignupButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Setup Methods
    func setupUI() {
        signupButton.titleLabel?.font = UIFont.nunitoSansRegular(ofSize: 18)
        workingWithLabel.font = UIFont.nunitoSansExtraLight(ofSize: 20)
        backgroundView.backgroundColor = AppColors.uniqueYellow
        signupButton.layer.cornerRadius = signupButton.bounds.height / 2
        signupButton.backgroundColor = AppColors.uniqueYellow
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        
        if let tabBarView = self.tabBarController?.view {
            overlayView = UIView(frame: tabBarView.bounds)
            overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            overlayView?.isHidden = true
            tabBarView.addSubview(overlayView!)
            
            
            overlayView?.addSubview(activityIndicator)
            activityIndicator.center = overlayView!.center
        } else {
            overlayView = UIView(frame: view.bounds)
            overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            overlayView?.isHidden = true
            view.addSubview(overlayView!)
            
            overlayView?.addSubview(activityIndicator)
            activityIndicator.center = overlayView!.center
        }
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "FieldTableViewCell", bundle: nil), forCellReuseIdentifier: "FieldTableViewCell")
        tableView.register(UINib(nibName: "PositionTableViewCell", bundle: nil), forCellReuseIdentifier: "PositionTableViewCell")
        tableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        tableView.register(UINib(nibName: "UploadPhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "UploadPhotoTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    // MARK: - Networking Methods
    private func fetchPositions() {
        showLoadingOverlay()
        viewModel.fetchPositions { [weak self] success in
            DispatchQueue.main.async {
                self?.hideLoadingOverlay()
                if success {
                    self?.tableView.reloadData()
                } else {
                    let alert = UIAlertController(title: "Error", message: "Failed to load positions.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func registerUser() {
        showLoadingOverlay()
        viewModel.registerUser { [weak self] success in
            DispatchQueue.main.async {
                self?.hideLoadingOverlay()
                if success {
                    self?.router?.showDetailForm(isRegistered: true, viewController: self!, animated: true)
                } else {
                    self?.router?.showDetailForm(isRegistered: false, viewController: self!, animated: true)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    func updateSignupButtonState() {
        let allFieldsValid = fieldValidationStates.values.allSatisfy { $0 } && viewModel.isUserDataValid
        signupButton.isEnabled = allFieldsValid
        signupButton.backgroundColor = allFieldsValid ? AppColors.uniqueYellow : UIColor.gray.withAlphaComponent(0.5)
        signupButton.alpha = allFieldsValid ? 1.0 : 0.5
    }
    
    func handleFieldValidationChanged(at index: Int, isValid: Bool) {
        fieldValidationStates[index] = isValid
        updateSignupButtonState()
    }
    
    func showLoadingOverlay() {
        overlayView?.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingOverlay() {
        overlayView?.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func presentPhotoOptions() {
        let alert = UIAlertController(title: nil, message: "Choose how you want to add a photo", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.presentCameraPicker()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.presentGalleryPicker()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Actions
    @IBAction func postDidTap(_ sender: Any) {
        registerUser()
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension SignupViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 + viewModel.positions.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FieldTableViewCell", for: indexPath) as? FieldTableViewCell else {
                return UITableViewCell()
            }
            let defaultText = viewModel.textFieldsContent[indexPath.row] ?? ""
            switch indexPath.row {
            case 0:
                cell.fill(with: "Your Name", isName: true, text: defaultText)
                cell.onTextEntered = { [weak self] text in
                    self?.viewModel.userName = text
                    self?.viewModel.textFieldsContent[indexPath.row] = text
                    
                }
            case 1:
                cell.fill(with: "Email", isEmail: true, text: defaultText)
                cell.onTextEntered = { [weak self] text in
                    self?.viewModel.userEmail = text
                    self?.viewModel.textFieldsContent[indexPath.row] = text
                }
            case 2:
                cell.fill(with: "Phone Number", isPhoneNumber: true, text: defaultText)
                cell.onTextEntered = { [weak self] text in
                    self?.viewModel.userPhone = text
                    self?.viewModel.textFieldsContent[indexPath.row] = text
                }
            default:
                break
            }
            cell.validationChanged = { [weak self] isValid in
                self?.handleFieldValidationChanged(at: indexPath.row, isValid: isValid)
            }
            return cell
            
        } else if indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell") as? LabelTableViewCell else {
                return UITableViewCell()
            }
            
            return cell
        } else if indexPath.row == 4 + viewModel.positions.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UploadPhotoTableViewCell", for: indexPath) as? UploadPhotoTableViewCell else {
                return UITableViewCell()
                
            }
            cell.uploadTapped = { [weak self] in
                self?.presentPhotoOptions()
                self?.updateSignupButtonState()
            }
            
            return cell
        } else {
            
            let positionIndex = indexPath.row - 4
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PositionTableViewCell", for: indexPath) as? PositionTableViewCell else {
                return UITableViewCell()
            }
            
            let isSelected = viewModel.selectedPositionIndex == positionIndex
            
            cell.fill(with: viewModel.positions[positionIndex].name, isSelected: isSelected)
            
            cell.selectionAction = { [weak self] in
                self?.viewModel.selectedPositionIndex = isSelected ? nil : positionIndex
                tableView.reloadData()
                self?.updateSignupButtonState()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0...2:
            return 90
        case 3:
            return 60
        case 4 + viewModel.positions.count:
            return 112
        default:
            return 60
        }
    }
}

// MARK: - UIImagePickerControllerDelegate and UINavigationControllerDelegate
extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentGalleryPicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func presentCameraPicker() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Camera is not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.viewModel.compressImage(selectedImage) { compressedImage in
                self.viewModel.userImage = compressedImage
                picker.dismiss(animated: true, completion: nil)
                self.updateSignupButtonState()
            }
        } else {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
