//
//  EntryTableTableViewController.swift
//  myMood
//
//  Created by Marc Hein on 25.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit
import CoreData

class EntryTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var fetchedResultsController: NSFetchedResultsController<Mood>!
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        
        self.fetchedResultsController = (UIApplication.shared.delegate as! AppDelegate).fetchedResultsController
        self.managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        self.fetchData()
        
        self.updateView()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = self.title
        
        self.tabBarController?.navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchData()
    }
    
    @objc private func fetchData() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        self.updateView()
    }
    
    private func setupView() {
        self.tableView.dataSource = self
        //self.setupMessageLabel()
        
        // Add Refresh Control to Table View
        self.refreshControl?.addTarget(self, action: #selector(self.fetchData), for: UIControl.Event.valueChanged)

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
    
    /*private func setupMessageLabel() {
     self.messageLabel.text = "Bisher existieren noch keine Stimmungen"
     }*/
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let firstItemInSection = self.fetchedResultsController.sections?[section].objects?[0] as? Mood
        return firstItemInSection?.isoDate
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            return 0
        }
        let num = sections[section].numberOfObjects
        print("\(num) objects in section \(section)")
        return num
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoodTableViewCell.reuseIdentifier, for: indexPath) as? MoodTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        if self.validateIndexPath(indexPath) {
            configureCell(cell: cell, indexPath: indexPath)
        } else {
            print("Attempting to configure a cell for an indexPath that is out of bounds: \(indexPath)")
        }
        
        return cell
    }
    
    private func configureCell(cell: MoodTableViewCell, indexPath: IndexPath) {
        cell.descriptionLabel.isHidden = false
        
        let mood = self.fetchedResultsController.object(at: indexPath)
        
        cell.timeLabel.text = "\(mood.isoTime) Uhr"
        cell.moodLabel.text = mood.mood
        if let desc = mood.desc, desc.count > 0 {
            cell.descriptionLabel.text = mood.desc
        } else {
            cell.descriptionLabel.isHidden = true
        }
    }
    
    func validateIndexPath(_ indexPath: IndexPath) -> Bool {
        if let sections = self.fetchedResultsController?.sections,
            indexPath.section < sections.count {
            if indexPath.row < sections[indexPath.section].numberOfObjects {
                return true
            }
        }
        return false
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let objectToDelete = self.fetchedResultsController.object(at: indexPath)
            self.managedObjectContext.delete(objectToDelete)
            do {
                try self.managedObjectContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            self.fetchData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        if segue.identifier == SegueIdentifiers.ShowMoodIdentifier {
            guard let moodVC = segue.destination as? MoodViewController, let indexPath = self.tableView.indexPathForSelectedRow else {
                return
            }
            
            let mood = self.fetchedResultsController.object(at: indexPath)
            
            moodVC.mood = mood
            moodVC.indexPath = indexPath
        }
     }
     
    
}
