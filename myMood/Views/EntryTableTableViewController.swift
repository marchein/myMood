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
    
 
    // Responsible for listing out BlogIdeas in a table view

       // Holds a reference to an NSManagedObjectContext instance
       // which gets initialized in the SceneDelegate.swift file
       // and passed to this view controller when the scene gets "connected"

       // Uses NSFetchedResultsController to keep the table view in sync
       // with the Core Data managed object context

       // Implements swipe-to-delete with delete confirmation

       // Navigates to editor when someone taps on a table view row
       // and passes its NSManagedObjectContext instance along

    var moods = [Mood]() {
         didSet {
             self.updateView()
         }
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        print(viewContext)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func updateView() {
        let hasMoods = moods.count > 0

        tableView.isHidden = !hasMoods
        messageLabel.isHidden = hasMoods
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moods.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoodTableViewCell.reuseIdentifier, for: indexPath) as? MoodTableViewCell else {
            fatalError("Unexpected Index Path")
        }

        let mood = moods[indexPath.row]
        
        cell.timeLabel.text = "\(mood.date)"
        cell.moodLabel.text = mood.mood
        cell.descriptionLabel.text = mood.desc

        return cell
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
