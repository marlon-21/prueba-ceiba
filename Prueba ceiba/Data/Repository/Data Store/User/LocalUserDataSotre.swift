//
//  LocalUserDataSotre.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 30/09/22.
//

import Foundation
import UIKit
import CoreData



class LocalUserDataSotre : UserDataStore {
    
    var mainManagedObjectContext: NSManagedObjectContext
    var privateManagedObjectContext: NSManagedObjectContext
    private static let ENTITY_NAME = "ManagedUser"
    
    
    // MARK: - Object lifecycle
    
    init() {
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        mainManagedObjectContext = container.viewContext;
        privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.parent = mainManagedObjectContext
    }
    
    
    deinit {
        do {
            try self.mainManagedObjectContext.save() //Guarda en ùltimo antes de la salida en memoria
        }
        catch {
            fatalError("Error deinitializing main managed object context")
        }
    }
    
    
    func fetchUser(userToFetch: String?, completionHandler: @escaping StoreFetchUserCompletionHandler) {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Self.ENTITY_NAME)
                if let userToFetch = userToFetch {
                    fetchRequest.predicate = NSPredicate(format: "name CONTAINS %@", userToFetch)
                }
                
                let result = try self.privateManagedObjectContext.fetch(fetchRequest) as! [ManagedUser]
                
                if result.count > 0  {
                    let users = result.map { return $0.toModel() }
                    completionHandler(UserStoreResult.Success(result: users))
                }
                else {
                    completionHandler(UserStoreResult.Success(result: [User]()))
                }
            }
            catch {
                completionHandler(UserStoreResult.Failure(error: UserStoreError.CannotFetch("No se pudo recuperar los usuarios")))
            }
        }
    }
    
    func createUsers(usersToCreate: [User], completionHandler: @escaping StoreCreateUsersCompletionHandler) {
        privateManagedObjectContext.perform {
            do {
                usersToCreate.forEach { userToCreate in
                    let managedUser = NSEntityDescription.insertNewObject(forEntityName: Self.ENTITY_NAME, into: self.privateManagedObjectContext) as! ManagedUser
                    managedUser.fromModel(user: userToCreate)
                }
               
                try self.privateManagedObjectContext.save()
                completionHandler(UserStoreResult.Success(result: usersToCreate))
            }
            catch {
                completionHandler(UserStoreResult.Failure(error: UserStoreError.CannotCreate("No se pudo almacenar los usuarios")))
            }
        }
    }    
    
    func createUser(usersToCreate: User, completionHandler: @escaping StoreCreateUserCompletionHandler) {}
    
    func updateUser(userToUpdate: User, completionHandler: @escaping StoreUpdateUserCompletionHandler) {}
    
    func deleteUser(userToDelete: User, completionHandler: @escaping StoreDeleteUserCompletionHandler) {}   
}



