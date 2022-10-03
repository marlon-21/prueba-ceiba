//
//  UserPostDataStoreFactoryImpl.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 1/10/22.
//

import Foundation



/**
 Este protocolo expresa una interfaz pública de un almacén de datos (DataStore) para una entidad de datos especifica (DataEntity), bajo un patron CRUD.
 Cada entidad de datos debe tener su propia implementación de un almacén de datos.
 Un almacén de datos es una abstracción de un almacen tanto local (SQLite, Core data model, etc...) como remoto (API Rest).
 Cada almacén de datos debe tener como máximo dos conformaciones una local y una remota.
 */

protocol UserPostDataStore {
    func fetchPost(userPostToFetch: Int?, completionHandler: @escaping StoreFetchPostCompletionHandler)
    //func fetchUser(completionHandler: @escaping StoreFetchUsersCompletionHandler)
    
    func createPosts(userPostToCreate: [Post], completionHandler: @escaping StoreCreatePostsCompletionHandler)
    func createPost(userPostToCreate: Post, completionHandler: @escaping StoreFetchPostOrOptionalCompletionHandler)

    func updatePost(userPostToUpdate: Post, completionHandler: @escaping StoreUpdatePostCompletionHandler)
    
    func deletePost(userPostToDelete: Post, completionHandler: @escaping StoreDeletePostCompletionHandler)
}



// MARK: - User store CRUD operation results

typealias StoreFetchPostCompletionHandler = (UserPostStoreResult<[Post]?>) -> Void
//typealias StoreFetchUserCompletionHandler = (UserStoreResult<User>) -> Void
typealias StoreFetchPostOrOptionalCompletionHandler = (UserPostStoreResult<Post?>) -> Void
typealias StoreCreatePostCompletionHandler = (UserPostStoreResult<Post?>) -> Void
typealias StoreCreatePostsCompletionHandler = (UserPostStoreResult<[Post]?>) -> Void
typealias StoreUpdatePostCompletionHandler = (UserPostStoreResult<Post?>) -> Void
typealias StoreDeletePostCompletionHandler = (UserPostStoreResult<Post?>) -> Void



enum UserPostStoreResult<U> {
    case Success(result: U)
    case Failure(error: UserPostError)
}



//MARK: - User store CRUD operation errors

enum UserPostError : Equatable, Error {
    case CannotFetch(String)
    case CannotCreate(String)
    case CannotUpdate(String)
    case CannotDelete(String)
}



func ==(lhs: UserPostError, rhs: UserPostError) -> Bool {
    switch (lhs, rhs) {
        case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
        case (.CannotCreate(let a), .CannotCreate(let b)) where a == b: return true
        default: return false
    }
}



/**
 Una conformación por defecto de un almacen especifico.
 */
class UserPostDataStoreFactoryImpl: DataStoreFactory {
    func createLocalDataStore() -> UserPostDataStore? {
        LocalUserPostDataSotre()
    }
    
    
    func createCloudDataStore() -> UserPostDataStore? {
        let resource = UserPostResource()
        return WebUserPostDataStore(apiRest: APIRequest<UserPostResource>(resource: resource))
    }
}

