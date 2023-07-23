//
//  RadarViewController.swift
//  Capppy
//
//  Created by Jana Vac on 25.05.2023.
//


import UIKit
import FirebaseDatabase

class RadarViewController: UIViewController {
    
    @IBOutlet weak var cardStack: UIView!
    
    @IBOutlet weak var refreshImg: UIImageView!
    @IBOutlet weak var nopeImg: UIImageView!
    @IBOutlet weak var superLikeImg: UIImageView!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var boostImg: UIImageView!
    var queryHandle: DatabaseHandle?
    var users: [User] = []
    var cards: [Card] = []
    var  cardInitialLocationCenter: CGPoint!
    var panInitialLocation: CGPoint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers()
        title = "Capppy"
        nopeImg.isUserInteractionEnabled = true
        let tapNopeImg = UITapGestureRecognizer(target: self, action: #selector(nopeImgDidTap))
        nopeImg.addGestureRecognizer(tapNopeImg)
        
        likeImg.isUserInteractionEnabled = true
        let tapLikeImg = UITapGestureRecognizer(target: self, action: #selector(likeImgDidTap))
        likeImg.addGestureRecognizer(tapLikeImg)
        
        let newMatchItem = UIBarButtonItem(image: UIImage(named: "icon_chat"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(newMatchItemDidTap))
        self.navigationItem.rightBarButtonItem = newMatchItem
        
    }
    @objc func newMatchItemDidTap() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newMatchVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_NEW_MATCH) as! NewMatchTableViewController
        self.navigationController?.pushViewController(newMatchVC, animated: true)
    }
    
    @objc func nopeImgDidTap() {
        guard let firstCard = cards.first else {
            return
        }
        saveToFirebase(like: false,  card: firstCard)
        swipeAnimation(translation: -750, angle: -15)
        self.setupTransforms()
    }
    
    @objc func likeImgDidTap() {
        guard let firstCard = cards.first else {
            return
        }
        saveToFirebase(like: true,  card: firstCard)
        swipeAnimation(translation: 750, angle: 15)
        self.setupTransforms()

    }
    
    func saveToFirebase(like: Bool, card: Card) {
        Ref().databaseActionForUser(uid: Api.User.currentUserId)
            .updateChildValues([card.user.uid: like]) { (error, ref) in
                if error == nil, like == true {
                    // kontrola matche { send push notificaiton }
                self.checkIfMatchFor(card: card)
                }
        }
    }
    
    func checkIfMatchFor(card: Card) {
        Ref().databaseActionForUser(uid: card.user.uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Bool] else { return }
            if dict.keys.contains(Api.User.currentUserId), dict[Api.User.currentUserId] == true {
                // send push notification
                print("Match!")
            
                Ref().databaseRoot.child("newMatch").child(Api.User.currentUserId).updateChildValues([card.user.uid: true])
            Ref().databaseRoot.child("newMatch").child(card.user.uid).updateChildValues([Api.User.currentUserId: true])
                
                

                
            }
        }
    }
    

    
    func swipeAnimation(translation: CGFloat, angle: CGFloat) {
        let duration = 0.5
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        guard let firstCard = cards.first else {
            return
        }
        for (index, c) in self.cards.enumerated() {
            if c.user.uid == firstCard.user.uid {
                self.cards.remove(at: index)
                self.users.remove(at: index)
            }
        }

        self.setupGestures()

        CATransaction.setCompletionBlock {

            firstCard.removeFromSuperview()
        }
        firstCard.layer.add(translationAnimation, forKey: "translation")
        firstCard.layer.add(rotationAnimation, forKey: "rotation")

        CATransaction.commit()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupCard(user: User){
        let card: Card = UIView.fromNib()
        card.frame = CGRect(x: 0, y: 0, width: cardStack.bounds.width, height: cardStack.bounds.height)
        card.user = user
        card.controller = self
        cards.append(card)
        cardStack.addSubview(card)
        cardStack.sendSubviewToBack(card)
        
        setupTransforms()
        
        if cards.count == 1 {
            cardInitialLocationCenter = card.center
            card.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:))))
            
        }

    }
    
    @objc func pan(gesture: UIPanGestureRecognizer) {
        let card = gesture.view! as! Card
        let translation = gesture.translation(in: cardStack)
        
        switch gesture.state {
        case .began:
            panInitialLocation = gesture.location(in: cardStack)
            
            
        case .changed:
         
            
            card.center.x = cardInitialLocationCenter.x + translation.x
            card.center.y = cardInitialLocationCenter.y + translation.y
            
            if translation.x > 0 {
                // show like icon
            } else {
                // show unlike icon
            }

        case .ended:
   
            if translation.x > 75 {
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: self.cardInitialLocationCenter.x + 1000, y: self.cardInitialLocationCenter.y + 1000)
                }) { (bool) in
                    // remove card
                    card.removeFromSuperview()
                }
                saveToFirebase(like: true, card: card)
                self.updateCards(card: card)

                return
            } else if translation.x < -75 {
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: self.cardInitialLocationCenter.x - 1000, y: self.cardInitialLocationCenter.y + 1000)
                }) { (bool) in
                    // remove card
                    card.removeFromSuperview()
                }
                
                saveToFirebase(like: false, card: card)
                self.updateCards(card: card)
                
                return
            }
            
            
            
            UIView.animate(withDuration: 0.3) {
                card.center = self.cardInitialLocationCenter
            }
        default:
            break
        }
    }
    
    func updateCards(card: Card) {
        for (index, c) in self.cards.enumerated() {
            if c.user.uid == card.user.uid {
                self.cards.remove(at: index)
                self.users.remove(at: index)
            }
        }
        
        setupGestures()
        setupTransforms()
    }
    
    
    func setupGestures() {
        for card in cards {
            let gestures = card.gestureRecognizers ?? []
            for g in gestures {
                card.removeGestureRecognizer(g)
            }
        }
        
        if let  firstCard = cards.first {
            firstCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:))))
            
        }
        
    }
    
    func setupTransforms() {
        for (i, card) in cards.enumerated() {
            if i == 0 { continue; }
            
            if i > 3 { return }
            
            var transform = CGAffineTransform.identity
            if i % 2 == 0 {
                transform = transform.translatedBy(x: CGFloat(i)*4, y: 0)
                transform = transform.rotated(by: CGFloat(Double.pi)/150*CGFloat(i))
            } else {
                transform = transform.translatedBy(x: -CGFloat(i)*4, y: 0)
                transform = transform.rotated(by: -CGFloat(Double.pi)/150*CGFloat(i))
            }
            
            card.transform = transform
        }
    }
    
    func loadUsers() {
        users.removeAll()
        findUsers()
    }
    
    func findUsers() {
        Ref().databaseUsers.observe(.value) { (snapshot) in // Používáme .value místo .childAdded
            if let dict = snapshot.value as? Dictionary<String, Any> {
                self.users = [] // Vyčistit pole uživatelů před načtením nových
                for (_, value) in dict {
                    if let userDict = value as? Dictionary<String, Any> {
                        if let user = User.transformUser(dict: userDict) {
                            if user.uid != Api.User.currentUserId {
                                self.users.append(user)
                                self.setupCard(user: user)
                            }
                        }
                    }
                }
        //self.printUsernames() // Výpis uživatelských jmen
            }
        }
    }
    
    func printUsernames() {
        for user in users {
            print(user.username)
        }
    }
}
