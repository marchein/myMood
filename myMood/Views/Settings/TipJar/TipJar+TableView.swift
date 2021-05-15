//
//  TipJar+TableView.swift
//  myMood
//
//  Created by Marc Hein on 20.11.18.
//  Copyright © 2018 Marc Hein. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Table View
extension TipJarTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return productsArray.count > 0 ? productsArray.count : 1
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return tableView.dequeueReusableCell(withIdentifier: TipIntroTableViewCell.reuseIdentifier, for: indexPath) as! TipIntroTableViewCell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TipTableViewCell.reuseIdentifier, for: indexPath) as! TipTableViewCell
            if productsArray.count > indexPath.row {
                if let product = productsArray[indexPath.row] {
                    cell.tipTitle.text = product.localizedTitle
                    //cell.tipDesc.text = product.localizedDescription
                    cell.tipDesc.text = nil
                    cell.purchaseButton.isHidden = false
                    cell.purchaseButton.setTitle(product.localizedPrice, for: .normal)
                }
            } else {
                cell.tipTitle.text = "Keine Unterstützungsbeiträge vorhanden"
                cell.tipDesc.text = "Entweder hat Dein Gerät Probleme Daten von Apple zu empfangen oder Apple hat Probleme. Bitte versuche es erneut."
                cell.purchaseButton.isHidden = true
                cell.tipDesc.isHidden = false
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return tableView.estimatedRowHeight
        } else {
            return hasData ? 68.0 : 100.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            selectedProductIndex = indexPath.row
            startTransaction()
        }
        
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }
}
