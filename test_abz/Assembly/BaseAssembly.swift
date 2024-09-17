//
//  BaseAssembly.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import Foundation

class BaseAssembly {
    
    internal var sharedRegistry: Dictionary<String, Any>
    
    // MARK: - Memory management
    
    init() {
        sharedRegistry = Dictionary<String, Any>()
    }
    
    // MARK: - Registry
    
    internal func register(instance: Any) {
        sharedRegistry[String(describing: type(of: instance.self))] = instance
    }
    
    internal func registeredIntance(for theClass: AnyClass) -> Any {
        return sharedRegistry[String(describing: theClass)] as Any
    }
}
