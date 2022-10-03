//
//  DataStoreFactory.swift
//  Prueba ceiba
//
//  Created by Marlon Beltran on 29/09/22.
//

/**
 Este protocol expresa los métodos de una factory creadora  de un solo almacén de datos. Esta factory se usa con el fin de separar la lógica de creación de la lógica de utilización.
 */
protocol DataStoreFactory {
    
    associatedtype DataStoreType
    func createLocalDataStore() -> DataStoreType?
    
    
    func createCloudDataStore() -> DataStoreType?
}
