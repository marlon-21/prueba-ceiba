//
//  UserPostResource.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 1/10/22.
//

import Foundation



class UserPostResource : APIResource {
    
    typealias ModelType = UserPostsEntity
    static let urlBase: String = "https://jsonplaceholder.typicode.com"
    static let methodPath: String = "/posts"
    var param: [URLQueryItem]? = nil
    var bodyRequest: Any? = nil
    
        
    var request: URLRequest {
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 5.0
        //request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        return request
    }
}
