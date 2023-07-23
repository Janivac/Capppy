//
//  UsersAroundViewController.swift
//  Capppy
//
//  Created by Jana Vac on 04.05.2023.
//

import UIKit
import FirebaseDatabase


class UsersAroundViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        findUsers()
        setupNavigationBar() 
    }
    //--
    func setupNavigationBar() {
        title = "Propojení"
        let refresh = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(refreshTapped))
        navigationItem.rightBarButtonItems = [refresh]
    }
    
    func loadUsers() {
        users.removeAll() // Vymaže stávající data
        findUsers() // Načte nová data z databáze
        collectionView.reloadData() // Aktualizuje zobrazení
    }

    
    @objc func refreshTapped() {
print("funguje")
        loadUsers()


        
    }
    //--
    
    
    func findUsers() {
        UserApi().observeNewMatch { (user) in
            if user.uid != Api.User.currentUserId {
                self.users.append(user)
                self.collectionView.reloadData()
            }
        }
    }

    
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        collectionView.reloadData()
    }
}
    extension UsersAroundViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if segmentControl.selectedSegmentIndex == 0 {
                return users.filter { $0.isMale == true }.count
            } else if segmentControl.selectedSegmentIndex == 1 {
                return users.filter { $0.isMale == false }.count
            } else {
                return users.count
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserAroundCollectionViewCell", for: indexPath) as! UserAroundCollectionViewCell
            var filteredUsers: [User]
            
            if segmentControl.selectedSegmentIndex == 0 {
                filteredUsers = users.filter { $0.isMale == true }
            } else if segmentControl.selectedSegmentIndex == 1 {
                filteredUsers = users.filter { $0.isMale == false }
            } else {
                filteredUsers = users
            }
            
            let user = filteredUsers[indexPath.item]
            cell.controller = self
            cell.loadData(user)
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_DETAIL) as! DetailViewController
            
           
            
            
            var filteredUsers: [User]
            
            if segmentControl.selectedSegmentIndex == 0 {
                filteredUsers = users.filter { $0.isMale == true }
            } else if segmentControl.selectedSegmentIndex == 1 {
                filteredUsers = users.filter { $0.isMale == false }
            } else {
                filteredUsers = users
            }
            
            let user = filteredUsers[indexPath.item]
            
            detailVC.user = user
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = view.frame.size.width / 3 - 2
            let height = view.frame.size.width / 3
            return CGSize(width: width, height: height)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
    }
