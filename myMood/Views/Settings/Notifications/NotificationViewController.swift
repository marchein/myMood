//
//  NotificationViewController.swift
//  myMood
//
//  Created by Marc Hein on 28.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit

class NotificationViewController: UITableViewController {
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var morningCell: UITableViewCell!
    @IBOutlet weak var afternoonCell: UITableViewCell!
    @IBOutlet weak var eveningCell: UITableViewCell!
    
    var notificationsEnabled = false
    var morningNotificationEnabled = false
    var afternoonNotificationEnabled = false
    var eveningNotificationEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadNotificationState()
        self.getNotificationData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getNotificationData()
        self.tableView.reloadData()
    }
    
    func loadNotificationState() {
        self.notificationsEnabled = Model.sharedDefaults.bool(forKey: LocalKeys.notificationsEnabled)
        self.notificationSwitch.isOn = self.notificationsEnabled
    }
    
    @IBAction func notificationSwitchToggled(_ sender: Any) {
        Model.sharedDefaults.set(self.notificationSwitch.isOn, forKey: LocalKeys.notificationsEnabled)
        self.loadNotificationState()
        self.tableView.reloadData()
    }
    
    func getNotificationData() {
        self.morningNotificationEnabled = Model.sharedDefaults.bool(forKey: LocalKeys.morningNotificationEnabled)
        self.afternoonNotificationEnabled = Model.sharedDefaults.bool(forKey: LocalKeys.afternoonNotificationEnabled)
        self.eveningNotificationEnabled = Model.sharedDefaults.bool(forKey: LocalKeys.eveningNotificationEnabled)
        
        self.morningCell.detailTextLabel?.text = self.morningNotificationEnabled ? "Aktiviert" : "Deaktiviert"
        self.afternoonCell.detailTextLabel?.text = self.afternoonNotificationEnabled ? "Aktiviert" : "Deaktiviert"
        self.eveningCell.detailTextLabel?.text = self.eveningNotificationEnabled ? "Aktiviert" : "Deaktiviert"
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return notificationsEnabled ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            performSegue(withIdentifier: SegueIdentifiers.EditNotificationSegue, sender: indexPath)
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func getNotificationTimeFor(_ indexPath: IndexPath) -> NotificationTime {
        let row = indexPath.row
        switch row {
        case 0:
            return .morning
        case 1:
            return .afternoon
        case 2:
            return .evening
        default:
            return .error
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let indexPath = sender as? IndexPath, let editVC = segue.destination as? EditNotificationViewController else {
            fatalError()
        }

        editVC.notificationTime = self.getNotificationTimeFor(indexPath)
    }
    
    
}

enum NotificationTime {
    case morning
    case afternoon
    case evening
    case error
}
