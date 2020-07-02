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
    // MARK: - Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.segmentedControlChanged(self.segmentedControl)
        
        //Model.statsContainer.addDemoData(entrys: 10000, daysBack: 900)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl?) {
        guard let segmentedControl = sender else {
            fatalError()
        }
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            Model.statsContainer.selectedTime = .week
            break
        case 1:
            Model.statsContainer.selectedTime = .month
            break
        case 2:
            Model.statsContainer.selectedTime = .year
            break
        case 3:
            fallthrough
        default:
            Model.statsContainer.selectedTime = .allTime
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
            cell.detailTextLabel?.text = "\(Model.statsContainer.data.count)"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Ältester Eintrag"
            cell.detailTextLabel?.text = Model.statsContainer.lastDay?.isoDate ?? "Kein Eintrag vorhanden"
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "Einträge pro Woche"
            if let lastDay = Model.statsContainer.lastDay {
                cell.textLabel?.text = "Einträge pro Woche"
                let totalWeeks = Calendar.current.dateComponents([.weekOfMonth], from: Date(), to: lastDay.date!).weekOfMonth!
                let postsPerWerk = totalWeeks == 0 ? Model.statsContainer.data.count : Model.statsContainer.data.count / -totalWeeks
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
}
