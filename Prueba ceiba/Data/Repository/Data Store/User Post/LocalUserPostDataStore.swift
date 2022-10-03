//
//  LocalUserPostDataStore.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 1/10/22.
//

import Foundation
import CoreData
import UIKit



class LocalUserPostDataSotre : UserPostDataStore {   
    
    var mainManagedObjectContext: NSManagedObjectContext
    var privateManagedObjectContext: NSManagedObjectContext
    private static let ENTITY_NAME = "ManagedUserPost"
    
    
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
    
    
    func fetchPost(userPostToFetch: Int?, completionHandler: @escaping StoreFetchPostCompletionHandler) {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Self.ENTITY_NAME)
                
                if let userPostToFetch = userPostToFetch {
                    fetchRequest.predicate = NSPredicate(format: "userId == %@", String(userPostToFetch))
                }
                
                let result = try self.privateManagedObjectContext.fetch(fetchRequest) as! [ManagedUserPost]
                
                if result.count > 0 {
                    let posts = result.map { $0.toModel() }
                    completionHandler(UserPostStoreResult.Success(result: posts))
                }
                else {
                    completionHandler(UserPostStoreResult.Success(result: [Post]()))
                }
            }
            catch {
                completionHandler(UserPostStoreResult.Failure(error: UserPostError.CannotFetch("No se pudo recuperar las publicaciones")))
            }
        }
    }
    
    
    func createPosts(userPostToCreate: [Post], completionHandler: @escaping StoreCreatePostsCompletionHandler) {
        privateManagedObjectContext.perform {
            do {
                userPostToCreate.forEach { postToCreate in
                    let managedPost = NSEntityDescription.insertNewObject(forEntityName: Self.ENTITY_NAME, into: self.privateManagedObjectContext) as! ManagedUserPost
                    managedPost.fromModel(post: postToCreate)
                }
                //print("Marlon =============== voy a guardar \(userPostToCreate.count) Post")
                try self.privateManagedObjectContext.save()
                completionHandler(UserPostStoreResult.Success(result: userPostToCreate))
            }
            catch {
                completionHandler(UserPostStoreResult.Failure(error: UserPostError.CannotCreate("No se pudo crear los usuarios")))
            }
        }
    }
    
    func createPost(userPostToCreate: Post, completionHandler: @escaping StoreCreatePostCompletionHandler) {}
    
    func updatePost(userPostToUpdate: Post, completionHandler: @escaping StoreUpdatePostCompletionHandler) {}
    
    func deletePost(userPostToDelete: Post, completionHandler: @escaping StoreDeletePostCompletionHandler) {}
}
