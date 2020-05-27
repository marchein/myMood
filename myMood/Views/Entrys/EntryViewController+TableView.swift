//
//  EntryViewController+TableView.swift
//  myMood
//
//  Created by Marc Hein on 27.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit

extension EntryViewController {
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            return 0
        }
        let num = sections[section].numberOfObjects
        print("\(num) objects in section \(section)")
        return num
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let firstItemInSection = self.fetchedResultsController.sections?[section].objects?[0] as? Mood
        return firstItemInSection?.isoDate
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
        let mood = self.fetchedResultsController.object(at: indexPath)
        cell.mood = mood
        cell.timeLabel.text = "\(mood.isoTime) Uhr"
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
}
