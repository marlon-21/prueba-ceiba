//
//  Post.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 1/10/22.
//

import Foundation



class Post {
    var id: Int
    var userId: Int
    var title: String
    var body: String
    
    
    init(id: Int, userId: Int, title: String, body: String) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }
}

