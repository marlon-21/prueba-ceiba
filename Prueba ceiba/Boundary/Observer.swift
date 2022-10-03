//
//  Observer.swift
//  Spotify
//
//  Created by Marlon Alfonso Beltran Sanchez on 29/09/22.
//

import Foundation



protocol Observer {
    associatedtype T
    var observer: AnyObject? { get set }
    var updateBlock: ((T) -> Void)? { get set }
    
    
    init(observer: AnyObject)
}



//MARK: Implementación Observer

class ObserverImpl<T> : Observer {
    typealias T = T
    weak var observer: AnyObject?
    var updateBlock: ((T) -> Void)? = nil
    
    
    required init(observer: AnyObject) {
        self.observer = observer
    }
}
