//
//  EntryTableTableViewController.swift
//  myMood
//
//  Created by Marc Hein on 25.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit
import CoreData

class EntryViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    // MARK: - Properties
    var fetchedResultsController: NSFetchedResultsController<Mood>!
    var managedObjectContext: NSManagedObjectContext!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        self.fetchData()
        self.updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
    }
    
    private func setupView() {
        self.fetchedResultsController = (UIApplication.shared.delegate as! AppDelegate).fetchedResultsController
        self.managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.refreshControl?.addTarget(self, action: #selector(self.fetchData), for: UIControl.Event.valueChanged)
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func updateView() {
        var hasMoods = false
        
        if let moods = self.fetchedResultsController.fetchedObjects {
            hasMoods = moods.count > 0
        }
        
        self.tableView.isHidden = !hasMoods
        //self.messageLabel.isHidden = hasMoods
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    @objc func fetchData() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        self.updateView()
    }    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.ShowMoodIdentifier {
            guard let moodVC = segue.destination as? MoodViewController, let indexPath = self.tableView.indexPathForSelectedRow else {
                return
            }
            
            let mood = self.fetchedResultsController.object(at: indexPath)
            
            moodVC.indexPath = indexPath
            moodVC.mood = mood

        }
    }
    
    
}
