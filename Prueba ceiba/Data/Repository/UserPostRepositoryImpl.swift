//
//  UserPostRepository.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 2/10/22.
//

import Foundation



class UserPostRepositoryImpl : UserPostRepository {
    
    
    let notificationData: NotificationCenter
    private let dataStoreFactory: any DataStoreFactory
    
    
    init(dataStoreFactory: any DataStoreFactory, notificationData: NotificationCenter) {
        self.dataStoreFactory = dataStoreFactory
        self.notificationData = notificationData
    }
    
    
    func getUsersPostLocal(nameNotification: Notification.Name?, userId: Int?) {
        let dataStore = dataStoreFactory.createLocalDataStore()! as! UserPostDataStore
    
        dataStore.fetchPost(userPostToFetch: userId) { dataStoreResult in
            if case let .Success(posts) = dataStoreResult {
                let responseRepository: UserPostRepositoryResponse = { () throws -> [Post] in
                   return posts!
                }
                
                self.notifyObserver(nameNotification: nameNotification, object: responseRepository)
            }
            else if case let .Failure(error) = dataStoreResult {
                if case let .CannotFetch(errorMessage) = error {
                    let responseRepository: UserPostRepositoryResponse = { throw UserStoreError.CannotFetch(errorMessage) }
                    self.notifyObserver(nameNotification: nameNotification, object: responseRepository)
                }
            }
        }
    }
    
    
    func saveUserPosts(nameNotification: Notification.Name?, userPostsToSave: [Post]) {
        let dataStore = dataStoreFactory.createLocalDataStore() as! UserPostDataStore
        
        dataStore.createPosts(userPostToCreate: userPostsToSave) { dataStoreResult in
            if case let .Success(posts) = dataStoreResult {
                let responseRepository: UserPostRepositoryResponse = { () throws -> [Post] in
                   return posts!
                }
                
                self.notifyObserver(nameNotification: nameNotification, object: responseRepository)
            }
            else if case let .Failure(error) = dataStoreResult {
                if case let .CannotCreate(errorMessage) = error {
                    let responseRepository: UserPostRepositoryResponse = { throw UserStoreError.CannotCreate(errorMessage) }
                    self.notifyObserver(nameNotification: nameNotification, object: responseRepository)
                }
            }
        }
    }
    
    
    func getUserPostsWeb(nameNotification: Notification.Name?) {
        let dataStore = dataStoreFactory.createCloudDataStore()! as! UserPostDataStore
    
        dataStore.fetchPost(userPostToFetch: nil) { dataStoreResult in
            if case let .Success(posts) = dataStoreResult {
                let responseRepository: UserPostRepositoryResponse = { () throws -> [Post] in
                   return posts!
                }
                
                self.notifyObserver(nameNotification: nameNotification, object: responseRepository)
            }
            else if case let .Failure(error) = dataStoreResult {
                if case let .CannotFetch(errorMessage) = error {
                    let responseRepository: UserPostRepositoryResponse = { throw UserStoreError.CannotFetch(errorMessage) }
                    self.notifyObserver(nameNotification: nameNotification, object: responseRepository)
                }
            }
        }
    }
    
    
    private func notifyObserver(nameNotification: Notification.Name?, object: Any) {
        if let nameNotification = nameNotification {
            self.notificationData.post(name: nameNotification, object: object)
        }
        else {
            let notification = Notification(name: Notification.Name(String(describing: UserRepositoryImpl.self)), object: object)
            self.notificationData.post(notification)
        }
    }   
}


typealias UserPostRepositoryResponse = () throws -> [Post]
