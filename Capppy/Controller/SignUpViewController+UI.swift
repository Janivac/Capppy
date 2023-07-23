//
//  SignUpViewController+UI.swift
//  Capppy
//
//  Created by Jana Vac on 17.10.2022.
//

import UIKit
import FirebaseStorage
import FirebaseAuth





extension SignUpViewController {
    
    
    
    func setupTitleLabel(){
        let title = "Registrace"
       
        
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Futura", size: 28)!,
                                                                                   NSAttributedString.Key.foregroundColor : UIColor.black
                                                                                  ])
        
        titleTextLabel.attributedText = attributedText
        
    }
    func setupAvatar(){
        avatar.layer.cornerRadius = avatar.frame.size.width / 2
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        avatar.addGestureRecognizer(tapGesture)
        avatar.contentMode = .scaleAspectFill // musí být pro nahrani

    }
    
   @objc func presentPicker(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
       picker.allowsEditing = true
     picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func setupFullNameTextField() {
        
        fullnameContainerView.layer.borderWidth = 1
        fullnameContainerView.layer.borderColor = UIColor(red: 210/255 , green: 210/255, blue:210/255, alpha: 1).cgColor
        fullnameContainerView.layer.cornerRadius = 3
        fullnameContainerView.clipsToBounds = true
        
        fullnameTextField.borderStyle = .none
        let placeholderAttr = NSAttributedString( string: "Křestní jméno", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255 , green: 170/255, blue:170/255, alpha: 1)])
        fullnameTextField.attributedPlaceholder = placeholderAttr
        fullnameTextField.textColor = UIColor(red: 100/255 , green: 100/255, blue:100/255, alpha: 1)
        fullnameTextField.autocorrectionType = .no

        
    }
    func setupEmailTextField(){
        emailContainerView.layer.borderWidth = 1
        emailContainerView.layer.borderColor = UIColor(red: 210/255 , green: 210/255, blue:210/255, alpha: 1).cgColor
        emailContainerView.layer.cornerRadius = 3
        emailContainerView.clipsToBounds = true
        
        emailTextField.borderStyle = .none
        let placeholderAttr = NSAttributedString( string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255 , green: 170/255, blue:170/255, alpha: 1)])
        emailTextField.attributedPlaceholder = placeholderAttr
        emailTextField.textColor = UIColor(red: 100/255 , green: 100/255, blue:100/255, alpha: 1)
        emailTextField.autocorrectionType = .no

        
        
    }
    func setupPasswordTextField() {
        passwordContainerView.layer.borderWidth = 1
        passwordContainerView.layer.borderColor = UIColor(red: 210/255 , green: 210/255, blue:210/255, alpha: 1).cgColor
        passwordContainerView.layer.cornerRadius = 3
        passwordContainerView.clipsToBounds = true
        
        passwordTextField.borderStyle = .none
        let placeholderAttr = NSAttributedString( string: "Heslo (8+ znaků)", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255 , green: 170/255, blue:170/255, alpha: 1)])
        passwordTextField.attributedPlaceholder = placeholderAttr
        passwordTextField.textColor = UIColor(red: 100/255 , green: 100/255, blue:100/255, alpha: 1)
        passwordTextField.autocorrectionType = .no
        
    }
    func setupSignUpButton() {
        signUpButton.setTitle("Zaregistrujte se nyní", for: UIControl.State.normal)
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        signUpButton.backgroundColor = UIColor.black
        
        signUpButton.layer.cornerRadius = 5
        signUpButton.clipsToBounds = true
        signUpButton.setTitleColor(.white, for: UIControl.State.normal)
    }
    func setupSignInButton(){
    
        let attributedText = NSMutableAttributedString(string: "Máte již účet?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
                                                                                                                                         NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.65)
                                                                                  ])
        let attributedSubText = NSMutableAttributedString(string: "Přihlásit se", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18),
                                                                                               NSAttributedString.Key.foregroundColor : UIColor.black
                                                                  
                                                                                         ])
        attributedText.append(attributedSubText)
        signInButton.setAttributedTitle(attributedText, for: UIControl.State.normal)
    }
    
    
    
    //______________________________________________________________________________________________________________________________________//
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func validateFields() -> Bool {
        guard let username = self.fullnameTextField.text, !username.isEmpty else {
            ProgressHUD.showError(ERROR_EMPTY_USERNAME)
            return false
        }

        guard let username = self.fullnameTextField.text,
              !username.isEmpty,
              username.range(of: #"^\p{L}{3,15}$"#, options: .regularExpression) != nil else {
            ProgressHUD.showError(ERROR_INCFORM_USERNAME)
            return false
        }

            
        guard let email = self.emailTextField.text, !email.isEmpty else {
            ProgressHUD.showError(ERROR_EMPTY_EMAIL)
            return false
        }
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            ProgressHUD.showError(ERROR_EMPTY_PASSWORD)
            return false
        }
        guard let _ = self.image else {
            ProgressHUD.showError(ERROR_EMPTY_PHOTO)
            return false
        }
        
        if !email.isValidEmail() {
                ProgressHUD.showError(ERROR_INCFORM_EMAIL)
                return false
            }

        
//------------->slozitost hesla
        guard password.count >= 8, password.rangeOfCharacter(from: .uppercaseLetters) != nil, password.rangeOfCharacter(from: .lowercaseLetters) != nil, password.rangeOfCharacter(from: .decimalDigits) != nil else {
               ProgressHUD.showError(ERROR_INCFORM_PASSWORD)
               return false
           }
//<-----------

        
        return true
    }


    
    func signUp(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        guard validateFields() else {
            return
        }
        ProgressHUD.show("Načítání...")
        Api.User.signUp(withUsername: self.fullnameTextField.text!, email: self.emailTextField.text!, password: self.passwordTextField.text!, image: self.image, onSuccess: {
            ProgressHUD.dismiss()
            onSuccess()
        }) { (errorMessage) in
            onError(errorMessage)
        }
    }

    
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = imageSelected
            avatar.image = imageSelected
        }
        
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = imageOriginal
            avatar.image = imageOriginal
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
