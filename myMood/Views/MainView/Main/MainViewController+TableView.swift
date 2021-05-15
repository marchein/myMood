//
//  MainViewController+TableView.swift
//  myMood
//
//  Created by Marc Hein on 27.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit
import CoreData

extension MainViewController {
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.moods.count > 0 {
            return 3
        }
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tableView.numberOfSections == 3, section == 0 {
            return self.moods.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Wie geht es Dir gerade?"
        } else if section == 1 {
            if self.tableView.numberOfSections == MainViewController.wantedSections {
                return "Letzter Eintrag"
            } else {
                return "Statistiken"
            }
        } else {
            return "Statistiken"
        }
    }
    
    private func getStatsCell() -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: StatsTableViewCell.reuseIdentifier)!
        Model.statsContainer.selectedTime = .allTime
        cell.textLabel?.text = "Einträge"
        cell.detailTextLabel?.text = "\(Model.statsContainer.data.count)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            guard let moodSelectionCell = self.tableView.dequeueReusableCell(withIdentifier: MoodSelectionTableViewCell.reuseIdentifier) as? MoodSelectionTableViewCell else {
                return UITableViewCell()
            }
            self.loadEmojis(for: moodSelectionCell)
            return moodSelectionCell
        } else if section == 1 {
            if self.tableView.numberOfSections == MainViewController.wantedSections {
                return self.getLatestEntryCell()
            }
        }
        return self.getStatsCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if self.tableView.cellForRow(at: indexPath)?.reuseIdentifier == StatsTableViewCell.reuseIdentifier {
            self.tabBarController?.selectedIndex = 2
        }
    }
    
    private func getLatestEntryCell() -> MoodTableViewCell {
        guard let latestMoodCell = self.tableView.dequeueReusableCell(withIdentifier: MoodTableViewCell.reuseIdentifier) as? MoodTableViewCell else {
            fatalError("Invalid identifier \(MoodTableViewCell.reuseIdentifier)")
        }
        
        let fetchedMood = self.moods[self.moods.count - 1]
        
        latestMoodCell.mood = fetchedMood
        latestMoodCell.timeLabel.text = "\(fetchedMood.isoDate) um \(fetchedMood.isoTime) Uhr"
        
        if fetchedMood.desc == nil || fetchedMood.desc!.count == 0 {
            latestMoodCell.descriptionLabel.text = "Keine Beschreibung vorhanden"
            latestMoodCell.toggleDescription()
        }
        return latestMoodCell
    }
    
    // MARK:- NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.updateFetchedResultsController()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}
