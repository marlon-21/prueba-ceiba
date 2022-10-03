//
//  UserListViewModel.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 29/09/22.
//

import UIKit



protocol UserListViewModelInput {
    func viewDidLoad()
    func searchUser(userName: String)
    func cancelSearch()
}



protocol UserListViewModelOutput {
    var usersCell: ObservableImpl<[UserListCellViewModel]> { get }
    var isAlert: ObservableImpl<Bool> { get }
}



protocol UserListViewModel : UserListViewModelInput, UserListViewModelOutput {}
    
    

class UserListViewModelImpl : UserListViewModel {
    
    private let initDataLoadUseCase: InitDataLoad
    private let searchUser: SearchUser
    
    var usersCell: ObservableImpl = ObservableImpl(value: [UserListCellViewModel]())
    var isAlert: ObservableImpl = ObservableImpl(value: false)
    var searchBarPlaceholder: String {
        return "Usuario a buscar"
    }
    
    
    init(initDataLoadUseCase: InitDataLoad, searchUserUseCase: SearchUser) {
        self.initDataLoadUseCase = initDataLoadUseCase
        self.searchUser = searchUserUseCase
    }   
    
    
    func viewDidLoad() {
        initDataLoadUseCase.notificationUseCase.addObserver(forName: InitDataLoadImpl.nameNotificationUseCase, object: nil, queue: OperationQueue.main) { notification in
            do {
                let responseUseCase = notification.object as! InitDataLoadResponse
                let usersToShow = try responseUseCase()
                let users = usersToShow.map(UserListCellViewModel.init)
                self.usersCell.notifyAllObservers(with: users)
            }
            catch {
                print("Marlon ------- Error \(error)")
                self.isAlert.notifyAllObservers(with: true)
            }
        }
        
        initDataLoadUseCase.load()
    }
    
    
    func searchUser(userName: String) {
        searchUser.notificationUseCase.addObserver(forName: SearchUserImpl.nameNotificationUseCase, object: nil, queue: OperationQueue.main) { notification in
            do {
                let responseUseCase = notification.object as! SearchUserResponse
                let usersToShow = try responseUseCase()
                let users = usersToShow.map(UserListCellViewModel.init)               
                self.usersCell.notifyAllObservers(with: users)
            }
            catch {
                print("Marlon ------- Error \(error)")
            }
        }
        
        searchUser.search(input: SearchUserInput(userName: userName))
    }
    
    
    func cancelSearch() {
        searchUser.cancelSearch()
    }
}



struct UserListCellViewModel {
    var id: Int
    var name: String
    var phone: String
    var email: String
    
    init(initData: SearchUserOutput) {
        id = initData.id
        name = initData.name
        email = initData.email
        phone = initData.phone
    }
}
