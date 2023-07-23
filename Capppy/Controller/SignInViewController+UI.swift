//
//  SignInViewController+UI.swift
//  Capppy
//
//  Created by Jana Vac on 18.10.2022.
//

import UIKit
import FirebaseAuth

extension SignInViewController{
    


    
    
    func setupTitleLabel(){
        let title = "Přihlášení"
       
        
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Futura", size: 28)!,
                                                                                   NSAttributedString.Key.foregroundColor : UIColor.black
                                                                                  ])
        
        titleTextLabel.attributedText = attributedText
        
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
    func setupPasswordTextField(){
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
    func setupSignInButton(){
        signInButton.setTitle("Přihlásit se", for: UIControl.State.normal)
        signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        signInButton.backgroundColor = UIColor.black
        
        signInButton.layer.cornerRadius = 5
        signInButton.clipsToBounds = true
        signInButton.setTitleColor(.white, for: UIControl.State.normal)
    }
    func setupSignUpButton(){
    
        let attributedText = NSMutableAttributedString(string: "Ještě nemáte účet?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
                                                                                                                                         NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.65)
                                                                                  ])
        let attributedSubText = NSMutableAttributedString(string: "Zaregistrujte se ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18),
                                                                                               NSAttributedString.Key.foregroundColor : UIColor.black
                                                                  
                                                                                         ])
        attributedText.append(attributedSubText)
        signUpButton.setAttributedTitle(attributedText, for: UIControl.State.normal)
    }
    
    func validateFields(){
      
        guard let email = self.emailTextField.text, !email.isEmpty else {
            ProgressHUD.showError(ERROR_EMPTY_EMAIL)
            return
        }
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            ProgressHUD.showError(ERROR_EMPTY_PASSWORD)
            return
        }
    }
    
    func signIn(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void){
        ProgressHUD.show("Načítání...")
        Api.User.signIn(email: self.emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            ProgressHUD.dismiss()
            onSuccess()
        }){ (errorMessage) in
            onError(errorMessage)
        }

    }
    
}
