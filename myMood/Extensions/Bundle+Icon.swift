//
//  Bundle+Icon.swift
//  myTodo
//
//  Created by Marc Hein on 20.11.18.
//  Copyright © 2018 Marc Hein Webdesign. All rights reserved.
//

import Foundation
import UIKit

extension Bundle {
    public var icon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any], let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any], let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String], let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
}

