//
//  Utilities.swift
//  myMood
//
//  Created by Marc Hein on 27.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Check for Beta Testers
func isSimulatorOrTestFlight() -> Bool {
    return isSimulator() || isTestFlight()
}

func isSimulator() -> Bool {
    guard let path = Bundle.main.appStoreReceiptURL?.path else {
        return false
    }
    return path.contains("CoreSimulator")
}

func isTestFlight() -> Bool {
    guard let path = Bundle.main.appStoreReceiptURL?.path else {
        return false
    }
    return path.contains("sandboxReceipt")
}

func getReleaseTitle() -> String {
    if isSimulator() {
        return "Simulator"
    } else if isTestFlight() {
        return "TestFlight"
    } else {
        return "App Store"
    }
}

// MARK: - showDialog
func showMessage(title: String, message: String, on view: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Verstanden", style: .cancel, handler: nil))
    DispatchQueue.main.async {
        view.present(alert, animated: true)
    }
}


func debug(file: String = #file, line: Int = #line, function: String = #function) -> String {
    return "\(file):\(line) : \(function)"
}
