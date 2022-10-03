//
//  UserListViewController.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 28/09/22.
//

import Foundation
import UIKit



class UserListViewController : UITableViewController {
    
    private static let reuseIdentifier = "UserListCell"
    private var viewModel: UserListViewModel!
    private var alert: UIAlertController!
    var searchController: UISearchController!
    @IBOutlet weak var emptyLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpView()
        viewModel.viewDidLoad()
    }
    
    
    private func setUpView() {
        let nib = UINib(nibName: "UserListTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Self.reuseIdentifier)
        searchController = UISearchController(searchResultsController: nil)
        //searchController.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self // Monitor when the search button is tapped.
        navigationItem.searchController = searchController
        
        // Make the search bar always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
        alert = UIAlertController(title: "Error descargando datos", message: "No se pudieron descargar los datos", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
    }
    
    
    private func setUp() {
        let userRepository = UserRepositoryImpl(dataStoreFactory: UserDataStoreFactoryImpl(), notificationData: NotificationCenterData.instance)
        
        let InitDataLoadUseCase = InitDataLoadImpl(notificationUseCase: NotificationCenterUseCase.instance, userRepository: userRepository, userPostRepository: UserPostRepositoryImpl(dataStoreFactory: UserPostDataStoreFactoryImpl(),notificationData: NotificationCenterData.instance))        
        let searchUserUseCase = SearchUserImpl(notificationUseCase: NotificationCenterUseCase.instance, userRepository: userRepository)
        
        viewModel = UserListViewModelImpl(initDataLoadUseCase: InitDataLoadUseCase, searchUserUseCase: searchUserUseCase)
        binding()
    }
    
    
    private func binding() {
        viewModel.usersCell.addObserver(observer: self) {[weak self] users in
            if users.isEmpty { self?.emptyLabel.isHidden = false }
            else { self?.emptyLabel.isHidden = true }
            
            self?.tableView.reloadData()
        }
        
        viewModel.isAlert.addObserver(observer: self) { [weak self] isAlert in
            if isAlert { self?.present(self!.alert, animated: true) } }
    }
}


// MARK: -UITableViewDataSource

extension UserListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let numInSection = viewModel.usersCell.value.count
        return numInSection
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userListTableCellViewModel = viewModel.usersCell.value[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath) as! UserListTableCell
        cell.viewModel = userListTableCellViewModel
        cell.delegate = self
        return cell
    }
}
    


extension UserListViewController : UserListTableCellDelegate {
    func doShowPost(_ cell: UserListTableCell) {
        let storyboard = UIStoryboard(name: "UserPostsList", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! UserPostsViewController
        vc.userData = UserPostsViewController.UserData(userId: cell.viewModel!.id, userName: cell.viewModel!.name, userPhone: cell.viewModel!.phone, uerEmail: cell.viewModel!.email)
        navigationController?.pushViewController(vc, animated: true)
    }
}



// MARK: - UISearchBarDelegate

extension UserListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        //searchController.isActive = false
        viewModel.searchUser(userName: searchText)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.cancelSearch()
    }
}
