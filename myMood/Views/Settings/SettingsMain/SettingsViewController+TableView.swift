//
//  SettingsViewController+TableView.swift
//  myMood
//
//  Created by Marc Hein on 27.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit
import StoreKit

extension SettingsViewController {
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isSimulatorOrTestFlight() {
            return 3
        }
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            return "Vorsicht"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return "Build Nummer: \(Model.buildNumber) (\(getReleaseTitle()))"
        } else if section == 2 {
            return "Falls Du Deine Datenbank oder die gesamte App zurücksetzen möchtest, kannst Du dies hier tun"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (selectedCell) {
        case appSupportCell:
            sendSupportMail()
            break
        case rateAppCell:
            SKStoreReviewController.requestReview()
            break
        case appStoreCell:
            appStoreAction()
            break
        case developerCell:
            openSafariViewControllerWith(url: Model.website)
            break
        case resetCoreDataCell:
            self.resetCoreDataAction()
            break
        case resetAppCell:
            self.resetAppAction()
            break
        default:
            break
        }
    }
}
