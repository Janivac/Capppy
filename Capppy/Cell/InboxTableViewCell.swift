//
//  InboxTableViewCell.swift
//  Capppy
//
//  Created by Jana Vac on 08.04.2023.
//

import UIKit
import Firebase

class InboxTableViewCell:
    UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var onlineView: UIView!
    
    var user: User!
    var inboxChangedOnlineHandle: DatabaseHandle!
    var inboxChangedProfileHandle: DatabaseHandle!
    var inboxChangedMessageHandle: DatabaseHandle!
    var inbox: Inbox!
    var controller: MessagesTableViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatar.layer.cornerRadius = avatar.frame.size.width / 2
        avatar.clipsToBounds = true
        avatar.contentMode = .scaleAspectFill
        onlineView.backgroundColor = UIColor(red: 255/255, green: 142/255, blue: 172/255, alpha: 1)
        onlineView.layer.borderWidth = 2
        onlineView.layer.borderColor = UIColor.white.cgColor
        onlineView.layer.cornerRadius = 15/2
        onlineView.clipsToBounds = true
 
        
    }
    
    func configureCell(uid: String, inbox: Inbox) {
        self.user = inbox.user
        self.inbox = inbox
        avatar.loadImage(inbox.user.profileImageUrl)
        usernameLbl.text = inbox.user.username
        let date = Date(timeIntervalSince1970: inbox.date)
        let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        dateLbl.text = dateString
        
        if !inbox.text.isEmpty {
            messageLbl.text = inbox.text
        } else {
            messageLbl.text = "[MEDIA]"
        }
        
        let channelId = Message.hash(forMembers: [Api.User.currentUserId, inbox.user.uid])
        let refInbox = Database.database().reference().child(REF_INBOX).child(Api.User.currentUserId).child(channelId)
        if inboxChangedMessageHandle != nil {
            refInbox.removeObserver(withHandle: inboxChangedMessageHandle)
        }
        
        inboxChangedMessageHandle = refInbox.observe(.childChanged, with: { (snapshot) in
            
            if let snap = snapshot.value {
                self.inbox.updateData(key: snapshot.key, value: snap)
                self.controller.sortedInbox()
            }
        })
        
        
        let refOnline = Ref().databaseIsOnline(uid: inbox.user.uid)
        refOnline.observeSingleEvent(of: .value) { (snapshot) in
            if let snap = snapshot.value as? Dictionary<String, Any> {
                if let active = snap["online"] as? Bool {
                    let color = active == true ? UIColor (red: 255/255, green: 142/255, blue: 172/255, alpha: 1) : UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
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
                    let color = (snap as! Bool) == true ? UIColor (red: 255/255, green: 142/255, blue: 172/255, alpha: 1) : UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
                    self.onlineView.backgroundColor = color
                }
            }
        }

        
        let refUser = Ref().databaseSpecificUser(uid: inbox.user.uid)
        if inboxChangedProfileHandle != nil {
            refUser.removeObserver(withHandle: inboxChangedProfileHandle)
        }
        
        inboxChangedProfileHandle = refUser.observe(.childChanged, with: { (snapshot) in
            if let snap = snapshot.value as? String {
                self.user.updateData(key: snapshot.key, value: snap)
                self.controller.sortedInbox()
            }
        })
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        let refOnline = Ref().databaseIsOnline(uid: self.inbox.user.uid)
        if inboxChangedOnlineHandle != nil {
            refOnline.removeObserver(withHandle: inboxChangedOnlineHandle)
        }
        
        let refUser = Ref().databaseSpecificUser(uid: inbox.user.uid)
        if inboxChangedProfileHandle != nil {
            refUser.removeObserver(withHandle: inboxChangedProfileHandle)
        }
        
        let channelId = Message.hash(forMembers: [Api.User.currentUserId, inbox.user.uid])
        let refInbox = Database.database().reference().child(REF_INBOX).child(Api.User.currentUserId).child(channelId)
        if inboxChangedMessageHandle != nil {
            refInbox.removeObserver(withHandle: inboxChangedMessageHandle)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

}
