//
//  Model.swift
//  myMood
//
//  Created by Marc Hein on 25.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit
import CoreData

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
}

struct SegueIdentifiers {
    static let AddEntryIdentifier = "addEntryIdentifier"
    static let ShowMoodIdentifier = "showMoodSegue"
    static let EditMoodIdentifier = "editMoodSegue"
    static let AddMoodIdentifier = "addMoodSegue"
}
