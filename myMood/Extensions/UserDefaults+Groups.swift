//
//  UserDefaults+Groups.swift
//  myMood
//
//  Created by Marc Hein on 22.06.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import Foundation

extension UserDefaults {
    static let data = UserDefaults(suiteName: Model.groupIdentifier)!
    static let widget = UserDefaults(suiteName: Model.groupIdentifier)!
}
