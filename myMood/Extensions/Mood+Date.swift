//
//  Mood+Date.swift
//  myMood
//
//  Created by Marc Hein on 25.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import Foundation

extension Mood {
    
    @objc var isoDate: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            guard let date = self.date else {
                return ""
            }
            return formatter.string(from: date)
        }
    }
    
    @objc var isoTime: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            guard let date = self.date else {
                return ""
            }
            return formatter.string(from: date)
        }
    }
}
