//
//  UserPostEntity.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 1/10/22.
//

import Foundation



struct UserPostsEntity {
    
    private let posts: [UserPostEntity]
    
    subscript(index: Int) -> UserPostEntity {
        get {
            return posts[index]
        }
    }
    
    let count: Int
    
    
    struct UserPostEntity {
        let id: Int
        let userId: Int
        let title: String
        let body: String
    }
}



extension UserPostsEntity : Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.posts = try container.decode(Array<UserPostEntity>.self)
        self.count = posts.count
    }
}



extension UserPostsEntity.UserPostEntity : Decodable {
    
    enum CodingKeys : String, CodingKey {
        case userId = "userId"
        
        case id = "id"
        
        case title = "title"
        
        case body = "body"
    }
    
    
    init(from decoder: Decoder) throws {
        let containerUser = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try containerUser.decode(Int.self, forKey: .userId)
        self.id = try containerUser.decode(Int.self, forKey: .id)
        self.title = try containerUser.decode(String.self, forKey: .title)
        self.body = try containerUser.decode(String.self, forKey: .body)
    }
}