/*class UserCoreDataImpl : UserCoreData {
    
    var mainManagedObjectContext: NSManagedObjectContext
    var privateManagedObjectContext: NSManagedObjectContext
    private static let ENTITY_NAME = "ManagedToken"
    
        
    // MARK: - Object lifecycle
    init() {
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        mainManagedObjectContext = container.viewContext;
        privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.parent = mainManagedObjectContext
    }
    
    
    deinit {
        do {
            try self.mainManagedObjectContext.save() //Guarda en ùltimo antes de la salida en memoria
        }
        catch {
            fatalError("Error deinitializing main managed object context")
        }
    }
    
    
    func createToken(tokenToCreate: Token, completionHandler: @escaping (() throws -> Token?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let managedToken = NSEntityDescription.insertNewObject(forEntityName: Self.ENTITY_NAME, into: self.privateManagedObjectContext) as! ManagedToken
                managedToken.fromModel(token: tokenToCreate)
                try self.privateManagedObjectContext.save()
                completionHandler { return tokenToCreate }
            }
            catch {
                completionHandler { throw TokenCoreDataError.CoreDataError("No se pudo crear el token") }
            }
        }
    }
    
    
    func fetchToken(completionHandler: @escaping (() throws -> Token?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Self.ENTITY_NAME)
                let results = try self.privateManagedObjectContext.fetch(fetchRequest) as! [ManagedToken]
                
                if let token = results.first?.toModel() {
                    completionHandler{ return token }
                }
                else {
                    completionHandler { return nil }
                }
            }
            catch {
                completionHandler { throw TokenCoreDataError.CoreDataError("No se pudo recuperar el token") }
            }
        }
    }
    
    
    func updateToken(tokenToUpdate: Token, completionHandler: @escaping (() throws -> Token?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Self.ENTITY_NAME)
                let results = try self.privateManagedObjectContext.fetch(fetchRequest) as! [ManagedToken]
                
                if let managedToken = results.first {
                    do {
                        managedToken.fromModel(token: tokenToUpdate)
                        let token = managedToken.toModel()
                        try self.privateManagedObjectContext.save()
                        completionHandler { return token }
                    }
                    catch {
                        completionHandler { throw TokenCoreDataError.CoreDataError("No se pudo actualizar el token") }
                    }
                }
            }
            catch {
                completionHandler { throw TokenCoreDataError.CoreDataError("No se pudo actualizar el token") }
            }
        }
    }
    
    
    func createToken(tokenToCreate: Token, completionHandler: @escaping (Token?, TokenCoreDataError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let managedToken = NSEntityDescription.insertNewObject(forEntityName: Self.ENTITY_NAME, into: self.privateManagedObjectContext) as! ManagedToken
                managedToken.fromModel(token: tokenToCreate)
                try self.privateManagedObjectContext.save()
                completionHandler(tokenToCreate, nil)
            }
            catch {
                completionHandler(nil, TokenCoreDataError.CoreDataError("No se pudo crear el token"))
            }
        }
    }
    
    
    func fetchToken(completionHandler: @escaping (Token?, TokenCoreDataError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Self.ENTITY_NAME)
                let result = try self.privateManagedObjectContext.fetch(fetchRequest) as! [ManagedToken]
                
                if let token = result.first?.toModel() {
                    completionHandler(token, nil)
                }
                else {
                    completionHandler(nil, nil) //No es un error se recupero nil
                }
            }
            catch {
                completionHandler(nil, TokenCoreDataError.CoreDataError("No se pudo recuperar el token"))
            }
        }
    }
    
    
    /*func createToken(tokenToCreate: Token, completionHandler: @escaping StoreCreateTokenCompletionHandler) {
        privateManagedObjectContext.perform {
            do {
                let managedToken = NSEntityDescription.insertNewObject(forEntityName: Self.ENTITY_NAME, into: self.privateManagedObjectContext) as! ManagedToken
                managedToken.fromModel(token: tokenToCreate)
                try self.privateManagedObjectContext.save()
                completionHandler(TokenStoreResult.Success(result: tokenToCreate))
            }
            catch {
                completionHandler(TokenStoreResult.Failure(error: TokenCoreDataError.CoreDataError("No se pudo recuperar el token")))
            }
        }

    }*/
    
    
    /*func fetchToken(completionHandler: @escaping StoreFetchTokenCompletionHandler) {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Self.ENTITY_NAME)
                let result = try self.privateManagedObjectContext.fetch(fetchRequest) as! [ManagedToken]
                
                if let token = result.first?.toModel() {
                    completionHandler(TokenStoreResult.Success(result: token))
                }
                else {
                    completionHandler(TokenStoreResult.Failure(error: TokenCoreDataError.CoreDataError("No hay token almacenado")))
                }
            }
            catch {
                completionHandler(TokenStoreResult.Failure(error: TokenCoreDataError.CoreDataError("No se pudo recuperar el token")))
            }
        }
    }*/
    
    
    /*func updateToken(tokenToUpdate: Token, completionHandler: @escaping TokenStoreUpdateTokenCompletionHandler) {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Self.ENTITY_NAME)
                let results = try self.privateManagedObjectContext.fetch(fetchRequest) as! [ManagedToken]
                
                if let managedToken = results.first { //SE PUEDE QUITAR EL DOBLE CATH???
                    do {
                        managedToken.fromModel(token: tokenToUpdate)
                        let token = managedToken.toModel()
                        try self.privateManagedObjectContext.save()
                        completionHandler(TokenStoreResult.Success(result: token))
                    }
                    catch {
                        completionHandler(TokenStoreResult.Failure(error: TokenStoreError.CannotUpdate("No se pudo actualizar el token")))
                    }
                }
            }
            catch {
                 completionHandler(TokenStoreResult.Failure(error: TokenStoreError.CannotUpdate("No se pudo actualizar el token")))
            }
        }
    }*/
    
    
    func updateToken(tokenToUpdate: Token, completionHandler: @escaping (Token?, TokenCoreDataError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Self.ENTITY_NAME)
                let results = try self.privateManagedObjectContext.fetch(fetchRequest) as! [ManagedToken]
                
                if let managedToken = results.first { //SE PUEDE QUITAR EL DOBLE CATH???
                    do {
                        managedToken.fromModel(token: tokenToUpdate)
                        let token = managedToken.toModel()
                        try self.privateManagedObjectContext.save()
                        completionHandler(token, nil)
                    }
                    catch {
                        completionHandler(nil, TokenCoreDataError.CoreDataError("No se pudo actualizar el token"))
                    }
                }
            }
            catch {
                 completionHandler(nil, TokenCoreDataError.CoreDataError("No se pudo actualizar el token"))
            }
        }
    }
}*/

