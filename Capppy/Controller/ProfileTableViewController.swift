//
//  ProfileTableViewController.swift
//  Capppy
//
//  Created by Jana Vac on 14.04.2023.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernameLbl: UITextField!
    @IBOutlet weak var emailLbl: UITextField!
    @IBOutlet weak var statusLbl: UITextField!
    
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var preferenceSegment: UISegmentedControl!
    @IBOutlet weak var ageTextField: UITextField!
    //----> max délka
    let maxStatusLength = 25
    //----> max délka
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
     observeData()
        
        
    //----
        if let preferenceIndex = UserDefaults.standard.value(forKey: "preferenceIndex") as? Int {
                   preferenceSegment.selectedSegmentIndex = preferenceIndex
               }
        preferenceSegment.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        genderSegment.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)

    
    //-----
        
        // emailLbl needt
            emailLbl.isEnabled = false
            usernameLbl.isEnabled = false
    }
    
    func setupView(){
        setupAvatar()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    //ZMĚNA!
    func setupAvatar(){
        avatar.layer.cornerRadius = avatar.frame.size.width / 2
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        avatar.addGestureRecognizer(tapGesture)
        avatar.contentMode = .scaleAspectFill

    }
    
    @objc func presentPicker(){
        view.endEditing(true)
         let picker = UIImagePickerController()
         picker.sourceType = .photoLibrary
        picker.allowsEditing = true
      picker.delegate = self
         self.present(picker, animated: true, completion: nil)
     }
    
    func observeData(){
        Api.User.getUserInforSingleEvent(uid: Api.User.currentUserId) { (user) in
            self.usernameLbl.text = user.username
            self.emailLbl.text = user.email
            self.statusLbl.text = user.status
            self.avatar.loadImage(user.profileImageUrl)
            
            if let age = user.age {
                self.ageTextField.text = "\(age)"
            } else {
                self.ageTextField.placeholder = "Věk"
            }
            
            if let isMale = user.isMale {
                self.genderSegment.selectedSegmentIndex = (isMale == true) ? 0 : 1
            }
            
            
           //-----??
 
          

         //----??
            
        }
    }

  
    @IBAction func logoutBtnDidTapped(_ sender: Any) {
        Api.User.logOut()
    }
    
    //-----------------> VÝMAZ
    
    @IBAction func cancelBtnDidTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Odstranění účtu", message: "Jste si jistí, že chcete odstranit svůj účet? Tuto akci nelze vrátit zpět.", preferredStyle: .alert)

           let cancelAction = UIAlertAction(title: "Zůstat", style: .cancel, handler: nil)

           let deleteAction = UIAlertAction(title: "Odstranit", style: .destructive) { (action) in
               ProgressHUD.show("Odstraňování účtu...")
               self.confirmAccountDeletion()
           }

           alertController.addAction(cancelAction)
           alertController.addAction(deleteAction)
        
        
      

           present(alertController, animated: true, completion: nil)
    }
    
    func confirmAccountDeletion() {
        Api.User.deleteAccount()

    }
    //-----------------> VÝMAZ
    
    
    @IBAction func saveBtnDidTapped(_ sender: Any) {
        ProgressHUD.show("Načítání...")
        
        //----> max délka
        
        if let status = statusLbl.text {
               if !status.isEmpty && status.count > maxStatusLength {
                   ProgressHUD.showError("Status přesahuje maximální povolenou délku (25 znaků).")
                   return
               }
           }
        //----> max délka
        
        var dict = Dictionary<String, Any>()
        if let username = usernameLbl.text, !username.isEmpty {
            dict["username"] = username
        }
        if let email = emailLbl.text, !email.isEmpty {
            dict["email"] = email
        }
        if let status = statusLbl.text, !status.isEmpty {
            dict["status"] = status
        }
        if genderSegment.selectedSegmentIndex == 0 {
            dict["isMale"] = true
        }
        if genderSegment.selectedSegmentIndex == 1 {
            dict["isMale"] = false
        }
        
        if let age = ageTextField.text, !age.isEmpty {
            dict["age"] = Int(age)
        }
        
        switch preferenceSegment.selectedSegmentIndex {
           case 0:
               dict["preference"] = "přátelství"
           case 1:
               dict["preference"] = "studium"
           case 2:
               dict["preference"] = "známost"
           default:
               break
           }
        let preferenceIndex = preferenceSegment.selectedSegmentIndex
              UserDefaults.standard.set(preferenceIndex, forKey: "preferenceIndex")
            
        
      
        
        
        Api.User.saveUserProfile(dict: dict, onSuccess: {
            if let img = self.image {
                StorageService.savePhotoProfile(image: img, uid: Api.User.currentUserId, onSuccess: {
                    ProgressHUD.showSuccess()
                }) { (errorMessage) in
                    ProgressHUD.showError(errorMessage)
                }
            } else {
                ProgressHUD.showSuccess()
            }
            
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
            
            
            
        }
        
    }
    
}

extension ProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

