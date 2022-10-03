//
//  NotificationCenterData.swift
//  Spotify
//
//  Created by Marlon Alfonso Beltran Sanchez on 20/08/20.
//  Copyright © 2020 Pragma. All rights reserved.
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
