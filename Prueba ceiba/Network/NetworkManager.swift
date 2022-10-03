//
//  NetworkManager.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 27/09/22.
//

import Foundation
import UIKit



//MARK: Protocol NetworkRequest

protocol NetworkRequest : AnyObject {
    associatedtype ModelType
    
    func decode(_ data: Data) throws -> ModelType?
    func load(withCompletion completion: @escaping (ModelType?, NetworkRequestError?) -> Void)
}



//MARK: Implementación default para NetworkRequest datos (API)

extension NetworkRequest {
    
    fileprivate func load(_ session: URLSession, _ request: URLRequest, withCompletion completion: @escaping (ModelType?, NetworkRequestError?) -> Void) {
        
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            // guard para validar que no hay error en la response
            guard error == nil else {
                print("Error en la descarga: \(String(describing: error))")
                print("Error en la descarga: \(String(describing: error?.localizedDescription))")
                return completion(nil, NetworkRequestError.RequestFailed(error!.localizedDescription))
            }
            
            let httpResponse = response as! HTTPURLResponse

            if httpResponse.statusCode == 200 { // Se verifica que la respuesta sea acorde a como lo espera el cliente
                guard let data = data else {
                    completion(nil, NetworkRequestError.DataNil(dataNilMessage))
                    return
                }
                
                do {
                    completion(try self.decode(data), nil)
                }
                catch {
                    completion(nil, NetworkRequestError.EncodeModelFailed(encodeModelFailedMessage))
                }
            }
            else {
                print("status: \(httpResponse.statusCode)")
                completion(nil, nil) //Poner excepcion?
            }
        }
        
        task.resume()
    }
    
    
    fileprivate func load(_ url: URL, withCompletion completion: @escaping (ModelType?, NetworkRequestError?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            // guard para validar que no hay error en la response
            guard error == nil else {
                print("Error en la descarga: \(String(describing: error))")
                return completion(nil, NetworkRequestError.RequestFailed(error!.localizedDescription))
            }
            
            let httpResponse = response as! HTTPURLResponse
            
            if httpResponse.statusCode == 200 { // Se verifica que la respuesta sea acorde a como lo espera el cliente
                guard let data = data else { // guard para validar que no hay nil en la response
                    completion(nil, NetworkRequestError.DataNil(dataNilMessage))
                    return
                }
                
                do {
                    completion(try self.decode(data), nil)
                }
                catch {
                    completion(nil, NetworkRequestError.EncodeModelFailed(encodeModelFailedMessage))
                }
            }
            else {
                completion(nil, nil) //Poner excepcion?
            }
        }
        
        task.resume()
    }
}



// MARK: Implementación default para NetworkRequest imagenes

class ImageRequest : NetworkRequest {
    let url: URL
    
    
    init(url: URL) {
        self.url = url
    }
    
    
    func decode(_ data: Data) throws -> UIImage? {
        return UIImage(data: data)
    }
    
    
    func load(withCompletion completion: @escaping (UIImage?, NetworkRequestError?) -> Void) {
        load(url, withCompletion: completion)
    }
}



class APIRequest<Resource: APIResource> : NetworkRequest {
    
    private let session: URLSession!
    let resource: Resource
    
    
    init(resource: Resource) {
        self.resource = resource
        self.session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
    }
    
    
    func decode(_ data: Data) throws -> Resource.ModelType? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let wrapper = try decoder.decode(Resource.ModelType.self, from: data)
        return wrapper
    }
    
    
    func load(withCompletion completion: @escaping (Resource.ModelType?, NetworkRequestError?) -> Void) {
        load(session, resource.request, withCompletion: completion)
    }
}



// MARK: - NetworkRequest operation errors

enum NetworkRequestError : Equatable, Error {
    case RequestFailed(String)
    case DataNil(String)
    case EncodeModelFailed(String)
}



fileprivate let encodeModelFailedMessage = "No se pudo decodificar la respuesta"
fileprivate let dataNilMessage = "Se ha recuperado un nil como dato"



