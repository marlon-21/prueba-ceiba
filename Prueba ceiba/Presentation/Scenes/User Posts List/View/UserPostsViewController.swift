//
//  UserPostViewController.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 1/10/22.
//

import UIKit



class UserPostsViewController : UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var phoneLabel: UILabel!
    var userData: UserData?
    private var viewModel: UserPostsViewModel!
    private static let reuseIdentifier = "UserPostCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpView()
        
        guard let userData = userData else { return }
        viewModel.searchUserPost(userId: userData.userId)
    }
    
    
    private func setUpView() {
        cardView.layer.cornerRadius = 8
        //cardView.layer.borderWidth = 1.0
        cardView.layer.borderColor = UIColor.black.cgColor
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 3, height: 3)
        cardView.layer.shadowOpacity = 0.6
        cardView.layer.shadowRadius = 8.0
        
        nameLabel.text = userData?.userName
        phoneLabel.text = userData?.userPhone
        emailLabel.text = userData?.uerEmail
        
        let nib = UINib(nibName: "UserPostTableCell", bundle: nil)
        postsTableView.register(nib, forCellReuseIdentifier: Self.reuseIdentifier)
        postsTableView.dataSource = self
    }
    
    
    private func setUp() {
        let useCase = SearchUserPostImpl(notificationUseCase: NotificationCenterUseCase.instance, userPostRepository: UserPostRepositoryImpl(dataStoreFactory: UserPostDataStoreFactoryImpl(), notificationData: NotificationCenterData.instance))
        viewModel = UserPostsViewModelImpl(searchUserPostUseCase: useCase)
        binding()
    }
    
    
    private func binding() {
        viewModel.usersPostCell.addObserver(observer: self) { [weak self] _ in self?.postsTableView.reloadData() }
    }
   
    
    
    struct UserData {
        var userId: Int
        var userName: String
        var userPhone: String
        var uerEmail: String
    }
}



extension UserPostsViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let numInSection = viewModel.usersPostCell.value.count
        return numInSection
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userPostsListTableCellViewModel = viewModel.usersPostCell.value[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath) as! UserPostTableCell
        cell.postTitle = userPostsListTableCellViewModel.title
        cell.postBody = userPostsListTableCellViewModel.body        
        return cell
    }
}
