//
//  ViewController.swift
//  Capppy
//
//  Created by Jana Vac on 02.10.2022.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var signInFacebookButton: UIButton!
    @IBOutlet weak var signInGoogleButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
 
    @IBOutlet weak var termsOfServiceLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var imageWelcome: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupUI()
        
    }


    
    func setupUI() {
        setupHeaderTitle()

        setupTermsLabel()

        setupCreateAccountButton()
        
  
  
      
   
    }
    

}

