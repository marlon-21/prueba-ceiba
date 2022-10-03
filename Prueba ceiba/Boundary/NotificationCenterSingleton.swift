//
//  NotificationCenterData.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 27/09/22
//

import Foundation


/**
 * Un NotificationCenter (singleton) como bound entre la capa de datos y el use case. Este componente sirve como medio de comunicación entre capas.
 */
class NotificationCenterData {
    
    static let instance = NotificationCenter()
    
    
    init() {}
}


/**
* Un NotificationCenter (singleton) como bound entre la capa de presentación y el use case. Este componente sirve como medio de comunicación entre capas.
*/
class NotificationCenterUseCase {
    
    static let instance = NotificationCenter()
    
    
    init() {}
}
