//
//  Model.swift
//  myMood
//
//  Created by Marc Hein on 25.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit
import CoreData

//MARK:- Local Keys
struct LocalKeys {
    static let isSetup = "isSetup"
    static let moodsAdded = "moodsAdded"
    // which is the current App icon?
    static let currentAppIcon = "currentIcon"
    // is beta tester?
    static let isTester = "isTester"
    // has tipped?
    static let hasTipped = "hasTipped"
    
    // notificationsEnabled?
    static let notificationsEnabled = "notificationsEnabled"
    
    static let morningNotificationEnabled = "morningNotificationEnabled"
    static let morningNotificationHour = "morningNotificationHour"
    static let morningNotificationMinute = "morningNotificationMinute"
    
    static let afternoonNotificationEnabled = "afternoonNotificationEnabled"
    static let afternoonNotificationHour = "afternoonNotificationHour"
    static let afternoonNotificationMinute = "afternoonNotificationMinute"
    
    static let eveningNotificationEnabled = "eveningNotificationEnabled"
    static let eveningNotificationHour = "eveningNotificationHour"
    static let eveningNotificationMinute = "eveningNotificationMinute"
}

// MARK: - App Data
struct Model {
    static let Moods = ["😭", "😔", "😕", "😊", "😂"]
    
    static func getLastEntry() -> Mood? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Mood> = Mood.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.fetchLimit = 1
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                return results[0]
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    
    static let DEBUG = "MH_DEBUG"
    static let groupIdentifier = "group.de.marc-hein.myMood.Data"
    static let appStoreId = "1515366183"
    static let mailAdress = "dev@marc-hein.de"
    static let website = "https://marc-hein.de/"
    static let versionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    static let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        
    static let sharedDefaults: UserDefaults = UserDefaults(suiteName: "groupIdentifier")!
    
    static let defaultAppIcon = "default"
    static var appIcons = AppIcons(icons: [
        AppIcon(iconName: nil, iconTitle: "myMood - Hell")
    ])
}

//MARK:- Segues

struct SegueIdentifiers {
    static let AddEntryIdentifier = "addEntryIdentifier"
    static let ShowMoodIdentifier = "showMoodSegue"
    static let EditMoodIdentifier = "editMoodSegue"
    static let AddMoodIdentifier = "addMoodSegue"
    static let EditNotificationSegue = "editNotificationSegue"
}

//MARK:- myMoodIAP
struct myMoodIAP {
    static let smallTip = "de.marc_hein.myMood.tip.sm"
    static let mediumTip = "de.marc_hein.myMood.tip.md"
    static let largeTip = "de.marc_hein.myMood.tip.lg"
    static let hugeTip = "de.marc_hein.myMood.tip.xl"
    
    static let allTips = [myMoodIAP.smallTip, myMoodIAP.mediumTip, myMoodIAP.largeTip, myMoodIAP.hugeTip]
}
