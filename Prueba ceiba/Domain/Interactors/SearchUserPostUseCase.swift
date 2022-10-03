//
//  SearchUserPost.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 2/10/22.
//

import Foundation


protocol SearchUserPost {
    
    var notificationUseCase: NotificationCenter { get }
    static var nameNotificationUseCase: Notification.Name { get }
    //associatedtype Input
    //associatedtype Output: Observable
    
    func search(input: SearchUserPostInput)
}


class SearchUserPostImpl : SearchUserPost {
    private let userPostRepository: UserPostRepository
    let notificationUseCase: NotificationCenter
    static let nameNotificationUseCase =  Notification.Name(String(describing: SearchUserPostImpl.self))
    private static let nameNotificationUser = Notification.Name("dataDetail")
    
    
    init(notificationUseCase: NotificationCenter, userPostRepository: UserPostRepository) {
        self.userPostRepository = userPostRepository
        self.notificationUseCase = notificationUseCase
        self.addObserverRepository()
    }

    
    func search(input: SearchUserPostInput) {
        userPostRepository.getUsersPostLocal(nameNotification: Self.nameNotificationUser, userId: input.userId)
    }
    
    
    private func addObserverRepository() {
        
        // Notifica cuando termina de recuperar un user post
        userPostRepository.notificationData.addObserver(forName: Self.nameNotificationUser, object: nil, queue: .main) { notification in
            let responseSearchUsersPostRepository = notification.object as! UserPostRepositoryResponse
            let responseUseCase: SearchUserPostResponse = {
                let userPosts = try responseSearchUsersPostRepository()
                return userPosts.map { SearchUserPostOutput(title: $0.title, body: $0.body)  }
            }
            
            self.notifyObserver(nameNotification: Self.nameNotificationUseCase, object: responseUseCase)
        }
    }
    
    
    private func notifyObserver(nameNotification: Notification.Name?, object: Any) {
        if let nameNotification = nameNotification {
            self.notificationUseCase.post(name: nameNotification, object: object)
        }
        else {
            let notification = Notification(name: Notification.Name(String(describing: UserRepository.self)), object: object)
            self.notificationUseCase.post(notification)
        }
    }
}



typealias SearchUserPostResponse = () throws -> [SearchUserPostOutput]
