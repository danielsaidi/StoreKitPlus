//
//  Persisted.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2020-04-05.
//  Copyright © 2020-2024 Daniel Saidi. All rights reserved.
//

import Foundation

/// This property wrapper automatically persists a new value
/// to user defaults.
@propertyWrapper
struct Persisted<T: Codable> {
    
    init(
        key: String,
        store: UserDefaults = .standard,
        defaultValue: T) {
        self.key = key
        self.store = store
        self.defaultValue = defaultValue
    }
    
    private let key: String
    private let store: UserDefaults
    private let defaultValue: T

    var wrappedValue: T {
        get {
            guard let data = store.object(forKey: key) as? Data else { return defaultValue }
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            store.set(data, forKey: key)
        }
    }
}
