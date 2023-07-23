//
//  ChatViewController.swift
//  Capppy
//
//  Created by Jana Vac on 13.03.2023.
//

import UIKit
import MobileCoreServices
import AVFoundation



class ChatViewController: UIViewController {
    
    
    @IBOutlet weak var mediaButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var imagePartner: UIImage!
    var avatarImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
    var topLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    var partnerUsername: String!
    var partnerId: String!
    var partnerUser: User!
    var placeholderLbl = UILabel()
    var picker = UIImagePickerController()
    var messages = [Message]()
    var isActive = false
    var lastTimeOnline = ""
    var isTyping = false
    var timer = Timer()
    var refreshControl = UIRefreshControl()
    var lastMessageKey: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPicker()
        setupInputContainer()
        setupNativationBar()
        setupTableView()

    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func sendButtonDidTapped(_ sender: Any) {
        if let text = inputTextView.text, text != "" {
            inputTextView.text = ""
            self.textViewDidChange(inputTextView)
            sendToFirebase(dict: ["text": text as Any])
        }
    }
    
    @IBAction func mediaButtonDidTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Capppy", message: "Vyber", preferredStyle: UIAlertController.Style.actionSheet)
        let camera = UIAlertAction(title: "Pořiď fotku", style: UIAlertAction.Style.default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                self.picker.sourceType = .camera
                self.present(self.picker, animated: true, completion: nil)
                
            } else {
                print("Nedostupný")
            }
            
        }
        
        let library = UIAlertAction(title: "Vyber fotku", style: UIAlertAction.Style.default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                self.picker.sourceType = .photoLibrary
                self.picker.mediaTypes = [String(kUTTypeImage), String(kUTTypeMovie)]
                
                self.present(self.picker, animated: true, completion: nil)
            } else {
                print("Nedostupný")
            }
        }
        
//        let videoCamera = UIAlertAction(title: "Pořiď video", style: UIAlertAction.Style.default) { (_) in
//            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
//                self.picker.sourceType = .camera
//                self.picker.mediaTypes = [String(kUTTypeMovie)]
//                self.picker.videoExportPreset = AVAssetExportPresetPassthrough
//                self.picker.videoMaximumDuration = 30
//                self.present(self.picker, animated: true, completion: nil)
//
//            } else {
//                print("Nedostupný")
//            }
//        }
        
  
        let cancel = UIAlertAction(title: "Zrušit", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(camera)
        alert.addAction(cancel)
//        alert.addAction(videoCamera)
        alert.addAction(library)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
}

