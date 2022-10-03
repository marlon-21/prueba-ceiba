//
//  UserRepositoryImpl.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 27/09/22.
//

import Foundation



/**
 Esta clase implementa un repository cualquiera expuesto en la capa de dominio. Cada repository expuesto debe ser implementado únicamente en esta capa.
 */

//MARK: Repository implementación

class UserRepositoryImpl : UserRepository {
    
    let notificationData: NotificationCenter
    private let dataStoreFactory: any DataStoreFactory
    
    
    init(dataStoreFactory: any DataStoreFactory, notificationData: NotificationCenter) {
        self.dataStoreFactory = dataStoreFactory
        self.notificationData = notificationData
    }
    
    
    func getUsersWeb(nameNotification: Notification.Name?) {
        let userDataStore = dataStoreFactory.createCloudDataStore()! as! UserDataStore
    
        userDataStore.fetchUser(userToFetch: nil) { userDataStoreResult in
            if case let .Success(users) = userDataStoreResult {             
                let responseRepository: UserRepositoryResponse = { () throws -> [User] in
                   return users!
                }
                
                self.notifyObserver(nameNotification: nameNotification, object: responseRepository)
            }
            else if case let .Failure(error) = userDataStoreResult {
                if case let .CannotFetch(errorMessage) = error {
                    let responseRepository: UserRepositoryResponse = { throw UserStoreError.CannotFetch(errorMessage) }
                    self.notifyObserver(nameNotification: nameNotification, object: responseRepository)
                }
            }
        }
    }
    
    
    func getUsersLocal(nameNotification: Notification.Name?) {
        let dataStore = dataStoreFactory.createLocalDataStore()! as! UserDataStore
        dataStore.fetchUser(userToFetch: nil) { dataStoreResult in
            if case let .Success(users) = dataStoreResult {
                let responseRepository: UserRepositoryResponse = { () throws -> [User] in
                   return users!
                }
                
                self.notifyObserver(nameNotification: nameNotification, object: responseRepository)
            }
            else if case let .Failure(error) = dataStoreResult {
                if case let .CannotFetch(errorMessage) = error {
                    let responseRepository: UserRepositoryResponse = { throw UserStoreError.CannotFetch(errorMessage) }
                    self.notifyObserver(nameNotification: nameNotification, object: responseRepository)
                }
            }
        }
    }
    
    
    func getUsersLocal(nameNotification: Notification.Name?, userName: String) {
        let dataStore = dataStoreFactory.createLocalDataStore()! as! UserDataStore
        dataStore.fetchUser(userToFetch: userName) { dataStoreResult in
            if case let .Success(users) = dataStoreResult {
                let responseRepository: UserRepositoryResponse = { () throws -> [User] in
                   return users!
                }
                
                self.notifyObserver(nameNotification: nameNotification, object: responseRepository)
            }
            else if case let .Failure(error) = dataStoreResult {
                if case let .CannotFetch(errorMessage) = error {
                    let responseRepository: UserRepositoryResponse = { throw UserStoreError.CannotFetch(errorMessage) }
                    self.notifyObserver(nameNotification: nameNotification, object: responseRepository)
                }
            }
        }
    }
    
    
    func saveUsers(nameNotification: Notification.Name?, usersToSave: [User]) {
        let dataStore = dataStoreFactory.createLocalDataStore() as! UserDataStore
        
        dataStore.createUsers(usersToCreate: usersToSave) { dataStoreResult in
            if case let .Success(users) = dataStoreResult {
                let responseRepository: UserRepositoryResponse = { () throws -> [User] in
                   return users!
                }
                
                self.notifyObserver(nameNotification: nameNotification, object: responseRepository)
            }
            else if case let .Failure(error) = dataStoreResult {
                if case let .CannotCreate(errorMessage) = error {
                    let responseRepository: UserRepositoryResponse = { throw UserStoreError.CannotCreate(errorMessage) }
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



typealias UserRepositoryResponse = () throws -> [User]
