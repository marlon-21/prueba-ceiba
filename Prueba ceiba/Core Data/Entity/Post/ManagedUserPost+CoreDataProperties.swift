//
//  ManagedUserPost+CoreDataProperties.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 1/10/22.
//
import Foundation
import CoreData



extension ManagedUserPost {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedUser> {
        return NSFetchRequest<ManagedUser>(entityName: "ManagedPost")
    }

    @NSManaged public var id: Int32
    @NSManaged public var userId: Int32
    @NSManaged public var title: String
    @NSManaged public var body: String
}
