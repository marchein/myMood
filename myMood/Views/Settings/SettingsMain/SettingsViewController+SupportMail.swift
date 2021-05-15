//
//  SettingsViewController+SupportMail.swift
//  myMood
//
//  Created by Marc Hein on 27.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import MessageUI
import UIKit

// MARK:- Mail Extension
extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func sendSupportMail() {
        #if targetEnvironment(macCatalyst)
        let message = "Bei Fragen und Anregungen kannst uns jeder Zeit unter %@ erreichen."
        showMessage(title: "Support Anfrage", message: String(format: message, Model.mailAdress), on: self)
        #else
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("[myMood] - Supportanfrage")
            mail.setToRecipients([Model.mailAdress])
            let mailBody = """
            Version \(Model.versionString)
            Build: \(Model.buildNumber)
            App Variante: \(getReleaseTitle())
            Gerät: \(UIDevice.current.model)
            System Version: \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)
            Jailbreak: \(isJailbroken() ? "Ja": "Nein")
            
            Warum kontaktierst Du den Support?
            """
            mail.setMessageBody(mailBody, isHTML: false)
            present(mail, animated: true)
        } else {
            let mailErrorMessage = "Es ist kein E-Mail Konto in Apple Mail hinterlegt. Bitte kontaktiere uns unter %@"
            showMessage(title: "Fehler", message: String(format: mailErrorMessage, Model.mailAdress), on: self)
        }
        #endif
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
