//
//  UserPostRepository.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 2/10/22.
//

import Foundation



protocol UserPostRepository {
    
    var notificationData: NotificationCenter { get }
    
    func getUserPostsWeb(nameNotification: Notification.Name?)
    func getUsersPostLocal(nameNotification: Notification.Name?, userId: Int?)
    func saveUserPosts(nameNotification: Notification.Name?, userPostsToSave: [Post])
}
