//
//  SignInViewController.swift
//  Capppy
//
//  Created by Jana Vac on 18.10.2022.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
            }
            

            func setupUI(){
                
                setupTitleLabel()
                setupEmailTextField()
                setupPasswordTextField()
                setupSignUpButton()
                setupSignInButton()
                
            }

    @IBAction func dismissAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func signInButtonDidTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.validateFields()
        self.signIn(onSuccess: {
            Api.User.isOnline(bool: true)
            (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
        }) {(errorMessage) in
            ProgressHUD.showError(ERROR_NOT_VALID)
        }
        
        
    }
    
}
