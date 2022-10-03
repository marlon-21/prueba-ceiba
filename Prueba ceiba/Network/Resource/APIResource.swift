//
//  APIResource.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 02/10/22.
//

import Foundation



protocol APIResource {
    
    associatedtype ModelType: Decodable
    //associatedtype RequestModelType
    static var methodPath: String { get }
    var param: [URLQueryItem]? { get }    
    static var urlBase: String { get }
    var request: URLRequest { get }
    var bodyRequest: Any? { get set }
}



extension APIResource {
     var url: URL {
        var components = URLComponents(string: Self.urlBase)!
        components.path = Self.methodPath
        components.queryItems = param
        
        return components.url!
    }
    
    
    static func createBasicAuth(username: String, password: String) -> String {
        let basicAuthCredential = String(format: "%@:%@", username, password)
        return "Basic \(basicAuthCredential.data(using: String.Encoding.utf8)!.base64EncodedString())"
    }
    
    
    static func createBearerAuth(token: String) -> String {
        return "Bearer \(token)"
    }
    
    
    static func createFormUrlencodedBody(data: [String : String]) -> Data {
        var dataString = String()
        let separador = "&"
        let concatenador = "="
        
        for (key, value) in data {
            dataString += key + concatenador + value + separador
        }
        
        return dataString.dropLast().data(using: String.Encoding.utf8)!
    }    
}
