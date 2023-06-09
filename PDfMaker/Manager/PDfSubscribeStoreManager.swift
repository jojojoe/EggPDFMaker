//
//  PDfSubscribeStoreManager.swift
//  PDfMaker
//
//  Created by Jbai go on 2023/5/24.
//

import UIKit
import Foundation
import SwiftyStoreKit
import TPInAppReceipt
import StoreKit
import KRProgressHUD


class PDfSubscribeStoreManager: NSObject {
    public static var `default` = PDfSubscribeStoreManager()
    
    public struct PurchaseNotificationKeys {
        static let success = "success"
        static let failed = "failed"
    }
    
    public struct IAPProduct: Codable {
        public var iapID: String
        public var price: Double
        public var priceLocale: Locale
        public var localizedPrice: String?
        public var currencyCode: String?
    }
    /*
    
     */
//    com.convert.picture.PDF
    public enum IAPType: String {
        case week = "com.convert.picture.PDF.week"
        case month = "com.convert.picture.PDF.month"
        case year = "com.convert.picture.PDF.year"
    }
    var currentWeekPrice: String = "4.99"
    var currentMonthPrice: String = "7.99"
    var currentYearPrice: String = "49.99"
    var currentSymbol: String = "$"
    var isSplashBegin: Bool = false
    
    public enum VerifyLocalReceiptResult {
        case success(receipt: InAppReceipt)
        case error(error: IARError)
    }

    public enum VerifyLocalSubscriptionResult {
        case purchased(expiryDate: Date, items: [InAppReceipt])
        case expired(expiryDate: Date, items: [InAppReceipt])
        case purchasedOnceTime
        case notPurchased
    }
    
    var iapTypeList: [IAPType] = [.week, .month, .year]
    var currentIapType: IAPType = .month
    var inSubscription: Bool = false
    var currentProducts: [PDfSubscribeStoreManager.IAPProduct] = []
    

    
}

extension PDfSubscribeStoreManager {
    func completeTransactions() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    break
                case .failed, .purchasing, .deferred:
                    break
                @unknown default:
                    break
                }
            }
        }
    }
    
    public func fetchPurchaseInfo(block: @escaping (([PDfSubscribeStoreManager.IAPProduct]) -> Void)) {
        
        
        if self.currentProducts.count == self.iapTypeList.count {
            block(self.currentProducts)
            return
        }
        
        let iapList = iapTypeList.map { $0.rawValue }
        SwiftyStoreKit.retrieveProductsInfo(Set(iapList)) { result in
            let priceList = result.retrievedProducts.compactMap { $0 }
            let localList = priceList.compactMap { PDfSubscribeStoreManager.IAPProduct(iapID: $0.productIdentifier, price: $0.price.doubleValue.rounded(digits: 2), priceLocale: $0.priceLocale, localizedPrice: $0.localizedPrice, currencyCode: $0.priceLocale.currencyCode)
            }
            self.currentProducts = localList
            
            //
            self.currentSymbol = localList.first?.priceLocale.currencySymbol ?? "$"
            
            for producti in localList {
                
                if producti.iapID == PDfSubscribeStoreManager.IAPType.month.rawValue {
                    PDfSubscribeStoreManager.default.currentMonthPrice = producti.price.accuracyToString(position: 2)
                } else if producti.iapID == PDfSubscribeStoreManager.IAPType.year.rawValue {
                    PDfSubscribeStoreManager.default.currentYearPrice = producti.price.accuracyToString(position: 2)
                } else if producti.iapID == PDfSubscribeStoreManager.IAPType.week.rawValue {
                    PDfSubscribeStoreManager.default.currentWeekPrice = producti.price.accuracyToString(position: 2)
                }
            }
            
            block(localList)
        }
        
    }
    
    public func restore(_ successBlock: ((Bool) -> Void)? = nil) {
        
        SwiftyStoreKit.restorePurchases(atomically: true) { [weak self] results in
            guard let `self` = self else { return }
            if results.restoreFailedPurchases.count > 0 {
                successBlock?(false)
                debugPrint("Restore Failed: \(results.restoreFailedPurchases)")
            } else if results.restoredPurchases.count > 0 {
                for purchase in results.restoredPurchases {
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                }
                
                self.refreshReceipt { (_, _) in
                    self.isPurchased { (status) in
                        if status {
                            NotificationCenter.default.post(
                                name: NSNotification.Name(rawValue: PurchaseNotificationKeys.success),
                                object: nil,
                                userInfo: nil)
                            debugPrint("Restore Success: \(results.restoredPurchases)")
                            successBlock?(true)
                        } else {
                            successBlock?(false)
                        }
                    }
                }
            } else {
                successBlock?(false)
            }
        }
    }
    
    public func subscribeIapOrder(iapType: PDfSubscribeStoreManager.IAPType, source: String, completionBlock: ((Bool, String?) -> Void)? = nil) { // inSubscribeBool errorString
        
        SwiftyStoreKit.purchaseProduct(iapType.rawValue) { purchaseResult in
            switch purchaseResult {
            case let .success(purchaseDetail):
                if purchaseDetail.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchaseDetail.transaction)
                }
                self.refreshReceipt { (_, _) in
                    self.isPurchased { (status) in
                        if status {
                            let currency = purchaseDetail.product.priceLocale.currencySymbol ?? "$"
                            let price = purchaseDetail.product.price.doubleValue
                            debugPrint("product - \(currency)\(price)")
                        }
                        
                        NotificationCenter.default.post(
                            name: NSNotification.Name(rawValue: PurchaseNotificationKeys.success),
                            object: nil,
                            userInfo: nil)
                        completionBlock?(status, nil)
                    }
                }
                
            case let .error(error):
                
                var errorStr = error.localizedDescription
                switch error.code {
                case .unknown: errorStr = "Unknown error. Please contact support. If you are sure you have purchased it, please click the \"Restore\" button."
                case .clientInvalid: errorStr = "Not allowed to make the payment"
                case .paymentCancelled: errorStr = "Payment cancelled"
                case .paymentInvalid: errorStr = "The purchase identifier was invalid"
                case .paymentNotAllowed: errorStr = "The device is not allowed to make the payment"
                case .storeProductNotAvailable: errorStr = "The product is not available in the current storefront"
                case .cloudServicePermissionDenied: errorStr = "Access to cloud service information is not allowed"
                case .cloudServiceNetworkConnectionFailed: errorStr = "Could not connect to the network"
                case .cloudServiceRevoked: errorStr = "User has revoked permission to use this cloud service"
                default: errorStr = (error as NSError).localizedDescription
                }
                completionBlock?(false, errorStr)
                
            }
        }
    }
}

