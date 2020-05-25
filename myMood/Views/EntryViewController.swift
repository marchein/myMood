//
//  EntryTableTableViewController.swift
//  myMood
//
//  Created by Marc Hein on 25.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit
import CoreData

class EntryViewController: UIViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    // Responsible for listing out BlogIdeas in a table view
    
    // Holds a reference to an NSManagedObjectContext instance
    // which gets initialized in the SceneDelegate.swift file
    // and passed to this view controller when the scene gets "connected"
    
    // Uses NSFetchedResultsController to keep the table view in sync
    // with the Core Data managed object context
    
    // Implements swipe-to-delete with delete confirmation
    
    // Navigates to editor when someone taps on a table view row
    // and passes its NSManagedObjectContext instance along
    
    var fetchedResultsController: NSFetchedResultsController<Mood>!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        
        self.fetchedResultsController = (UIApplication.shared.delegate as! AppDelegate).fetchedResultsController
        
        self.fetchData()
        
        self.updateView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = self.title
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEditing))
        self.tabBarController?.navigationItem.rightBarButtonItem = editButton
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
        self.setupMessageLabel()
        
        // Add Refresh Control to Table View
        self.tableView.refreshControl = refreshControl
        self.refreshControl.addTarget(self, action: #selector(self.fetchData), for: .valueChanged)
    }
    
    private func updateView() {
        var hasMoods = false
        
        if let moods = self.fetchedResultsController.fetchedObjects {
            hasMoods = moods.count > 0
        }
        
        self.tableView.isHidden = !hasMoods
        self.messageLabel.isHidden = hasMoods
        
        self.refreshControl.endRefreshing()
        self.activityIndicatorView.stopAnimating()
        self.tableView.reloadData()
    }
    
    @objc private func toggleEditing() {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEditing))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(toggleEditing))
        
        if self.tableView.isEditing {
            self.tabBarController?.navigationItem.rightBarButtonItem = doneButton
        } else {
            self.tabBarController?.navigationItem.rightBarButtonItem = editButton
        }
        
    }
    
    private func setupMessageLabel() {
        self.messageLabel.text = "Bisher existieren noch keine Stimmungen"
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let firstItemInSection = self.fetchedResultsController.sections?[section].objects?[0] as? Mood
        return firstItemInSection?.isoDate
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.fetchedResultsController.sections?[section]
        return (section?.numberOfObjects)!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        let mood = self.fetchedResultsController.object(at: indexPath)
        
        cell.timeLabel.text = "\(mood.isoTime) Uhr"
        cell.moodLabel.text = mood.mood
        cell.descriptionLabel.text = mood.desc
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
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
