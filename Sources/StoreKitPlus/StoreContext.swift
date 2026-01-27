//
//  StoreContext.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-06-20.
//  Copyright © 2022-2026 Daniel Saidi. All rights reserved.
//

import StoreKit

/// This observable context type can be used to manage store
/// state in an observable way.
///
/// You can use the ``StandardStoreService`` to sync product
/// states with a context when performing certain operations.
///
/// Since the StoreKit `Product` and `Transaction` types are
/// not `Codable`, the ``products`` & ``purchaseTransactions``
/// propertes are not permanently persisted. The context has
/// persisted ``productIds`` and ``purchasedProductIds``, to
/// to give us an option to map these IDs to a local product
/// representations when the app can't access StoreKit.
public class StoreContext: ObservableObject, @unchecked Sendable {

    /// Create a context instance with a list of product IDs.
    ///
    /// The provided IDs will be used to if no IDs have been
    /// persisted yet.
    ///
    /// - Parameters:
    ///   - productIds: An optional list of initial product IDs .
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
