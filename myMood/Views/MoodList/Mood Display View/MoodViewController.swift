//
//  MoodViewController.swift
//  myMood
//
//  Created by Marc Hein on 26.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit
import CoreData

class MoodViewController: UITableViewController {
    // MARK: - Outlets
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    
    // MARK: - Properties
    var mood: Mood?
    var indexPath: IndexPath?
    var fetchedResultsController: NSFetchedResultsController<Mood>?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = self.indexPath {
            if let frc = self.fetchedResultsController {
                self.mood = frc.object(at: indexPath)
                self.setupView()
            }
        } else {
            if let newMood = Model.getLastEntry() {
                self.mood = newMood
                self.setupView()
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    private func setupView() {        
        guard let mood = self.mood else {
            return
        }
        
        self.moodLabel.text = mood.mood
        self.dateLabel.text = mood.isoDate
        self.timeLabel.text = "\(mood.isoTime) Uhr"
        
        if let desc = mood.desc, desc.count > 0 {
            self.descTextView.text = desc
            self.descTextView.textColor = UIColor.label
        } else {
            self.descTextView.text = "Keine Beschreibung vorhanden"
            self.descTextView.textColor = UIColor.lightGray
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == SegueIdentifiers.EditMoodIdentifier {
            guard let editVC = segue.destination as? AddEntryViewController, let mood = mood else {
                return
            }
            
            editVC.mood = mood
        }
    }
    
    
}
