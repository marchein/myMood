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
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var fetchedResultsController: NSFetchedResultsController<Mood>? {
        didSet {
            fetchedResultsController?.delegate = self
        }
    }
    
    // MARK: - Outlets
    @IBOutlet var noItemsView: UIView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.updateFetchedResultsController()
    }
    
    private func setupView() {
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.ShowMoodIdentifier {
            guard let moodVC = segue.destination as? MoodViewController, let indexPath = self.tableView.indexPathForSelectedRow else {
                return
            }
            
            moodVC.fetchedResultsController = self.fetchedResultsController
            moodVC.mood = self.fetchedResultsController?.object(at: indexPath)
            moodVC.indexPath = indexPath
            
        }
    }
    
    // MARK: - Core Data
    func updateFetchedResultsController() {
        guard let context = container?.viewContext else {
            return
        }
        
        context.performAndWait {
            let fetchRequest: NSFetchRequest<Mood> = Mood.fetchRequest()
            
            fetchRequest.returnsObjectsAsFaults = false
            
            // Configure fetch request
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            // Create fetched results controlelr
            fetchedResultsController = NSFetchedResultsController<Mood>(
                fetchRequest: fetchRequest,
                managedObjectContext: context,
                sectionNameKeyPath: #keyPath(Mood.isoDate),
                cacheName: nil)
            do {
                try fetchedResultsController!.performFetch()
                self.tableView.reloadData()
            } catch {
                self.showAlert(alertText: "Fehler", alertMessage: "Es ist ein Fehler bei der iCloud Synchronisation aufgetreten: \(error)", closeButton: "Schließen")
            }
        }
    }
}
