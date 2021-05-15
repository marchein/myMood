//
//  SKProduct+LocalizedPrice.swift
//  myMood
//
//  Created by Marc Hein on 20.11.18.
//  Copyright © 2018 Marc Hein. All rights reserved.
//

import Foundation
import StoreKit

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
