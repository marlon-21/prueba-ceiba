//
//  UserDataStoreFactory.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 27/09/22.
//

/**
 Este protocolo expresa una interfaz pública de un almacén de datos (DataStore) para una entidad de datos especifica (DataEntity), bajo un patron CRUD.
 Cada entidad de datos debe tener su propia implementación de un almacén de datos.
 Un almacén de datos es una abstracción de un almacen tanto local (SQLite, Core data model, etc...) como remoto (API Rest).
 Cada almacén de datos debe tener como máximo dos conformaciones una local y una remota.
 */

protocol UserDataStore {
    func fetchUser(userToFetch: String?, completionHandler: @escaping StoreFetchUserCompletionHandler)
    //func fetchUser(completionHandler: @escaping StoreFetchUsersCompletionHandler)
    
    func createUsers(usersToCreate: [User], completionHandler: @escaping StoreCreateUsersCompletionHandler)
    func createUser(usersToCreate: User, completionHandler: @escaping StoreCreateUserCompletionHandler)

    func updateUser(userToUpdate: User, completionHandler: @escaping StoreUpdateUserCompletionHandler)
    
    func deleteUser(userToDelete: User, completionHandler: @escaping StoreDeleteUserCompletionHandler)
}



// MARK: - User store CRUD operation results

typealias StoreFetchUserCompletionHandler = (UserStoreResult<[User]?>) -> Void
//typealias StoreFetchUserCompletionHandler = (UserStoreResult<User>) -> Void
typealias StoreFetchUserOrOptionalCompletionHandler = (UserStoreResult<User?>) -> Void
typealias StoreCreateUserCompletionHandler = (UserStoreResult<User?>) -> Void
typealias StoreCreateUsersCompletionHandler = (UserStoreResult<[User]?>) -> Void
typealias StoreUpdateUserCompletionHandler = (UserStoreResult<User?>) -> Void
typealias StoreDeleteUserCompletionHandler = (UserStoreResult<User?>) -> Void



enum UserStoreResult<U> {
    case Success(result: U)
    case Failure(error: UserStoreError)
}



//MARK: - User store CRUD operation errors

enum UserStoreError : Equatable, Error {
    case CannotFetch(String)
    case CannotCreate(String)
    case CannotUpdate(String)
    case CannotDelete(String)
}



func ==(lhs: UserStoreError, rhs: UserStoreError) -> Bool {
    switch (lhs, rhs) {
        case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
        case (.CannotCreate(let a), .CannotCreate(let b)) where a == b: return true
        default: return false
    }
}



/**
 Una conformación por defecto de un almacen especifico.
 */
class UserDataStoreFactoryImpl: DataStoreFactory {
    func createLocalDataStore() -> UserDataStore? {
        LocalUserDataSotre()
    }
    
    
    func createCloudDataStore() -> UserDataStore? {
        let resource = UserResource()    
        return WebUsersDataStore(apiRest: APIRequest<UserResource>(resource: resource))
    }
}
