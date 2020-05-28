//
//  Stats.swift
//  myMood
//
//  Created by Marc Hein on 28.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Stats {
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    var selectedTime: Duration = .allTime
    var difference: Int {
        get {
            switch selectedTime {
            case .week:
                return -7
            case .month:
                return -30
            case .year:
                return -365
            case .allTime:
                fallthrough
            default:
                return -4000
            }
        }
    }
    var data: [Mood] {
        get {
            guard let context = container?.viewContext else {
                return []
            }
            
            var data: [Mood] = []
            context.performAndWait {
                let fetchRequest: NSFetchRequest<Mood> = Mood.fetchRequest()
                
                fetchRequest.returnsObjectsAsFaults = false
                
                let calendar = Calendar.current
                let now = Date()
                
                let timeFrame = calendar.date(byAdding: .day, value: difference, to: now)?.startOfDay
                let predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", timeFrame! as NSDate, now as NSDate)
                fetchRequest.predicate = predicate
                
                // Configure fetch request
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                
                do {
                    data = try context.fetch(fetchRequest)
                } catch {
                    fatalError("error: \(error)")
                }
            }
            return data
        }
    }
    
    var lastDay: Mood? {
        get {
            let count = self.data.count
            if count == 0 {
                return nil
            } else {
                return self.data[self.data.count - 1]
            }
        }
    }
    
    func generateRandomDate(daysBack: Int)-> Date?{
        let day = arc4random_uniform(UInt32(daysBack))+1
        let hour = arc4random_uniform(23)
        let minute = arc4random_uniform(59)
        let today = Date(timeIntervalSinceNow: 0)
        let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.day = -1 * Int(day - 1)
        offsetComponents.hour = -1 * Int(hour)
        offsetComponents.minute = -1 * Int(minute)
        let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
        return randomDate
    }
    
    func addDemoData(entrys: Int, daysBack: Int) {
        guard let context = container?.viewContext else {
            return
        }
        for _ in 0...entrys {
            let newMood = Mood(context: context)
            
            newMood.date = generateRandomDate(daysBack: daysBack)
            newMood.mood = Model.Moods.randomElement()
            newMood.desc = "Random data"
            
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
