//
//  ManagedUser+CoreDataClass.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 27/09/22.
//

import Foundation
import CoreData



public class ManagedUser : NSManagedObject {
    func toModel() -> User {
        return User(id: Int(id), name: name, phone: phone, emial: email)
    }
    
    
    func fromModel(user: User) {
        id = Int32(user.id)
        name = user.name
        phone = user.phone
        email = user.emial
    }
}
