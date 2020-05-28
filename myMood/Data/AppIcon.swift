//
//  AppIcon.swift
//  myTodo
//
//  Created by Marc Hein on 15.11.18.
//  Copyright © 2018 Marc Hein Webdesign. All rights reserved.
//

import Foundation

struct AppIcon {
    let iconName: String?
    let iconTitle: String
    let startDate: Date?
    let endDate: Date?
    
    init(iconName: String?, iconTitle: String, startDate: Date? = nil, endDate: Date? = nil) {
        self.iconName = iconName
        self.iconTitle = iconTitle
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func isEnabled() -> Bool {
        let today = Date()
        if let start = startDate {
            if let end = endDate {
                return today > start && today < end
            } else {
                return today > start
            }
        }
        return true
    }
}

struct AppIcons {
    let icons: [AppIcon]
    var activatedIcons: [AppIcon]?
    
    init(icons: [AppIcon]) {
        self.icons = icons
    }
    
    mutating func contains(iconName: String?) -> Bool {
        getAllActivatedIcons()
        for currentIcon in activatedIcons! {
            if iconName == currentIcon.iconName {
                return true
            }
        }
        return false
    }
    
    mutating func count() -> Int {
        getAllActivatedIcons()
        return activatedIcons!.count
    }
    
    func getIcon(for index: Int) -> AppIcon? {
        if index >= 0 && index < icons.count {
            return icons[index]
        } else {
            return nil
        }
    }
    
    mutating func getAllActivatedIcons() {
        activatedIcons = []
        for currentIcon in icons {
            if currentIcon.isEnabled() {
                activatedIcons!.append(currentIcon)
            }
        }
    }
}
