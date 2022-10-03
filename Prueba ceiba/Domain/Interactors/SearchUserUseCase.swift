//
//  SearchUserUseCase.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 2/10/22.
//

import Foundation



protocol SearchUser {
    
    var notificationUseCase: NotificationCenter { get }
    static var nameNotificationUseCase: Notification.Name { get }
    //associatedtype Input
    //associatedtype Output: Observable
    
    func search(input: SearchUserInput)
    func cancelSearch()
}



class SearchUserImpl : SearchUser {
    
    private let userRepository: UserRepository
    let notificationUseCase: NotificationCenter
    static let nameNotificationUseCase =  Notification.Name(String(describing: SearchUserImpl.self))
    private static let nameNotificationUser = Notification.Name("userSearch")
    
    
    init(notificationUseCase: NotificationCenter, userRepository: UserRepository) {
        self.userRepository = userRepository
        self.notificationUseCase = notificationUseCase
        self.addObserverRepository()
    }
    
    
    deinit {
        userRepository.notificationData.removeObserver(Self.nameNotificationUser)
    }

    
    func search(input: SearchUserInput) {
        userRepository.getUsersLocal(nameNotification: Self.nameNotificationUser, userName: input.userName)
    }
    
    
    private func addObserverRepository() {
        print("Marlon >>>>>>>>>> Agrego los observer de SearchUser")
        
        // Notifica cuando termina de recuperar un user 
        userRepository.notificationData.addObserver(forName: Self.nameNotificationUser, object: nil, queue: .main) { notification in
            let responseSearchUsersRepository = notification.object as! UserRepositoryResponse
            let responseUseCase: SearchUserResponse = {
                let users = try responseSearchUsersRepository()
                return users.map { SearchUserOutput(id: $0.id, name: $0.name, phone: $0.phone, email: $0.emial)  }
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
    
    
    func cancelSearch() {
        userRepository.getUsersLocal(nameNotification: Self.nameNotificationUser)
    }
}



typealias SearchUserResponse = () throws -> [SearchUserOutput]
