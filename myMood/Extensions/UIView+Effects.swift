//
//  UIView+Effects.swift
//  myTodo
//
//  Created by Marc Hein on 20.11.18.
//  Copyright © 2018 Marc Hein Webdesign. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 5
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func roundCorners(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func fixInputAssistant() {
        for subview in self.subviews {
            if type(of: subview) is UITextField.Type {
                let item = (subview as! UITextField).inputAssistantItem
                item.leadingBarButtonGroups = []
                item.trailingBarButtonGroups = []
            } else if subview.subviews.count > 0 {
                subview.fixInputAssistant()
            }
        }
    }
}

