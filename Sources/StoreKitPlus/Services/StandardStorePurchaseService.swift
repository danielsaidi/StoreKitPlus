//
//  StandardStoreProductService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-08-29.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import StoreKit

/// This class can be used to perform StoreKit purchases.
///
/// This class keeps purchases in sync with a ``StoreContext``
/// that can also be used to observe changes to drive the UI.
open class StandardStorePurchaseService: StorePurchaseService {

    /// Create a service instance for the provided IDs.
    ///
    /// - Parameters:
    ///   - productIds: The IDs of the products to fetch.
    public init(
        productIds: [String]
    ) {
        self.productIds = productIds
        self.transactionTask = nil
        self.transactionTask = getTransactionListenerTask()
    }

    deinit {
        self.transactionTask = nil
    }


    private let productIds: [String]
    private var transactionTask: Task<Void, Error>?


    /// Purchase the provided product.
    ///
    /// If the purchase operation is successful, the service
    /// will verify the result and finish the transaction. A
    /// subclass of this class can customize these steps, by
    /// overriding the various open classes.
    open func purchase(
        _ product: Product
    ) async throws -> Product.PurchaseResult {
        #if os(visionOS)
        throw StoreServiceError.unsupportedPlatform("This purchase operation is not supported in visionOS: Use @Environment(\\.purchase) instead.")
        #else
        let result = try await product.purchase()
        switch result {
        case .success(let result): try await finalizePurchaseResult(result)
        case .pending: break
        case .userCancelled: break
        @unknown default: break
        }
        return result
        #endif
    }

    @discardableResult
    open func restorePurchases() async throws -> [Transaction] {
        var transactions: [Transaction] = []
        for id in productIds {
            if let transaction = try await getValidTransaction(for: id) {
                transactions.append(transaction)
            }
        }
        return transactions
    }


    // MARK: - Open functions

    /// Finalize a purchase result from a ``purchase(_:)``.
    open func finalizePurchaseResult(
        _ result: VerificationResult<Transaction>
    ) async throws {
        let transaction = try result.verify()
        await transaction.finish()
    }

    /// Try to resolve a valid transaction for a certain ID.
    ///
    /// This function will fetch and verify all transactions
    /// before returning them.
    open func getValidTransaction(
        for productId: ProductID
    ) async throws -> Transaction? {
        guard let latest = await Transaction.latest(for: productId) else { return nil }
        let result = try latest.verify()
        return result.isValid ? result : nil
    }
}

private extension StandardStorePurchaseService {

    /// Get a task that can to listen to transaction changes.
    func getTransactionListenerTask() -> Task<Void, Error> {
        Task.detached {
            for await result in Transaction.updates {
                do {
                    try result.verify()
                } catch {
                    print("Transaction listener error: \(error)")
                }
            }
        }
    }
}

private extension VerificationResult where SignedType == Transaction {

    @discardableResult
    func verify() throws -> Transaction {
        switch self {
        case .unverified(let transaction, let error): throw StoreServiceError.invalidTransaction(transaction, error)
        case .verified(let transaction): return transaction
        }
    }
}
