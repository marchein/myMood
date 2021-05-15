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
    
    var notificationsAllowed = false
    var notificationsEnabled = false
    var morningNotificationEnabled = false
    var afternoonNotificationEnabled = false
    var eveningNotificationEnabled = false
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkForNotifications()
        self.loadNotificationState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getNotificationData()
        self.tableView.reloadData()
    }
    
    func checkForNotifications() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
            if didAllow {
                DispatchQueue.main.async {
                    let notificationsInitialized = UserDefaults.data.bool(forKey: LocalKeys.notificationsInitialized)
                    if !notificationsInitialized {
                        self.setupNotifications()
                    }
                }
            }
        }
        
    }
    
    func setupNotifications() {
        notificationCenter.getNotificationSettings(completionHandler: { (settings) in
            self.notificationsAllowed = settings.authorizationStatus == .authorized
            UserDefaults.data.set(self.notificationsAllowed, forKey: LocalKeys.notificationsEnabled)
            UserDefaults.data.set(self.notificationsAllowed, forKey: LocalKeys.morningNotificationEnabled)
            UserDefaults.data.set(8, forKey: LocalKeys.morningNotificationHour)
            UserDefaults.data.set(0, forKey: LocalKeys.morningNotificationMinute)
            UserDefaults.data.set(self.notificationsAllowed, forKey: LocalKeys.afternoonNotificationEnabled)
            UserDefaults.data.set(13, forKey: LocalKeys.afternoonNotificationHour)
            UserDefaults.data.set(0, forKey: LocalKeys.afternoonNotificationMinute)
            UserDefaults.data.set(self.notificationsAllowed, forKey: LocalKeys.eveningNotificationEnabled)
            UserDefaults.data.set(20, forKey: LocalKeys.eveningNotificationHour)
            UserDefaults.data.set(0, forKey: LocalKeys.eveningNotificationMinute)
            UserDefaults.data.set(true, forKey: LocalKeys.notificationsInitialized)
            self.loadNotificationState()
            self.getNotificationData()
        })
    }
    
    func loadNotificationState() {
        notificationsEnabled = UserDefaults.data.bool(forKey: LocalKeys.notificationsEnabled)
        DispatchQueue.main.async {
            self.notificationSwitch.isOn = self.notificationsEnabled
            self.tableView.reloadData()
        }
    }
    
    @IBAction func notificationSwitchToggled(_ sender: Any) {
        UserDefaults.data.set(self.notificationSwitch.isOn, forKey: LocalKeys.notificationsEnabled)
        loadNotificationState()
    }
    
    func getNotificationData() {
        morningNotificationEnabled = UserDefaults.data.bool(forKey: LocalKeys.morningNotificationEnabled)
        afternoonNotificationEnabled = UserDefaults.data.bool(forKey: LocalKeys.afternoonNotificationEnabled)
        eveningNotificationEnabled = UserDefaults.data.bool(forKey: LocalKeys.eveningNotificationEnabled)
        
        DispatchQueue.main.async {
            self.morningCell.detailTextLabel?.text = self.morningNotificationEnabled ? "Aktiviert" : "Deaktiviert"
            self.afternoonCell.detailTextLabel?.text = self.afternoonNotificationEnabled ? "Aktiviert" : "Deaktiviert"
            self.eveningCell.detailTextLabel?.text = self.eveningNotificationEnabled ? "Aktiviert" : "Deaktiviert"
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return notificationsEnabled ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            performSegue(withIdentifier: SegueIdentifiers.EditNotificationSegue, sender: indexPath)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func getNotificationTimeFor(_ indexPath: IndexPath) -> NotificationTime {
        switch indexPath.row {
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
