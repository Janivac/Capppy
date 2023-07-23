//
//  DetailViewController.swift
//  Capppy
//
//  Created by Jana Vac on 17.05.2023.
//

import UIKit
import FirebaseDatabase

class DetailViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    
    @IBOutlet weak var userPrefImg: UIImageView!
    @IBOutlet weak var aboutText: UITextView!
    @IBOutlet weak var genderImage: UIImageView!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    

    var user: User!
    var shouldHideSendButton = false

    
    override func viewDidLoad() {
        sendBtn.isHidden = shouldHideSendButton
        super.viewDidLoad()
        updatePreferenceImage()

  
        sendBtn.layer.cornerRadius = 5
        sendBtn.clipsToBounds = true
        
        let aboutText = "Toto je ukázkový text"
       

        let backImg = UIImage(named: "close")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        backBtn.setImage(backImg, for: UIControl.State.normal)
        backBtn.tintColor = .white
        backBtn.layer.cornerRadius = backBtn.frame.height / 2
        backBtn.clipsToBounds = true
        
        if let profileImageURL = URL(string: user.profileImageUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: profileImageURL) {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self.avatar.image = image
                    }
                }
            }
        }


        usernameLbl.text = user.username
        if user.age != nil {
            ageLbl.text = "\(user.age!)"
            
        } else  {
            ageLbl.text = ""
            
        }
        
        if let isMale = user.isMale {
            var genderImgName = (isMale == true) ? "icon-male" : "icon-female"
            genderImage.image = UIImage(named: genderImgName)?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        } else {
            genderImage.image = UIImage(named: "icon-gender")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        }
        
    
               
  

        genderImage.tintColor = .white
        
        tableView.contentInsetAdjustmentBehavior = .never


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // Funkce pro aktualizaci obrázku preference
    func updatePreferenceImage() {
        guard let userPreference = user.preference else {
            userPrefImg.image = nil
            return
        }
        
        if userPreference == "přátelství" {
            userPrefImg.image = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
            userPrefImg.tintColor = UIColor(red: 147/255, green: 197/255, blue: 114/255, alpha: 1.0)
        } else if userPreference == "studium" {
            userPrefImg.image = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
            userPrefImg.tintColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1.0)
        } else if userPreference == "známost" {
            userPrefImg.image = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
            userPrefImg.tintColor = UIColor(red: 255/255, green: 142/255, blue: 172/255, alpha: 1.0)
        } else {
            userPrefImg.image = nil
        }
    }

    
    @IBAction func backBtnDidTapped(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)

    }
    
    @IBAction func sendBtnDidTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_CHAT) as! ChatViewController
        chatVC.imagePartner = avatar.image
        chatVC.partnerUsername = usernameLbl.text
        chatVC.partnerId = user.uid
        chatVC.partnerUser = user
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    

}
