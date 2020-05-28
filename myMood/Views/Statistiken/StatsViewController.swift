//
//  StatsViewController.swift
//  myMood
//
//  Created by Marc Hein on 28.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit
import CoreData

class StatsViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    // MARK: - Properties
    var StatsContainer = Stats()
    
    
    // MARK: - Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.segmentedControlChanged(self.segmentedControl!)
        //self.StatsContainer.addDemoData(entrys: 10000, daysBack: 900)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func segmentedControlChanged(_ sender: Any) {
        guard let segmentedControl = sender as? UISegmentedControl else {
            fatalError()
        }
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.StatsContainer.selectedTime = .week
            break
        case 1:
            self.StatsContainer.selectedTime = .month
            break
        case 2:
            self.StatsContainer.selectedTime = .year
            break
        case 3:
            fallthrough
        default:
            self.StatsContainer.selectedTime = .allTime
            break
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statsCell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "Einträge"
            cell.detailTextLabel?.text = "\(self.StatsContainer.data.count)"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Ältester Eintrag"
            let lastDay = self.StatsContainer.lastDay
            cell.detailTextLabel?.text = lastDay?.isoDate ?? "Kein Eintrag vorhanden"
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "Einträge pro Woche"
            if let lastDay = self.StatsContainer.lastDay {
                cell.textLabel?.text = "Einträge pro Woche"
                let totalWeeks = Calendar.current.dateComponents([.weekOfMonth], from: Date(), to: lastDay.date!).weekOfMonth!
                let postsPerWerk = totalWeeks == 0 ? self.StatsContainer.data.count : self.StatsContainer.data.count / -totalWeeks
                cell.detailTextLabel?.text = "\(postsPerWerk)"
            } else {
                cell.detailTextLabel?.text = "0"
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
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

enum Duration {
    case week
    case month
    case year
    case allTime
}
