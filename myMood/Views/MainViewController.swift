//
//  MainViewController.swift
//  myMood
//
//  Created by Marc Hein on 25.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    @IBOutlet weak var emojiStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadEmojis()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = self.title
        self.tabBarController?.navigationItem.rightBarButtonItem = nil;
    }
    
    func loadEmojis() {
        print(emojiStackView.arrangedSubviews)
        for subview in self.emojiStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        for emoji in Model.Moods {
            let button = UIButton()
            button.setTitle(emoji, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 32)
            button.addTarget(self, action: #selector(emojiTapped), for: .touchUpInside)
            
            self.emojiStackView.addArrangedSubview(button)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.AddEntryIdentifier {
            guard let destination = segue.destination as? AddEntryViewController, let emoji = sender as? UIButton else {
                return
            }
            destination.selectedEmoji = emoji.titleLabel?.text
        }
    }
    
    @IBAction func emojiTapped(_ sender: UIButton) {
        performSegue(withIdentifier: SegueIdentifiers.AddEntryIdentifier, sender: sender)
    }
}
