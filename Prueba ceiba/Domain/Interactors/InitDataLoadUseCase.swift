//
//  BusquedaArtistaInteractor.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 2/10/22.
//

import Foundation



// MARK: Protocol Use Case

protocol InitDataLoad {
    
    var notificationUseCase: NotificationCenter { get }
    static var nameNotificationUseCase: Notification.Name { get }
    //associatedtype Input
    //associatedtype Output: Observable
    
    func load()
}



class InitDataLoadImpl : InitDataLoad {
    
    private let userRepository: UserRepository
    private let userPostRepository: UserPostRepository
    let notificationUseCase: NotificationCenter
    static let nameNotificationUseCase =  Notification.Name(String(describing: InitDataLoadImpl.self))
    private static let nameNotificationUser = Notification.Name("data")
    private static let nameNotificationLocal = Notification.Name("local")
    private static let nameNotificationPost = Notification.Name("data2")
    private static let nameNotificationPostLocal = Notification.Name("local2")
    private var response: [SearchUserOutput]?

    
    
    init(notificationUseCase: NotificationCenter, userRepository: UserRepository, userPostRepository: UserPostRepository) {
        self.userRepository = userRepository
        self.userPostRepository = userPostRepository
        self.notificationUseCase = notificationUseCase
        self.addObserverRepository()
    }
    
    
    deinit {
        userRepository.notificationData.removeObserver(Self.nameNotificationUser)
        userRepository.notificationData.removeObserver(Self.nameNotificationLocal)
        userPostRepository.notificationData.removeObserver(Self.nameNotificationPost)
        userPostRepository.notificationData.removeObserver(Self.nameNotificationPostLocal)
    }
    
    
    // MARK: - Use Case logic
    
    func load() {
        fetchUserData()
    }
    
    
    private func fetchUserData() {
        userRepository.getUsersLocal(nameNotification: Self.nameNotificationLocal)
    }
    
    
    private func dowloadUserData() {
        userRepository.getUsersWeb(nameNotification: Self.nameNotificationUser)
    }
    
    
    private func saveUserData(usersToSave: [User]) {
        userRepository.saveUsers(nameNotification: nil, usersToSave: usersToSave)
    }
    
    
    private func dowloadAssociatedData() {
        userPostRepository.getUserPostsWeb(nameNotification: Self.nameNotificationPost)
    }
    
    
    private func saveAssociatedData(usersPostsWeb: [Post]) {
        userPostRepository.saveUserPosts(nameNotification: Self.nameNotificationPostLocal, userPostsToSave: usersPostsWeb)
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
    
    
    private func addObserverRepository() {
        print("Marlon >>>>>>>>>> Agrego los observer de InitDataLoad")

        userRepository.notificationData.addObserver(forName: Self.nameNotificationLocal, object: nil, queue: .main) { notification in
            let responseGetUsersLocal = notification.object as! UserRepositoryResponse
            
            //Regla de negocio: Si hay datos locales muestrelos sino descargelos
            let usersLocal = try? responseGetUsersLocal()
            
            if let usersLocal = usersLocal, !usersLocal.isEmpty {
                
                let responseUseCase: InitDataLoadResponse = { () throws -> [SearchUserOutput] in
                    usersLocal.map { SearchUserOutput(id: $0.id, name: $0.name, phone: $0.phone, email: $0.emial) }
                }
                
                self.notifyObserver(nameNotification: Self.nameNotificationUseCase, object: responseUseCase)
            }
            else {
                self.dowloadUserData()
            }
            
            //Fin regla de negocio
        }
        
        // Notifica cuando termina de descargar usuarios
        userRepository.notificationData.addObserver(forName: Self.nameNotificationUser, object: nil, queue: .main) { notification in
            let responseGetUsersWebRepository = notification.object as! UserRepositoryResponse
            
            //Regla de negocio: Si descarga datos por primera vez almacenelos local y muestrelos
            let usersWeb = try? responseGetUsersWebRepository()
            
            if let usersWeb = usersWeb {
                self.response = usersWeb.map { SearchUserOutput(id: $0.id, name: $0.name, phone: $0.phone, email: $0.emial) }
                self.saveUserData(usersToSave: usersWeb)
                self.dowloadAssociatedData()
            }
            else {
                let responseUseCase: InitDataLoadResponse = { throw InitDataLoadError.CannotDowloadData("No se pudo descargar los usuarios") }
                self.notifyObserver(nameNotification: Self.nameNotificationUseCase, object: responseUseCase)
            }
            //Fin regla de negocio
        }
        
        // Notifica cuando termina de descargar los datos asociados
        userPostRepository.notificationData.addObserver(forName: Self.nameNotificationPost, object: nil, queue: .main) { notification in
            let responseGetUserPostsWebRepository = notification.object as! UserPostRepositoryResponse
            let userPostsWeb = try? responseGetUserPostsWebRepository()
            
            if let userPostsWeb = userPostsWeb {
                self.saveAssociatedData(usersPostsWeb: userPostsWeb)
            }
            else {
                let responseUseCase: InitDataLoadResponse = { throw InitDataLoadError.CannotDowloadAssociatedData("No se pudo descargar datos asociados") }
                self.notifyObserver(nameNotification: Self.nameNotificationUseCase, object: responseUseCase)
            }
        }
        
        // Notifica cuando termina de guardar los datos asociados
        userRepository.notificationData.addObserver(forName: Self.nameNotificationPostLocal, object: nil, queue: .main) { notification in
            let responseSaveAssociatedDataRepository = notification.object as! UserPostRepositoryResponse
            let userPostsWeb = try? responseSaveAssociatedDataRepository()
            
            if userPostsWeb != nil {
                let responseUseCase: InitDataLoadResponse = { return self.response! }
                self.notifyObserver(nameNotification: Self.nameNotificationUseCase, object: responseUseCase)
            }
            else {
                let responseUseCase: InitDataLoadResponse = { throw InitDataLoadError.CannotSaveAssociated("No se pudo guardar datos asociados") }
                self.notifyObserver(nameNotification: Self.nameNotificationUseCase, object: responseUseCase)
            }
        }
    }
}



enum InitDataLoadError : Equatable, Error {
    case CannotDowloadData(String)
    case CannotDowloadAssociatedData(String)
    case CannotSaveAssociated(String)
}



typealias InitDataLoadResponse = () throws -> [SearchUserOutput]
