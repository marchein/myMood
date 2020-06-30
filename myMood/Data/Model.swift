//
//  Model.swift
//  myMood
//
//  Created by Marc Hein on 25.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit

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
    static let notificationsInitialized = "notificationsInitialized"
    
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

struct LocalKeysWidget {
    static let isInit = "isInit"
    // Mood from widget
    static let widgetMood = "widgetMood"
}

// MARK: - App Data
struct Model {
    static let Moods = ["😭", "😔", "😕", "😊", "😂"]

    static let groupIdentifier = "group.de.marc-hein.myMood.Data"
    static let groupIdentifierWidget = "group.de.marc-hein.myMood.Widget"
    
    static let DEBUG = "MH_DEBUG"
    static let appStoreId = "1515366183"
    static let mailAdress = "dev@marc-hein.de"
    static let website = "https://marc-hein.de/"
    static let versionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    static let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
}
