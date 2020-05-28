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
    
    static let askForReviewAt = 5
    
    static let sharedDefaults: UserDefaults = UserDefaults(suiteName: Model.groupIdentifier)!
    
    static let defaultAppIcon = "default"
    static var appIcons = AppIcons(icons: [
        AppIcon(iconName: nil, iconTitle: "myMood - " + NSLocalizedString("icon_light", comment: "")),
        AppIcon(iconName: "myTodo2019dark", iconTitle: "myMood - "  + NSLocalizedString("icon_dark", comment: "")),
        AppIcon(iconName: "myTodo2", iconTitle: "myTodo (2014)"),
        AppIcon(iconName: "myTodo1", iconTitle: "myTodo (2013)")
    ])
}

//MARK:- Segues

struct SegueIdentifiers {
    static let AddEntryIdentifier = "addEntryIdentifier"
    static let ShowMoodIdentifier = "showMoodSegue"
    static let EditMoodIdentifier = "editMoodSegue"
    static let AddMoodIdentifier = "addMoodSegue"
}

//MARK:- myMoodIAP
struct myMoodIAP {
    static let smallTip = "de.marc_hein.myMood.tip.sm"
    static let mediumTip = "de.marc_hein.myMood.tip.md"
    static let largeTip = "de.marc_hein.myMood.tip.lg"
    
    static let allTips = [myMoodIAP.smallTip, myMoodIAP.mediumTip, myMoodIAP.largeTip]
}
