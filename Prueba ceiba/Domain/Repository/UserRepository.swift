//
//  UserRepository.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 28/09/22.
//

import Foundation



protocol UserRepository {
    
    var notificationData: NotificationCenter { get }       
    
    
    func getUsersWeb(nameNotification: Notification.Name?) /*-> ArtistRepositoryResponse*/
    func getUsersLocal(nameNotification: Notification.Name?)
    func saveUsers(nameNotification: Notification.Name?, usersToSave: [User])
    func getUsersLocal(nameNotification: Notification.Name?, userName: String)
}



//typealias ArtistRepositoryResponse = ObservableImpl<() throws -> [ResponseArtist.Artist]>
//typealias ArtistRepositoryResponse = () throws -> [ResponseArtist.Artist]
