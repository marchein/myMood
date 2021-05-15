//
//  StatsViewController.swift
//  myMood
//
//  Created by Marc Hein on 28.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit
import CoreData
import Charts

class StatsViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    // MARK: - Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControlChanged(segmentedControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Actions
    /**
     Select the correct time period in the model using the segmented control in the gui.
     
     - parameter sender: Which UISegmentedControl fired the action.
     
     # Example #
     ```
     segmentedControlChanged(segmentedControl)
     ```
     
     # Options #
     These are the options which can be selected using ```segementedControl.selectedSegmentIndex```:
     - 0: selects current week (starting today - 7 days)
     - 1: selects current month (starting today - 30 days)
     - 2: selects current year (starting today - 365 days)
     - 3 or other: selects all time (starting today - 30 * 365)
     
     */
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
        
        // reload table once the model has been updated
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        default:
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Allgemeine Statistiken"
        case 1:
            return "Verteilung"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // section is the one which has the pie chart in it
        if indexPath.section == 1 {
            return 300.0
            
        }
        return tableView.estimatedRowHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: StatsTableViewCell.reuseIdentifier, for: indexPath)
            switch row {
            case 0:
                cell.textLabel?.text = "Einträge"
                // get number of entries for given time period
                cell.detailTextLabel?.text = "\(Model.statsContainer.data.count)"
                break
            case 1:
                cell.textLabel?.text = "Ältester Eintrag"
                let lastDay = Model.statsContainer.lastDay
                // get date of the first entry for the selected time period
                cell.detailTextLabel?.text = lastDay?.isoDate ?? "Kein Eintrag vorhanden"
                break
            case 2:
                cell.textLabel?.text = "Einträge pro Woche"
                // check if last day for selected time period is available
                if let lastDay = Model.statsContainer.lastDay {
                    // get number of weeks. the result is negative so I inverted the result
                    let totalWeeks = -(Calendar.current.dateComponents([.weekOfMonth], from: Date(), to: lastDay.date!).weekOfMonth!)
                    // divide number of posts with number of total weeks
                    let postsPerWerk = totalWeeks == 0 ? Model.statsContainer.data.count : Model.statsContainer.data.count / totalWeeks
                    cell.detailTextLabel?.text = "\(postsPerWerk)"
                } else {
                    // if no entry is availble, show 0
                    cell.detailTextLabel?.text = "0"
                }
                break
            default:
                break
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: PieChartTableViewCell.reuseIdentifier, for: indexPath) as! PieChartTableViewCell
            // setup chart using the pie chart view inside the cell
            setupChart(pieChartView: cell.pieChart)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    /**
     Setup pie chart in statistics screen
     
     - parameter pieChartView: PieChartView object which will be configured.
     - warning: Currently there are only 5 colors implemented - if there are ever more moods, add option to automatically generate the needed colors
     
     # Example #
     ```
     let cell = tableView.dequeueReusableCell(withIdentifier: PieChartTableViewCell.reuseIdentifier, for: indexPath) as! PieChartTableViewCell
     setupChart(pieChartView: cell.pieChart)
     ```
     */
    private func setupChart(pieChartView: PieChartView) {
        // get data from model for the pie chart
        let statsData = Model.statsContainer.getPieChartData()
        // create empty data array
        var dataEntries: [ChartDataEntry] = []
        
        // iterate over data from model
        for statsMood in statsData {
            // create data entry from model data. Cast value to double as Charts expects a double as the value.
            let dataEntry = PieChartDataEntry(value: Double(statsMood.1), label: statsMood.0)
            dataEntries.append(dataEntry)
        }
        
        // create data set from the data Entries object
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Eingetragene Stimmungen")
        // set colors for the pie chart data set
        pieChartDataSet.colors = [.systemGray, .systemGray3, .orange, .systemTeal, .systemGreen]
        // create data for pie chart from data set
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        // to get rid of the .0 on the pie chart I set the number formatter to only show whole numbers
        let format = NumberFormatter()
        format.numberStyle = .decimal
        format.minimumFractionDigits = 0
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        
        // disable user interaction as it is weird to interact with the diagram in a table view
        pieChartView.isUserInteractionEnabled = false
        // hide the white hole in the pie chart
        pieChartView.holeColor = .clear
    }
}

enum Duration {
    case week
    case month
    case year
    case allTime
}
