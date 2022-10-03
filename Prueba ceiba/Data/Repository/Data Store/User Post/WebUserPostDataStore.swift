//
//  WebUserPostDataStore.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 2/10/22.
//

import Foundation



class WebUserPostDataStore : UserPostDataStore {
    
    let apiRest: APIRequest<UserPostResource>
    
    
    init(apiRest: APIRequest<UserPostResource>) {
        self.apiRest = apiRest
    }
    
    
    func fetchPost(userPostToFetch: Int?, completionHandler: @escaping StoreFetchPostCompletionHandler) {        
        apiRest.load { postEntity, networkRequestError -> Void in
            guard let postWeb = postEntity else {
                switch networkRequestError! {
                case .RequestFailed(error: let error):
                    completionHandler(UserPostStoreResult.Failure(error: UserPostError.CannotFetch(error)))
                    
                case .DataNil(error: let error):
                    completionHandler(UserPostStoreResult.Failure(error: UserPostError.CannotFetch(error)))
                    
                case .EncodeModelFailed(error: let error):
                    completionHandler(UserPostStoreResult.Failure(error: UserPostError.CannotFetch(error)))
                }
                
                return
            }
            
            let posts = self.createModel(postsWeb: postWeb)
            completionHandler(UserPostStoreResult.Success(result: posts))
        }
    }
    
    func createPosts(userPostToCreate: [Post], completionHandler: @escaping StoreCreatePostsCompletionHandler) {}
    
    func createPost(userPostToCreate: Post, completionHandler: @escaping StoreFetchPostOrOptionalCompletionHandler) {}
    
    func updatePost(userPostToUpdate: Post, completionHandler: @escaping StoreUpdatePostCompletionHandler) {}
    
    func deletePost(userPostToDelete: Post, completionHandler: @escaping StoreDeletePostCompletionHandler) {}
    
    
    private func createModel(postsWeb: UserPostsEntity) -> [Post] {
        var posts = [Post]()
        let postWebCount = postsWeb.count
        
        if postWebCount > 0 {
            for i in 0..<postWebCount {
                let postWeb = postsWeb[i]
                posts.append(Post(id: postWeb.id, userId: postWeb.userId, title: postWeb.title, body: postWeb.body))
            }
        }
        
        return posts
    }
}
