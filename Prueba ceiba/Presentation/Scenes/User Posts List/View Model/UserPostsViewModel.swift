//
//  UserPostsViewModel.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 1/10/22.
//

protocol UserPostsViewModelInput {
    func searchUserPost(userId: Int)
}



protocol UserPostsViewModelOutput {
    var usersPostCell: ObservableImpl<[UserPostsViewModelImpl.UserPostListCellViewModelImpl]> { get }
}



protocol UserPostsViewModel : UserPostsViewModelInput, UserPostsViewModelOutput {}



class UserPostsViewModelImpl : UserPostsViewModel {
    
    private let searchUserPostUseCase: SearchUserPost
    var usersPostCell: ObservableImpl = ObservableImpl(value: [UserPostsViewModelImpl.UserPostListCellViewModelImpl]())
    
    
    init(searchUserPostUseCase: SearchUserPost) {
        self.searchUserPostUseCase = searchUserPostUseCase
    }
    
    
    func searchUserPost(userId: Int) {
        searchUserPostUseCase.notificationUseCase.addObserver(forName: SearchUserPostImpl.nameNotificationUseCase, object: nil, queue: .main) { notification in
            do {
                let responseUseCase = notification.object as! SearchUserPostResponse
                let userPostToShow = try responseUseCase()
                let posts = userPostToShow.map(UserPostListCellViewModelImpl.init)
                self.usersPostCell.notifyAllObservers(with: posts)
            }
            catch {
                print("Marlon ------- Error \(error)")
            }
        }
        print("Marlon ------- Registre la notificacion searchUserPostUseCase")
        searchUserPostUseCase.search(input: SearchUserPostInput(userId: userId))
    }
    
    
    struct UserPostListCellViewModelImpl {
        var title: String
        var body: String
        
        
        init(initData: SearchUserPostOutput) {
            title = initData.title
            body = initData.body
        }
    }
}
