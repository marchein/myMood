//
//  TipJar+Transaction.swift
//  myMood
//
//  Created by Marc Hein on 20.11.18.
//  Copyright © 2018 Marc Hein. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

extension TipJarTableViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = NSSet(array: productIDs)
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            productRequest.delegate = self
            productRequest.start()
        } else {
            // TODO: remove this - implement correct error handling
            print("Cannot perform In App Purchases.")
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product)
            }
            productsArray = productsArray.sorted(by: { (one, two) -> Bool in
                guard let one = one, let two = two else {
                    return false
                }
                return one.price.doubleValue < two.price.doubleValue
            })
            
            hasData = true
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            if response.invalidProductIdentifiers.count != 0 {
                // TODO: remove this - wtf is this even doing?
                print(response.invalidProductIdentifiers.description)
            }
        }
        
        
    }
    
    func startTransaction() {
        if transactionInProgress || productsArray.count < 1 {
            return
        }
        
        let payment = SKPayment(product: self.productsArray[self.selectedProductIndex]!)
        SKPaymentQueue.default().add(payment)
        self.transactionInProgress = true
        //self.navigationController?.view.makeToastActivity(.center)
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                //self.navigationController?.view.hideToastActivity()
                UserDefaults.data.set(true, forKey: LocalKeys.hasTipped)
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                impact.impactOccurred()
                showMessage(title: "Erfolgreich myMood unterstützt!", message: "Vielen Dank für Deine Unterstützung!", on: self)
            case SKPaymentTransactionState.failed:
                //self.navigationController?.view.hideToastActivity()
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                showMessage(title: "Der Kauf konnte nicht abgeschlossen werden", message: "Entweder wurde der Kauf abgebrochen oder es ist ein Fehler aufgetreten. Bitte versuche es nochmals.", on: self)
            default:
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
            }
        }
    }
}

