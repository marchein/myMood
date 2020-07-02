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
import SwiftUI
import Combine

final class Stats: ObservableObject {
    let didChange = PassthroughSubject<Stats, Never>()

    
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
                return -365*30                
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
            didChange.send(self)
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
    
    func getEntrysPerWeek() -> String {
        if let lastDay = Model.statsContainer.lastDay {
            let totalWeeks = Calendar.current.dateComponents([.weekOfMonth], from: Date(), to: lastDay.date!).weekOfMonth!
            let postsPerWerk = totalWeeks == 0 ? Model.statsContainer.data.count : Model.statsContainer.data.count / -totalWeeks
            return "\(postsPerWerk)"
        } else {
            return "0"
        }
    }
    
    func getNumberOfEntrys() -> String {
        return "\(self.data.count)"
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
    
    func addDemoData(entrys: Int, daysBack: Int, inViewController vc: UIViewController, showSpinner view: UIView) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                vc.showSpinner(onView: view)
                
            }
            guard let context = self.container?.viewContext else {
                return
            }
            print("generating \(entrys) entrys")
            for i in 0..<entrys {
                let newMood = Mood(context: context)
                
                let mood = Model.Moods.randomElement()!
                newMood.date = self.generateRandomDate(daysBack: daysBack)
                newMood.mood = mood
                newMood.desc = self.descForMood(index: Model.Moods.firstIndex(of: mood) ?? 0)
                
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                
                print(i)
            }
            DispatchQueue.main.async {
                print("remove spinner")
                vc.removeSpinner()
            }
        }
    }
    
    func descForMood(index: Int) -> String? {
        let moodDescs: [[String?]] = [
            [nil, "Hatte einen schlechen Tag", "Heute hätte nicht schlimmer sein können", "Ich bin sehr traurig", nil],
            [nil, "Heute hätte besser laufen können", "Mir geht es nicht gut", "Hoffentlich wird morgen besser", nil],
            [nil, "Heute Nacht hab ich nicht gut geschlafen", "Es ging mir zwischendurch schlecht", "Es geht langsam bergauf...", nil],
            [nil, "Mir gehts gut", "Sehe morgen meine Freunde wieder", "Habe mit meinen Tieren gespielt", "LOL", nil],
            [nil, "Heute war sehr großartig", "Besser kann der Tag nicht laufen", "Hatte viel Spaß mit meinen Freunden", nil],
        ];
        let randomDesc = Int.random(in: 0..<moodDescs[index].count)
        return moodDescs[index][Int(randomDesc)]
    }
}


enum Duration: String, CaseIterable, Hashable {
    case week = "Woche"
    case month = "Monat"
    case year = "Jahr"
    case allTime = "Gesamt"
}
