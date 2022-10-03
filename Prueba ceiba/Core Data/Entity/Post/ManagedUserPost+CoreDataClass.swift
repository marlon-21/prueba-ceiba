//
//  ManagedUserPost+CoreDataClass.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 1/10/22.
//

import Foundation
import CoreData



public class ManagedUserPost : NSManagedObject {
    func toModel() -> Post {
        return Post(id: Int(id), userId: Int(userId), title: title, body: body)
    }
    
    
    func fromModel(post: Post) {
        id = Int32(post.id)
        userId = Int32(post.userId)
        title = post.title
        body = post.body
    }
}
