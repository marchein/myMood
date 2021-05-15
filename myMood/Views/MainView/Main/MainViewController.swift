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
    // reference to persistent container of app
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var fetchedResultsController: NSFetchedResultsController<Mood>? {
        didSet {
            fetchedResultsController?.delegate = self
        }
    }
    var moods: [Mood] = []
    static let wantedSections = 3
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupWidget()
    }
    
    func didCloseModal() {
        self.updateFetchedResultsController()
    }
    
    fileprivate func setupApp() {
        let appSetup = UserDefaults.data.bool(forKey: LocalKeys.isSetup)
        
        if !appSetup {
            UserDefaults.data.set(isSimulatorOrTestFlight(), forKey: LocalKeys.isTester)
            UserDefaults.data.set(Model.defaultAppIcon, forKey: LocalKeys.currentAppIcon)
            UserDefaults.data.set(0, forKey: LocalKeys.moodsAdded)
            UserDefaults.data.set(true, forKey: LocalKeys.isSetup)
        }
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
                    self.updateStats()
                }
            } catch {
                self.showAlert(alertText: "Fehler", alertMessage: "Es ist ein Fehler bei der iCloud Synchronisation aufgetreten: \(error)", closeButton: "Schließen")
            }
        }
    }
    
    private func updateStats() {
        guard let mainVCNavVC = self.parent as? UINavigationController, let tabController = mainVCNavVC.parent as? UITabBarController else {
            return
        }
        for vc in tabController.viewControllers! {
            guard let navVC = vc as? UINavigationController, let statsVC = navVC.children.first as? StatsViewController else {
                continue
            }
            statsVC.tableView.reloadData()
        }
    }
    
    
    // MARK: - Widget
    func setupWidget() {
        UserDefaults.widget.synchronize()
        
        let widgetInit = UserDefaults.widget.bool(forKey: LocalKeysWidget.isInit)
        
        if !widgetInit {
            UserDefaults.widget.set(-1, forKey: LocalKeysWidget.widgetMood)
            UserDefaults.widget.set(true, forKey: LocalKeysWidget.isInit)
            UserDefaults.widget.synchronize()
        }
        
        let widgetMood = UserDefaults.widget.integer(forKey: LocalKeysWidget.widgetMood)
        
        if (0..<Model.Moods.count).contains(widgetMood) {
            self.handleWidget(index: widgetMood)
            
            UserDefaults.widget.set(-1, forKey: LocalKeysWidget.widgetMood)
            UserDefaults.widget.synchronize()
        }
    }
    
    func handleWidget(index: Int) {
        if self.presentedViewController != nil {
            self.dismiss(animated: false, completion: nil)
        }
        
        let button = UIButton()
        button.titleLabel?.text = Model.Moods[index]
        self.performSegue(withIdentifier: SegueIdentifiers.AddEntryIdentifier, sender: button)
    }
}
