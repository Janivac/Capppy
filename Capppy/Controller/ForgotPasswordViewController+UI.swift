//
//  ForgotPasswordViewController+UI.swift
//  Capppy
//
//  Created by Jana Vac on 18.10.2022.
//

import UIKit
import FirebaseAuth

extension ForgotPasswordViewController{
    
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
    
    func setupResetButton(){
        resetButton.setTitle("Resetovat mé heslo", for: UIControl.State.normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        resetButton.backgroundColor = UIColor.black
        
        resetButton.layer.cornerRadius = 5
        resetButton.clipsToBounds = true
        resetButton.setTitleColor(.white, for: UIControl.State.normal)
    }
    
    
    
}
