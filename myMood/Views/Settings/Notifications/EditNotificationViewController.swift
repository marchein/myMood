//
//  EditNotificationViewController.swift
//  myMood
//
//  Created by Marc Hein on 28.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit

class EditNotificationViewController: UITableViewController {
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var timeShowCell: UITableViewCell!
    @IBOutlet weak var timeCell: UITableViewCell!
    @IBOutlet weak var notificationTimePicker: UIDatePicker!
    
    var notificationEnabled = false
    var notificationTime: NotificationTime?
    var keys: KeyForTime!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.keys = getSetOfKeys(for: self.notificationTime ?? NotificationTime.error)!
        self.notificationEnabled = Model.sharedDefaults.bool(forKey: self.keys.enabled!)
        self.notificationSwitch.isOn = self.notificationEnabled
        self.notificationTimePicker.addTarget(self, action: #selector(self.timeChanged(_:)), for: .valueChanged)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.setupTime()
        self.updateNotification()
    }
    
    @IBAction func notificationSwitchToggled(_ sender: Any) {
        self.notificationEnabled = self.notificationSwitch.isOn
        Model.sharedDefaults.set(self.notificationSwitch.isOn, forKey: self.keys.enabled!)
        
        self.updateNotification()
        self.tableView.reloadData()
    }
    
    func getSetOfKeys(for notificationTime: NotificationTime) -> KeyForTime? {
        if notificationTime == .morning {
            return KeyForTime(notificationTime: .morning, enabled: LocalKeys.morningNotificationEnabled, hour: LocalKeys.morningNotificationHour, minute: LocalKeys.morningNotificationMinute)
        } else if notificationTime == .afternoon {
            return KeyForTime(notificationTime: .afternoon, enabled: LocalKeys.afternoonNotificationEnabled, hour: LocalKeys.afternoonNotificationHour, minute: LocalKeys.afternoonNotificationMinute)
        } else if notificationTime == .evening {
            return KeyForTime(notificationTime: .evening, enabled: LocalKeys.eveningNotificationEnabled, hour: LocalKeys.eveningNotificationHour, minute: LocalKeys.eveningNotificationMinute)
        }
        return nil;
    }
    
    @objc func timeChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
        guard let hour = components.hour, let minute = components.minute else {
            fatalError()
        }
        Model.sharedDefaults.set(hour, forKey: self.keys.hour!)
        Model.sharedDefaults.set(minute, forKey: self.keys.minute!)
        
        self.updateNotification()
        
        self.setupTime()
        self.tableView.reloadData()
    }
    
    func setupTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
                
        let hour = String(format: "%02d", Model.sharedDefaults.integer(forKey: self.keys.hour!))
        let minute = String(format: "%02d", Model.sharedDefaults.integer(forKey: self.keys.minute!))
        
        let time = formatter.date(from: "\(hour):\(minute)")!
        self.notificationTimePicker.date = time
        
        self.timeShowCell.detailTextLabel?.text = "\(formatter.string(from: time)) Uhr"
    }
    
    func removeNotification(with identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
        print("removed notifications with identifier: \(identifier)")
    }
    
    func updateNotification() {
        let notificationIdentifier = "myMood.\(self.notificationTime!)"
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (requests) in
            if requests.count > 0 {
                self.removeNotification(with: notificationIdentifier)
            }
            self.addNotification(with: notificationIdentifier)
        })
    }
    
    func addNotification(with identifier: String) {
        if self.notificationEnabled {
            let content = UNMutableNotificationContent()
            content.title = "Wie geht es Dir gerade?"
            content.categoryIdentifier = "myMood.reminder.category"
            content.sound = UNNotificationSound.default
            content.badge = 1
            
            var dateComponents = DateComponents()
            dateComponents.timeZone = TimeZone.init(abbreviation: "Europe/Berlin")
            dateComponents.hour = Model.sharedDefaults.integer(forKey: self.keys.hour!)
            dateComponents.minute = Model.sharedDefaults.integer(forKey: self.keys.minute!)
            dateComponents.second = 0
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("error in \(identifier) reminder: \(error.localizedDescription)")
                }
            }
            print("added notification: \(request.identifier)")
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return notificationEnabled ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 1 {
            return 165
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            guard let timeOfDay = self.notificationTime else {
                return nil
            }
            switch timeOfDay {
            case .morning:
                return "Wann möchtest Du morgens erinnert werden?"
            case .afternoon:
                return "Wann möchtest Du mittags erinnert werden?"
            case .evening:
                return "Wann möchtest Du abends erinnert werden?"
            default:
                return nil
            }
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

struct KeyForTime {
    var notificationTime: NotificationTime?
    var enabled: String?
    var hour: String?
    var minute: String?
}
