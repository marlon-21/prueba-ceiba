//
//  ManagedUser+CoreDataProperties.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 27/09/22.
//

import Foundation
import CoreData



extension ManagedUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedUser> {
        return NSFetchRequest<ManagedUser>(entityName: "ManagedUser")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String
    @NSManaged public var phone: String
    @NSManaged public var email: String
}
