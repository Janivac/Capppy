//
//  UserAroundCollectionViewCell.swift
//  Capppy
//
//  Created by Jana Vac on 14.05.2023.
//

import UIKit

class UserAroundCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatar: UIImageView!

    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    var user: User!
    var controller: UsersAroundViewController!
    
    
    func loadData(_ user:User){
        self.nameLbl.text = user.username
        self.avatar.loadImage(user.profileImageUrl)
        
        if user.age != nil {
            ageLbl.text = "\(user.age!)"
        } else{
            ageLbl.text = " "
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatar.layer.cornerRadius = 5
        avatar.clipsToBounds = true
    }
    
    
}
