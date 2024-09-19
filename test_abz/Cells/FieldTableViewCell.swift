//
//  FieldTableViewCell.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import UIKit

class FieldTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    
    var onTextEntered: ((String) -> Void)?
    var validationChanged: ((Bool) -> Void)?
    
    var isPhoneNumber: Bool = false
    var isEmail: Bool = false
    var isName: Bool = false
    
    var placeholderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextField()
        self.selectionStyle = .none
    }
    
    private func setupTextField() {
        userTextField.delegate = self
        userTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        userTextField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        
        userTextField.placeholder = ""
        
        userTextField.layer.borderWidth = 1.0
        userTextField.layer.cornerRadius = 5.0
        userTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        placeholderLabel = UILabel()
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.font = userTextField.font
        placeholderLabel.text = "" // Will be set in the `fill` method
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userTextField.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: userTextField.leadingAnchor, constant: 5),
            placeholderLabel.centerYAnchor.constraint(equalTo: userTextField.centerYAnchor)
        ])
    }
    
    
    func fill(with placeholder: String, isPhoneNumber: Bool = false, isEmail: Bool = false, isName: Bool = false, text: String) {
        userTextField.text = text
        self.isPhoneNumber = isPhoneNumber
        self.isEmail = isEmail
        self.isName = isName
        
        placeholderLabel.text = placeholder
        userTextField.keyboardType = isPhoneNumber ? .phonePad : (isEmail ? .emailAddress : .default)
        
        if isPhoneNumber {
            infoLabel.isHidden = false
            infoLabel.textColor = .black
            infoLabel.text = "+38 (XXX) XXX - XX - XX"
        } else {
            infoLabel.isHidden = true
            infoLabel.text = ""
        }
        
        if !text.isEmpty {
            movePlaceholderUp(animated: false)
        }
    }
    
    private func movePlaceholderUp(animated: Bool) {
        let scale: CGFloat = 0.7
        let moveUpDistance: CGFloat = -userTextField.bounds.height / 3
        let color = UIColor(hex: "00BDD3")
        
        let transform = CGAffineTransform(scaleX: scale, y: scale).concatenating(CGAffineTransform(translationX: 0, y: moveUpDistance))
        
        let animations = {
            self.placeholderLabel.transform = transform
            self.placeholderLabel.textColor = color
        }
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: animations)
        } else {
            animations()
        }
    }
    
    private func movePlaceholderDown(animated: Bool) {
        let animations = {
            self.placeholderLabel.transform = .identity
            self.placeholderLabel.textColor = UIColor.lightGray
        }
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: animations)
        } else {
            animations()
        }
    }
    
    private func validateInput() {
        guard let text = userTextField.text else {
            resetValidation()
            validationChanged?(false)
            return
        }
        
        var isValid = true
        var errorMessage = ""
        
        if isName {
            if text.trimmingCharacters(in: .whitespaces).isEmpty || !isValidName(text) {
                isValid = false
                errorMessage = "Name must be 2-60 letters long."
            }
        }
        
        if isPhoneNumber {
            if text.trimmingCharacters(in: .whitespaces).isEmpty || !isValidPhoneNumber(text) {
                isValid = false
                errorMessage = "Phone must start with +380 and have 9 digits."
            }
        }
        
        if isEmail {
            if !text.trimmingCharacters(in: .whitespaces).isEmpty && !isValidEmail(text) {
                isValid = false
                errorMessage = "Invalid email format."
            }
        }
        
        userTextField.textColor = isValid ? .black : .red
        
        userTextField.layer.borderColor = isValid ? UIColor(hex: "#00BDD3").cgColor : UIColor.red.cgColor
        
        if isValid {
            infoLabel.isHidden = true
            infoLabel.text = ""
        } else {
            infoLabel.isHidden = false
            infoLabel.textColor = .red
            infoLabel.text = errorMessage
        }
        validationChanged?(isValid)
    }
    
    private func resetValidation() {
        userTextField.textColor = .black
        if isPhoneNumber {
            infoLabel.isHidden = false
            infoLabel.textColor = .black
            infoLabel.text = "+38 (XXX) XXX - XX - XX"
        } else {
            infoLabel.isHidden = true
            infoLabel.text = ""
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    private func isValidName(_ name: String) -> Bool {
        let nameRegex = "^[A-Za-zА-Яа-яЁё ]{2,60}$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return nameTest.evaluate(with: name)
    }
    
    private func isValidPhoneNumber(_ phone: String) -> Bool {
        let phoneRegex = "^\\+380\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
}

extension FieldTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        validateInput()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        userTextField.layer.borderColor = UIColor(hex: "#00BDD3").cgColor
        
        if userTextField.text?.isEmpty ?? true {
            movePlaceholderUp(animated: true)
        }
    }
    
    @objc private func textFieldDidChange() {
        validateInput()
        
        if let text = userTextField.text, text.isEmpty {
            movePlaceholderDown(animated: true)
        } else {
            movePlaceholderUp(animated: true)
        }
    }
    
    @objc private func textFieldDidEndEditing() {
        onTextEntered?(userTextField.text ?? "")
        validateInput()
        
        if let text = userTextField.text, text.isEmpty {
            userTextField.layer.borderColor = UIColor.lightGray.cgColor
            movePlaceholderDown(animated: true)
        }
    }
}
