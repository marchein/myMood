//
//  MainViewController.swift
//  myMood
//
//  Created by Marc Hein on 25.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit
import CoreData



class MainViewController: UITableViewController, ModalDelegate, NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var fetchedResultsController: NSFetchedResultsController<Mood>? {
        didSet {
            fetchedResultsController?.delegate = self
        }
    }
    var moods: [Mood] = []
    var statsContainer = Stats()
    static let wantedSections = 3
    var notificationsAllowed = false
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.shared.delegate as! AppDelegate).mainVC = self
        self.setupApp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateFetchedResultsController()
    }
    
    func didCloseModal() {
        self.updateFetchedResultsController()
    }
    
    fileprivate func setupApp() {
        let appSetup = Model.sharedDefaults.bool(forKey: LocalKeys.isSetup)
        
        if !appSetup {
            Model.sharedDefaults.set(isSimulatorOrTestFlight(), forKey: LocalKeys.isTester)
            Model.sharedDefaults.set(Model.defaultAppIcon, forKey: LocalKeys.currentAppIcon)
            Model.sharedDefaults.set(0, forKey: LocalKeys.moodsAdded)
            self.setupNotifications()
            Model.sharedDefaults.set(true, forKey: LocalKeys.isSetup)
        }
        
    }
    
    private func setupNotifications() {
        let notificationCenter = (UIApplication.shared.delegate as? AppDelegate)?.notificationCenter
        
        notificationCenter?.getNotificationSettings(completionHandler: { (settings) in
            self.notificationsAllowed = settings.authorizationStatus == .authorized
            Model.sharedDefaults.set(self.notificationsAllowed, forKey: LocalKeys.notificationsEnabled)
            Model.sharedDefaults.set(self.notificationsAllowed, forKey: LocalKeys.morningNotificationEnabled)
            Model.sharedDefaults.set(8, forKey: LocalKeys.morningNotificationHour)
            Model.sharedDefaults.set(0, forKey: LocalKeys.morningNotificationMinute)
            Model.sharedDefaults.set(self.notificationsAllowed, forKey: LocalKeys.afternoonNotificationEnabled)
            Model.sharedDefaults.set(13, forKey: LocalKeys.afternoonNotificationHour)
            Model.sharedDefaults.set(0, forKey: LocalKeys.afternoonNotificationMinute)
            Model.sharedDefaults.set(self.notificationsAllowed, forKey: LocalKeys.eveningNotificationEnabled)
            Model.sharedDefaults.set(20, forKey: LocalKeys.eveningNotificationHour)
            Model.sharedDefaults.set(0, forKey: LocalKeys.eveningNotificationMinute)
        })
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.AddEntryIdentifier {
            guard let navVC = segue.destination as? UINavigationController, let addVC = navVC.viewControllers[0] as? AddEntryViewController, let emoji = sender as? UIButton else {
                return
            }
            addVC.selectedEmoji = emoji.titleLabel?.text
        } else if segue.identifier == SegueIdentifiers.ShowMoodIdentifier {
            guard let moodVC = segue.destination as? MoodViewController else {
                return
            }
            moodVC.title = "Letzter Eintrag"
            moodVC.mood = self.moods[self.moods.count - 1]
        }
    }
    
    // MARK: - Actions
    @IBAction func emojiTapped(_ sender: UIButton) {
        performSegue(withIdentifier: SegueIdentifiers.AddEntryIdentifier, sender: sender)
    }
    
    func loadEmojis(for cell: MoodSelectionTableViewCell) {
        for subview in cell.emojiStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        for emoji in Model.Moods {
            let button = UIButton()
            button.setTitle(emoji, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 32)
            button.addTarget(self, action: #selector(emojiTapped), for: .touchUpInside)
            
            cell.emojiStackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - Core Data
    func updateFetchedResultsController() {
        guard let context = container?.viewContext else {
            return
        }
        
        context.perform {
            let fetchRequest: NSFetchRequest<Mood> = Mood.fetchRequest()
            
            fetchRequest.returnsObjectsAsFaults = false
            
            // Configure fetch request
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            
            fetchRequest.fetchLimit = 1
            
            // Create fetched results controlelr
            self.fetchedResultsController = NSFetchedResultsController<Mood>(
                fetchRequest: fetchRequest,
                managedObjectContext: context,
                sectionNameKeyPath: #keyPath(Mood.isoDate),
                cacheName: nil)
            
            do {
                try self.fetchedResultsController!.performFetch()
                if let moods = self.fetchedResultsController?.fetchedObjects {
                    self.moods = moods
                    self.tableView.reloadData()
                }
            } catch {
                self.showAlert(alertText: "Fehler", alertMessage: "Es ist ein Fehler bei der iCloud Synchronisation aufgetreten: \(error)", closeButton: "Schließen")
            }
        }
    }
}
