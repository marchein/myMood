//
//  EntryViewController+TableView.swift
//  myMood
//
//  Created by Marc Hein on 27.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit
import CoreData

extension EntryViewController {
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = self.fetchedResultsController?.sections?.count, sections > 0 else {
            self.tableView.backgroundView = self.noItemsView
            self.tableView.separatorStyle = .none
            return 0
        }
        self.tableView.backgroundView = nil
        self.tableView.separatorStyle = .singleLine
        return sections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            return sections[section].name
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoodTableViewCell.reuseIdentifier, for: indexPath) as? MoodTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    private func configureCell(cell: MoodTableViewCell, indexPath: IndexPath) {
        guard let mood = self.fetchedResultsController?.object(at: indexPath) else {
            self.showAlert(alertText: "Fehler", alertMessage: "No mood retrieved for indexPath: \(indexPath)", closeButton: "Schließen")
            fatalError("No mood retrieved for indexPath: \(indexPath)")
        }
        cell.mood = mood
        cell.timeLabel.text = "\(mood.isoTime) Uhr"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            guard let objectToDelete = self.fetchedResultsController?.object(at: indexPath), let context = container?.viewContext else {
                return
            }
            context.delete(objectToDelete)
            do {
                try context.save()
            } catch let error as NSError {
                self.showAlert(alertText: "Fehler", alertMessage: "Es konnte nicht gespeichert werden. \(error), \(error.userInfo)", closeButton: "Schließen")
            }
        }
    }
    
    // MARK:- NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections([sectionIndex], with: .fade)
        case .delete:
            self.tableView.deleteSections([sectionIndex], with: .fade)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}
