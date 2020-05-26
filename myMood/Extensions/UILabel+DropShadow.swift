//
//  UILabel+DropShadow.swift
//  myMood
//
//  Created by Marc Hein on 25.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit

extension UILabel {
    func addDropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        if #available(iOS 13, *) {
            self.layer.shadowColor = UIColor.label.cgColor
        } else {
            self.layer.shadowColor = UIColor.black.cgColor
        }
    }
    
    func removeDropShadow() {
        self.layer.masksToBounds = true
        self.layer.shadowRadius = 0.0
        self.layer.shadowOpacity = 0.0
        self.layer.shadowOffset = CGSize()
    }
    
    static func createCustomLabel() -> UILabel {
        let label = UILabel()
        label.addDropShadow()
        return label
    }
}
