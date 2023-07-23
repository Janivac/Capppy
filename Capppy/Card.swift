//
//  Card.swift
//  Capppy
//
//  Created by Jana Vac on 25.06.2023.
//

import UIKit

class Card: UIView {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    var controller: RadarViewController!

    var user: User! {
        didSet {
            photo.loadImage(user.profileImageUrl) { (image) in
                self.user.profileImage = image
            }
            
            let attributedUsernameText = NSMutableAttributedString(string: "\(user.username)  ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30),
                                                                                                              NSAttributedString.Key.foregroundColor : UIColor.white                                                                     ])
            var age = ""
            if let ageValue = user.age {
                age = String(ageValue)
            }
            let attributedAgeText = NSMutableAttributedString(string: age, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30),
                                                                                                   NSAttributedString.Key.foregroundColor : UIColor.white                                                                     ])
            attributedUsernameText.append(attributedAgeText)
            usernameLbl.attributedText = attributedUsernameText
            locationLbl.text = ""
            
       
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        let frameGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: bounds.height)
        photo.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
        photo.layer.cornerRadius = 10
        photo.clipsToBounds = true
    }
    
    
    
    @IBAction func infoBtnDidTap(_ sender: Any) {
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_DETAIL) as! DetailViewController
            detailVC.user = user
            detailVC.shouldHideSendButton = true

            self.controller.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
}



