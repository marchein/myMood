//
//  Model.swift
//  myMood
//
//  Created by Marc Hein on 25.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit

struct Model {
    static let Moods = ["😭", "😔", "😕", "😊", "😂"]
}

struct SegueIdentifiers {
    static let AddEntryIdentifier = "addEntryIdentifier"
    static let ShowMoodIdentifier = "showMoodSegue"
    static let EditMoodIdentifier = "editMoodSegue"
    static let AddMoodIdentifier = "addMoodSegue"
}
