//
//  Model+AppOnly.swift
//  myMood
//
//  Created by Marc Hein on 13.06.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit
import CoreData

extension Model {
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
    
    static let defaultAppIcon = "default"
    static var appIcons = AppIcons(icons: [
        AppIcon(iconName: nil, iconTitle: "myMood - Hell"),
        AppIcon(iconName: "myMood_dark", iconTitle: "myMood - dunkel")
    ])
    
    static let statsContainer = Stats()
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