extension PDfSubscribeStoreManager {
    // main method to check if purchased anything
    func isPurchased(completion: @escaping (_ purchased: Bool) -> Void) {
        let dispatchGroup = DispatchGroup()
        var validPurchases: [String: VerifyLocalSubscriptionResult] = [:]
        var errors: [String: Error] = [:]
        for key in iapTypeList {
            dispatchGroup.enter()
            
            verifyPurchase(key) { [weak self] purchaseResult, error in
                guard let _ = self else {
                    dispatchGroup.leave()
                    return
                }
                if let err = error {
                    errors[key.rawValue] = err
                    dispatchGroup.leave()
                    return
                }
                guard let purchase = purchaseResult else {
                    dispatchGroup.leave()
                    return
                }
                switch purchase {
                case .purchased(let expiryDate, let receiptItems):
                    let now = Date()
                    if now < expiryDate {
                        validPurchases[key.rawValue] = purchase
                    }
                    validPurchases[key.rawValue] = purchase
                    dispatchGroup.leave()
                case .expired(let expiryDate, let receiptItems):
                    print("Product is expired since \(expiryDate)")
                    dispatchGroup.leave()
                    let format = DateFormatter()
                    format.timeZone = .current
                    format.dateFormat = "EEEE, MMM d, yyyy h:mm a"
                    let dateString = format.string(from: expiryDate)
                    debugPrint("dateString = \(dateString)")
                case .purchasedOnceTime:
                    validPurchases[key.rawValue] = purchase
                    dispatchGroup.leave()
                case .notPurchased:
                    dispatchGroup.leave()
                    
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            let hasValid = validPurchases.count > 0
            PDfSubscribeStoreManager.default.inSubscription = hasValid
            completion(hasValid)
        }
    }
    
    func verifyPurchase(_ purchase: IAPType,
                        completion: @escaping(VerifyLocalSubscriptionResult?, Error?) -> Void) {
     
        verifyReceipt { [weak self] (receiptResult, validationError) in
            guard let _ = self else {
                completion(nil, nil)
                return
            }
            if let error = validationError {
                completion(nil, error)
                return
            }
            guard let result = receiptResult else {
                completion(nil, nil)
                return
            }
            
            switch result {
            // receipt is validated
            case .success(let receipt):
                let oneTimePurchase = "life"//IAPType.life.rawValue
                let item = receipt.purchases.first {
                    return $0.productIdentifier == oneTimePurchase
                }
                if let _ = item {
                    completion(.purchasedOnceTime, nil)
                    return
                }
                
                let productId = purchase.rawValue
                // check there is a subscription first
                if let subscription = receipt.activeAutoRenewableSubscriptionPurchases(ofProductIdentifier: productId, forDate: Date()) {
                    if let expiryDate = subscription.subscriptionExpirationDate {
                        completion(.purchased(expiryDate: expiryDate, items: [receipt] ), nil)
                        return
                    }
                    // no expiry date?
                    completion(.notPurchased, nil)
                }
                let purchases = receipt.purchases( ofProductIdentifier: productId ) { (InAppPurchase, InAppPurchase2) -> Bool in
                    return InAppPurchase.purchaseDate > InAppPurchase2.purchaseDate
                }
                if purchases.isEmpty {
                    completion(.notPurchased, nil)
                } else {
                    // get last purchase
                    let lastSubscription = purchases[0]
                    completion( .expired(expiryDate: lastSubscription.subscriptionExpirationDate ?? Date(), items: [receipt] ), nil )
                }
            // validation error
            case .error(let error):
                completion(nil, error)
            }
        }
    }
    
    func verifyReceipt( completion: @escaping(VerifyLocalReceiptResult?, Error?) -> Void ) {
        do {
            let receipt = try InAppReceipt.localReceipt()
            do {
                try receipt.verifyHash()
                completion(.success(receipt: receipt), nil)
            } catch IARError.initializationFailed(let reason) {
                completion(.error(error: .initializationFailed(reason: reason)),nil)
            } catch IARError.validationFailed(let reason) {
                completion(.error(error: IARError.validationFailed(reason: reason)), nil)
            } catch IARError.purchaseExpired {
                completion(.error(error: .purchaseExpired), nil)
            } catch {
                // unknown error
                completion(nil, error)
            }
        } catch {
            completion(
                .error(error: .initializationFailed(reason: .appStoreReceiptNotFound)),
                error
            )
        }
    }
    
    func refreshReceipt(completion: @escaping(FetchReceiptResult?, Error?) -> Void) {
        SwiftyStoreKit.fetchReceipt(forceRefresh: true, completion: { result in
            switch result {
            case .success:
               completion(result, nil)
            case .error(let error):
                completion(nil, error)
            }
        })
    }
}

extension Double {
    func rounded(digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return (self * multiplier).rounded() / multiplier
    }
}
