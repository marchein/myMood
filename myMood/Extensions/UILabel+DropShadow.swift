//
//  UILabel+DropShadow.swift
//  myMood
//
//  Created by Marc Hein on 25.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit

extension UILabel {
    func textDropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    
    func removeDropShadow() {
        self.layer.masksToBounds = true
        self.layer.shadowRadius = 0.0
        self.layer.shadowOpacity = 0.0
        self.layer.shadowOffset = CGSize()
    }

    static func createCustomLabel() -> UILabel {
        let label = UILabel()
        label.textDropShadow()
        return label
    }
}
