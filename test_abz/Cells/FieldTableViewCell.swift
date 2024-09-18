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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextField()
        self.selectionStyle = .none
    }
    
    private func setupTextField() {
        userTextField.delegate = self
        userTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        userTextField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
    }
    
    @objc private func textFieldDidChange() {
        validateInput()
    }
    
    @objc private func textFieldDidEndEditing() {
        onTextEntered?(userTextField.text ?? "")
        validateInput()
    }
    
    func fill(with placeholder: String, isPhoneNumber: Bool = false, isEmail: Bool = false, isName: Bool = false, text: String) {
        userTextField.text = text
        self.isPhoneNumber = isPhoneNumber
        self.isEmail = isEmail
        self.isName = isName
        userTextField.placeholder = placeholder
        userTextField.keyboardType = isPhoneNumber ? .phonePad : (isEmail ? .emailAddress : .default)
        
        if isPhoneNumber {
            infoLabel.isHidden = false
            infoLabel.textColor = .black
            infoLabel.text = "+38 (XXX) XXX - XX - XX"
        } else {
            infoLabel.isHidden = true
            infoLabel.text = ""
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
}
