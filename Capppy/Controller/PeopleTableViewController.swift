//
// PeopleTableViewController.swift
import UIKit

class PeopleTableViewController: UITableViewController, UISearchResultsUpdating {

    var users: [User] = []
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    var searchResults: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBarController()
        setupNavigationBar()
        observeNewMatches()
    }
    
    func setupSearchBarController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Vyhledat uživatele..."
        searchController.searchBar.barTintColor = UIColor.white
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.setValue("Zrušit", forKey: "cancelButtonText")
        
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func setupNavigationBar() {
        let location = UIBarButtonItem(image: UIImage(named: "icon_matches_60"), style: .plain, target: self, action: #selector(locationDidTapped))
        location.tintColor = .darkGray
           
        navigationItem.leftBarButtonItems = [location]
    }
    
    @objc func locationDidTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let usersAroundVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_USER_AROUND) as! UsersAroundViewController
 
        self.navigationController?.pushViewController(usersAroundVC, animated: true)
    }
   
    func observeNewMatches() {
        Api.User.observeNewMatch { [weak self] (user) in
            guard let self = self else { return }
            
            self.users.append(user)
            self.tableView.reloadData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == nil || searchController.searchBar.text!.isEmpty {
            view.endEditing(true)
        } else {
            let textLowercased = searchController.searchBar.text!.lowercased()
            filterContent(for: textLowercased)
        }
        tableView.reloadData()
    }
    
    func filterContent(for searchText: String) {
        searchResults = self.users.filter {
            return $0.username.lowercased().range(of: searchText) != nil
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? searchResults.count : self.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_CELL_USERS, for: indexPath) as! UserTableViewCell
        
        let user = searchController.isActive ? searchResults[indexPath.row] : users[indexPath.row]
        cell.delegate = self
        cell.loadData(user)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? UserTableViewCell {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let chatVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_CHAT) as! ChatViewController
            chatVC.imagePartner = cell.avatar.image
            chatVC.partnerUsername = cell.usernameLbl.text
            chatVC.partnerId = cell.user.uid
            chatVC.partnerUser = cell.user
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
}

extension PeopleTableViewController: UpdateTableProtocol {
    func reloadData() {
        self.tableView.reloadData()
    }
}
