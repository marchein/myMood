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
            return 4
        }
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 3 {
            return "Vorsicht"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return "Die Mensaplan Daten stammen vom Studierendenwerk Trier.\nAlle Angaben ohne Gewähr"
        } else if section == 1 {
            return "Build Nummer: \(Model.buildNumber) (\(getReleaseTitle()))"
        } else if section == 3 {
            return "Falls Du deine Datenbank zurücksetzen möchtest, kannst Du dies hier tun"
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
