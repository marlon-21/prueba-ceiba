//
//  Observable.swift
//  Spotify
//
//  Created by Marlon Alfonso Beltran Sanchez on 29/09/22.
//

import Foundation



protocol Observable {
    associatedtype T
    
    var value: T { get set }
    var observers: [ObserverImpl<T>] { get }
    
    
    func addObserver(observer: AnyObject, updateBlock: @escaping (T) -> Void)
    
    func removeObserver(observer: AnyObject)
    
    func notifyAllObservers(with newValue: T)
}



//MARK: Implementación Observable

class ObservableImpl<T> : Observable {
    
    
    private var _value : T! = nil
    private var _observers : [ObserverImpl<T>] = []
    
    var value : T {
        get {
            return self._value
        }
        set {
            self._value = newValue
            self.notifyAllObservers(with: newValue)
        }
    }
    
    var observers : [ObserverImpl<T>] {
        get {
            self._observers
        }
    }
    
    
    init(value: T) {
        self._value = value
    } //Init de la discordia no se pude pasar un lambda por defecto
    
    
    deinit {
        _observers.removeAll()
    }
    
    
    func addObserver(observer: AnyObject, updateBlock: @escaping (T) -> Void) {
        let observer = ObserverImpl<T>(observer: observer)
        observer.updateBlock = updateBlock
        _observers.append(observer)
    }
    
    
    func removeObserver(observer: AnyObject) {
        _observers = _observers.filter({$0.observer !== observer})
    }
    
    
    func notifyAllObservers(with newValue: T) {
        for observer in _observers {
            _value = newValue
            observer.updateBlock?(newValue)
        }
    }
}
