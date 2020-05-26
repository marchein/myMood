//
//  UIViewController+Modal.swift
//  myMood
//
//  Created by Marc Hein on 26.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit

// MARK: - UIViewController implementation

extension UIViewController {

    var isModal: Bool {

        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController

        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
}
