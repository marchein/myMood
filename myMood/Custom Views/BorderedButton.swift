//
//  BorderedButton.swift
//  myTodo
//
//  Created by Marc Hein on 13.11.18.
//  Copyright © 2018 Marc Hein Webdesign. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class BorderedButton: UIButton {
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            if let bColor = borderColor {
                self.layer.borderColor = bColor.cgColor
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            guard let currentBorderColor = borderColor else {
                return
            }
            
            let fadedColor = currentBorderColor.withAlphaComponent(0.2).cgColor
            
            if isHighlighted {
                layer.borderColor = fadedColor
            } else {
                
                self.layer.borderColor = currentBorderColor.cgColor
                
                let animation = CABasicAnimation(keyPath: "borderColor")
                animation.fromValue = fadedColor
                animation.toValue = currentBorderColor.cgColor
                animation.duration = 0.4
                self.layer.add(animation, forKey: "")
            }
        }
    }
}
