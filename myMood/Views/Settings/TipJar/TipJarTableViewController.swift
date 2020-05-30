//
//  TipJarTableViewController.swift
//  myTodo
//
//  Created by Marc Hein on 13.11.18.
//  Copyright © 2018 Marc Hein Webdesign. All rights reserved.
//

import UIKit
import StoreKit
import SafariServices

class TipJarTableViewController: UITableViewController {
    internal let impact = UIImpactFeedbackGenerator()
    internal var productIDs: [String] = []
    internal var productsArray: [SKProduct?] = []
    internal var selectedProductIndex: Int!
    internal var transactionInProgress = false
    internal var hasData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        self.setupProducts()
        //self.navigationController?.view.makeToastActivity(.center)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resetData()
        self.requestProductInfo()
    }
    
    private func resetData() {
        self.productsArray = []
        self.hasData = false
    }

    // MARK:- IAP
    fileprivate func setupProducts() {
        productIDs = myMoodIAP.allTips
    }
    
    @IBAction func tipButtonAction(_ sender: UIButton) {
        guard let cell = sender.superview?.superview?.superview as? TipTableViewCell else { return }
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        tableView.delegate?.tableView!(tableView, didSelectRowAt: indexPath)
    }
}
