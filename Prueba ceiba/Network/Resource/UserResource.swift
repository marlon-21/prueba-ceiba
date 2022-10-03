//
//  ArtistaResource.swift
//  Spotify
//
//  Created by Marlon Alfonso Beltran Sanchez on 23/12/19.
//  Copyright © 2019 Pragma. All rights reserved.
//

import Foundation



class UserResource : APIResource {
    
    typealias ModelType = UsersEntity
    static let urlBase: String = "https://jsonplaceholder.typicode.com"
    static let methodPath: String = "/users"
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
