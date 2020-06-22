//
//  TodayViewController.swift
//  Widget
//
//  Created by Marc Hein on 13.06.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var emojiStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadEmojis()
        print(UserDefaults.widget.integer(forKey: LocalKeysWidget.widgetMood))
    }
    
    func loadEmojis() {
        for subview in emojiStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        for i in 0..<Model.Moods.count {
            let emoji = Model.Moods[i]
            let button = UIButton()
            button.frame.size = CGSize(width: 50, height: 50)
            
            button.tag = i
            button.setTitle(emoji, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 48)
            button.addTarget(self, action: #selector(emojiTapped), for: .touchUpInside)
            emojiStackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - Actions
    @IBAction func emojiTapped(_ sender: UIButton) {
        let tag = sender.tag
        UserDefaults.widget.set(tag, forKey: LocalKeysWidget.widgetMood)
        UserDefaults.widget.synchronize()
        extensionContext?.open(URL(string: "myMood://")!, completionHandler: nil)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
