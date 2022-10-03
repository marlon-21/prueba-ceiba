//
//  WebUserstDataStore.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 27/09/22.
//

/**
 Una conformación de un almacen de datos cualquiera del tipo remoto.
 */

class WebUsersDataStore : UserDataStore {
    
    let apiRest: APIRequest<UserResource>
    
    
    init(apiRest: APIRequest<UserResource>) {
        self.apiRest = apiRest
    }
    
    
    func fetchUser(userToFetch: String?, completionHandler: @escaping StoreFetchUserCompletionHandler) {        
        apiRest.load { usersEntity, networkRequestError -> Void in
            guard let usersWeb = usersEntity else {
                switch networkRequestError! {
                case .RequestFailed(error: let error):
                    completionHandler(UserStoreResult.Failure(error: UserStoreError.CannotFetch(error)))
                    
                case .DataNil(error: let error):
                    completionHandler(UserStoreResult.Failure(error: UserStoreError.CannotFetch(error)))
                    
                case .EncodeModelFailed(error: let error):
                    completionHandler(UserStoreResult.Failure(error: UserStoreError.CannotFetch(error)))
                }
                
                return
            }
            
            let users = self.createModel(usersWeb: usersWeb)
            completionHandler(UserStoreResult.Success(result: users))
        }
    }
    
    func createUsers(usersToCreate: [User], completionHandler: @escaping StoreCreateUsersCompletionHandler) {}
    
    func createUser(usersToCreate: User, completionHandler: @escaping StoreCreateUserCompletionHandler) {}
    
    func updateUser(userToUpdate: User, completionHandler: @escaping StoreUpdateUserCompletionHandler) {}
    
    func deleteUser(userToDelete: User, completionHandler: @escaping StoreDeleteUserCompletionHandler) {}
    
    
    private func createModel(usersWeb: UsersEntity) -> [User] {
        var users = [User]()
        let usersWebCount = usersWeb.count
        
        if usersWebCount > 0 {
            for i in 0..<usersWebCount {
                let userWeb = usersWeb[i]
                users.append(User(id: userWeb.id, name: userWeb.name, phone: userWeb.phone, emial: userWeb.email))
            }
        }
        
        return users
    }
}
