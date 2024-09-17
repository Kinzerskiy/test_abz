//
//  Defaults.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import Foundation

private enum DefaultsKey: String {
    case firstInitialization = "firstInitialization"
}

final class Defaults {
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Data
    
    static var firstInitialization: Bool {
        set{
            _set(value: newValue, key: .firstInitialization)
        } get {
            return _get(valueForKay: .firstInitialization) as? Bool ?? true
        }
    }
    
    // MARK: - Setter and Getter
    
    private static func _set(value: Any?, key: DefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    private static func _get(valueForKay key: DefaultsKey) -> Any? {
        return UserDefaults.standard.value(forKey: key.rawValue)
    }
}
