//
//  StoreContext.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-06-20.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import StoreKit

/// This observable class can manage store-based state in an observable way.
///
/// You can use the ``StandardStoreService`` to sync product information
/// with a context instance when performing certain operations.
///
/// Since StoreKit `Product` isn't `Codable`, the ``products`` array isn't
/// permanently persisted. This means that it will reset when the app is restarted.
/// Due to this, there's also a ``productIds`` property that *is* permanently
/// persisted. This gives you an option to map ``productIds`` to local product
/// representations whenever the app can't access StoreKit. However, note that a
/// StoreKit `Product` is needed to perform a purchase.
public class StoreContext: ObservableObject, @unchecked Sendable {

    /// Create a context instance.
    ///
    /// - Parameters:
    ///   - productIds: An optional list of initial product IDs to use if no IDs have been persisted yet.
    public init(productIds: [String] = []) {
        products = []
        self.productIds = persistedProductIds.isEmpty ? productIds : persistedProductIds
        purchasedProductIds = persistedPurchasedProductIds
    }
    
    /// A list of synced products.
    @Published
    public var products: [Product] {
        didSet { productIds = products.map { $0.id} }
    }

    /// A persisted list of synced products IDs.
    @Published
    public internal(set) var productIds: [String] = [] {
        willSet { persistedProductIds = newValue }
    }
    
    /// A list of active purchase transactions.
    public var purchaseTransactions: [Transaction] = [] {
        didSet { purchasedProductIds = purchaseTransactions.map { $0.productID } }
    }

    /// A list of purchased product IDs.
    @Published
    public internal(set) var purchasedProductIds: [String] = [] {
        willSet { persistedPurchasedProductIds = newValue }
    }
    
    
    // MARK: - Persisted Properties
    
    @Persisted(key: key("productIds"), defaultValue: [])
    private var persistedProductIds: [String]
    
    @Persisted(key: key("purchasedProductIds"), defaultValue: [])
    private var persistedPurchasedProductIds: [String]
}

@MainActor
public extension StoreContext {

    /// Update the context products.
    func updateProducts(_ products: [Product]) {
        self.products = products
    }

    /// Update the context purchase transactions.
    func updatePurchaseTransactions(with transaction: Transaction) {
        var transactions = purchaseTransactions
            .filter { $0.productID != transaction.productID }
        transactions.append(transaction)
        purchaseTransactions = transactions
    }

    /// Update the context purchase transactions.
    func updatePurchaseTransactions(_ transactions: [Transaction]) {
        purchaseTransactions = transactions
    }
}

private extension StoreContext {
    
    static func key(_ name: String) -> String { "com.danielsaidi.storekitplus.\(name)" }
}

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
