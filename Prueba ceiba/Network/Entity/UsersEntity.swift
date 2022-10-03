//
//  UserEntity.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 28/09/22.
//

struct UsersEntity {
    
    private let users: [UserEntity]
    
    subscript(index: Int) -> UserEntity {
        get {
            return users[index]
        }
    }
    
    let count: Int
    
    
    struct UserEntity {
        let id: Int
        let name: String
        let phone: String
        let email: String
    }
}



extension UsersEntity : Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.users = try container.decode(Array<UserEntity>.self)
        self.count = users.count        
    }
}



extension UsersEntity.UserEntity : Decodable {
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        
        case name = "name"
        
        case email = "email"
        
        case phone = "phone"
    }
    
    
    init(from decoder: Decoder) throws {
        let containerUser = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try containerUser.decode(Int.self, forKey: .id)
        self.name = try containerUser.decode(String.self, forKey: .name)
        self.email = try containerUser.decode(String.self, forKey: .email)
        self.phone = try containerUser.decode(String.self, forKey: .phone)
    }
}
