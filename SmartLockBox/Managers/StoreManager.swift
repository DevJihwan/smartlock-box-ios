//
//  StoreManager.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-11-03.
//

import Foundation
import StoreKit

/// StoreKit 2를 사용한 인앱 구매 매니저
@MainActor
class StoreManager: ObservableObject {
    static let shared = StoreManager()

    // MARK: - Published Properties

    @Published var products: [Product] = []
    @Published var purchasedProductIDs: Set<String> = []
    @Published var isPurchasing = false
    @Published var purchaseError: Error?

    // MARK: - Product IDs

    private let monthlySubscriptionID = "com.smartlockbox.premium.monthly"
    private let yearlySubscriptionID = "com.smartlockbox.premium.yearly"

    private var productIDs: [String] {
        [monthlySubscriptionID, yearlySubscriptionID]
    }

    // MARK: - Transaction Updates

    private var updateListenerTask: Task<Void, Error>?

    // MARK: - Initialization

    private init() {
        // Start listening for transaction updates
        updateListenerTask = listenForTransactions()

        // Load products
        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    // MARK: - Load Products

    func loadProducts() async {
        do {
            // Fetch products from App Store
            let products = try await Product.products(for: productIDs)
            self.products = products.sorted { $0.price < $1.price }

            print("✅ Loaded \(products.count) products")
            for product in products {
                print("  - \(product.displayName): \(product.displayPrice)")
            }
        } catch {
            print("❌ Failed to load products: \(error)")
            purchaseError = error
        }
    }

    // MARK: - Purchase

    func purchase(_ product: Product) async throws -> Transaction? {
        isPurchasing = true
        purchaseError = nil

        defer {
            isPurchasing = false
        }

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                // Verify the transaction
                let transaction = try checkVerified(verification)

                // Deliver content to the user
                await updatePurchasedProducts()

                // Always finish the transaction
                await transaction.finish()

                print("✅ Purchase successful: \(product.displayName)")
                return transaction

            case .userCancelled:
                print("⚠️ User cancelled purchase")
                return nil

            case .pending:
                print("⏳ Purchase pending")
                return nil

            @unknown default:
                print("❓ Unknown purchase result")
                return nil
            }
        } catch {
            print("❌ Purchase failed: \(error)")
            purchaseError = error
            throw error
        }
    }

    // MARK: - Restore Purchases

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
            print("✅ Purchases restored")
        } catch {
            print("❌ Failed to restore purchases: \(error)")
            purchaseError = error
        }
    }

    // MARK: - Update Purchased Products

    func updatePurchasedProducts() async {
        var purchasedIDs: Set<String> = []

        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)

                // Check if subscription is active
                if transaction.productType == .autoRenewable {
                    purchasedIDs.insert(transaction.productID)
                }
            } catch {
                print("❌ Failed to verify transaction: \(error)")
            }
        }

        self.purchasedProductIDs = purchasedIDs

        // Update subscription manager
        if purchasedIDs.contains(monthlySubscriptionID) || purchasedIDs.contains(yearlySubscriptionID) {
            SubscriptionManager.shared.upgradeToPremium()
        } else {
            SubscriptionManager.shared.downgradeToFree()
        }

        print("📦 Purchased products: \(purchasedIDs)")
    }

    // MARK: - Transaction Verification

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

    // MARK: - Listen for Transactions

    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached { [weak self] in
            guard let self = self else { return }

            // Iterate through any transactions that don't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.checkVerifiedAsync(result)

                    // Deliver products to the user
                    await self.updatePurchasedProducts()

                    // Always finish a transaction
                    await transaction.finish()

                    print("✅ Transaction updated: \(transaction.productID)")
                } catch {
                    print("❌ Transaction verification failed: \(error)")
                }
            }
        }
    }

    // MARK: - Async Transaction Verification

    private func checkVerifiedAsync<T>(_ result: VerificationResult<T>) async throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

    // MARK: - Helper Methods

    func hasActiveSubscription() -> Bool {
        return purchasedProductIDs.contains(monthlySubscriptionID) ||
               purchasedProductIDs.contains(yearlySubscriptionID)
    }

    func subscriptionExpiryDate() async -> Date? {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if transaction.productType == .autoRenewable,
                   let expirationDate = transaction.expirationDate {
                    return expirationDate
                }
            }
        }
        return nil
    }
}

// MARK: - Store Errors

enum StoreError: LocalizedError {
    case failedVerification

    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return "Transaction verification failed"
        }
    }
}
