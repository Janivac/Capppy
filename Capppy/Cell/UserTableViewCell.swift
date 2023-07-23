//
//  UserTableViewCell.swift
//  Capppy
//
//  Created by Jana Vac on 05.03.2023.
//

import UIKit
import Firebase
protocol UpdateTableProtocol {
    func reloadData()
}


class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var onlineView: UIView!
    
    var user: User!
    var inboxChangedOnlineHandle: DatabaseHandle!
    var inboxChangedProfileHandle: DatabaseHandle!
    var delegate: UpdateTableProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.cornerRadius = avatar.frame.size.width / 2
        avatar.clipsToBounds = true
        avatar.contentMode = .scaleAspectFill
        
        onlineView.backgroundColor = UIColor(red: 255/255, green: 142/255, blue: 172/255, alpha: 1)
        onlineView.layer.borderWidth = 2
        onlineView.layer.borderColor = UIColor.white.cgColor
        onlineView.layer.cornerRadius = 15/2
        onlineView.clipsToBounds = true
        
    }
    
    func loadData(_ user: User) {
        self.user = user
        self.usernameLbl.text = user.username
        self.statusLbl.text = user.status
        self.avatar.loadImage(user.profileImageUrl)
        
        let refOnline = Ref().databaseIsOnline(uid: user.uid)
        refOnline.observeSingleEvent(of: .value) { (snapshot) in
            if let snap = snapshot.value as? Dictionary<String, Any> {
                if let active = snap["online"] as? Bool {
                    let color = active == true ? UIColor(red: 255/255, green: 142/255, blue: 172/255, alpha: 1) : UIColor.gray
                               self.onlineView.backgroundColor = color
                }
            }
        }
        if inboxChangedOnlineHandle != nil {
            refOnline.removeObserver(withHandle: inboxChangedOnlineHandle)
        }
        
        inboxChangedOnlineHandle = refOnline.observe(.childChanged) { (snapshot) in
            if let snap = snapshot.value {
                if snapshot.key == "online" {
                    let color = (snap as! Bool) == true ? UIColor(red: 255/255, green: 142/255, blue: 172/255, alpha: 1) : UIColor.gray
                    self.onlineView.backgroundColor = color
                }
            }
        }
        
        
        let refUser = Ref().databaseSpecificUser(uid: user.uid)
        if inboxChangedProfileHandle != nil {
            refUser.removeObserver(withHandle: inboxChangedProfileHandle)
        }
        
        inboxChangedProfileHandle = refUser.observe(.childChanged, with: { (snapshot) in
            if let snap = snapshot.value as? String {
                self.user.updateData(key: snapshot.key, value: snap)
                self.delegate.reloadData()
            }
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        let refOnline = Ref().databaseIsOnline(uid: self.user.uid)
        if inboxChangedOnlineHandle != nil {
            refOnline.removeObserver(withHandle: inboxChangedOnlineHandle)
        }
        
        let refUser = Ref().databaseSpecificUser(uid: self.user.uid)
        if inboxChangedProfileHandle != nil {
            refUser.removeObserver(withHandle: inboxChangedProfileHandle)
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

