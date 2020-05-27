//
//  MainViewController.swift
//  myMood
//
//  Created by Marc Hein on 25.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UITableViewController, ModalDelegate {
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.tabBarController?.title = self.title
        self.tabBarController?.navigationItem.rightBarButtonItem = nil;
    }
    
    func didCloseModal() {
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.AddEntryIdentifier {
            guard let navVC = segue.destination as? UINavigationController, let addVC = navVC.viewControllers[0] as? AddEntryViewController, let emoji = sender as? UIButton else {
                return
            }
            addVC.selectedEmoji = emoji.titleLabel?.text
        } else if segue.identifier == SegueIdentifiers.ShowMoodIdentifier {
            guard let moodVC = segue.destination as? MoodViewController else {
                return
            }
            moodVC.title = "Letzter Eintrag"
            moodVC.mood = Model.getLastEntry()
        }
    }
    
    // MARK: - Actions
    @IBAction func emojiTapped(_ sender: UIButton) {
        performSegue(withIdentifier: SegueIdentifiers.AddEntryIdentifier, sender: sender)
    }
   
    func loadEmojis(for cell: MoodSelectionTableViewCell) {
        for subview in cell.emojiStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        for emoji in Model.Moods {
            let button = UIButton()
            button.setTitle(emoji, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 32)
            button.addTarget(self, action: #selector(emojiTapped), for: .touchUpInside)
            
            cell.emojiStackView.addArrangedSubview(button)
        }
    }
    
    
}
