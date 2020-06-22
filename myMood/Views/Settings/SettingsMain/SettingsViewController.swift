//
//  SettingsViewController.swift
//  myMood
//
//  Created by Marc Hein on 27.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UITableViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var notificationCell: UITableViewCell!
    @IBOutlet weak var appIconCell: UITableViewCell!
    @IBOutlet weak var appIconIV: UIImageView!
    @IBOutlet weak var appVersionCell: UITableViewCell!
    @IBOutlet weak var appSupportCell: UITableViewCell!
    @IBOutlet weak var appStoreCell: UITableViewCell!
    @IBOutlet weak var rateAppCell: UITableViewCell!
    @IBOutlet weak var developerCell: UITableViewCell!
    @IBOutlet weak var resetCoreDataCell: UITableViewCell!
    @IBOutlet weak var resetAppCell: UITableViewCell!
    
    // MARK:- Class Attributes
    private var currentAppIcon: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.setupView()
    }
    
    func setupView() {
        self.appVersionCell.detailTextLabel?.text = Model.versionString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reconfigureView()
    }
    
    fileprivate func reconfigureView() {
        currentAppIcon = UserDefaults.data.string(forKey: LocalKeys.currentAppIcon)
        if !Model.appIcons.contains(iconName: currentAppIcon) {
            currentAppIcon = Model.defaultAppIcon
            UserDefaults.data.set(currentAppIcon, forKey: LocalKeys.currentAppIcon)
        }
        
        if let appIcon = currentAppIcon {
            appIconIV.image = appIcon == Model.defaultAppIcon ? Bundle.main.icon : UIImage(named: appIcon)
            appIconIV.roundCorners(radius: 6)
        }
        
        let notificationsEnabled = UserDefaults.data.bool(forKey: LocalKeys.notificationsEnabled)
        self.notificationCell.detailTextLabel?.text = notificationsEnabled ? "Aktiviert" : "Deaktiviert"
        
        print("did reconfigure")
        
        self.tableView.reloadData()
    }
    
    func appStoreAction() {
        let urlStr = "itms-apps://itunes.apple.com/app/id\(Model.appStoreId)"
        if let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func resetCoreDataAction() {
        let resetAlert = UIAlertController(title: "Core Data zurücksetzen", message: "Mit dieser Aktion wird Core Data zurückgesetzt. Diese Aktion kann nicht rückgängig gemacht werden.", preferredStyle: UIAlertController.Style.alert)
        
        resetAlert.addAction(UIAlertAction(title: "Zurücksetzen", style: .destructive, handler: { (action: UIAlertAction!) in
            self.resetCoreData()
        }))
        
        resetAlert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(resetAlert, animated: true, completion: nil)
        
    }
    
    func resetAppAction() {
        let resetAlert = UIAlertController(title: "Gesamte App zurücksetzen", message: "Mit dieser Aktion wird die gesamte App zurückgesetzt. Diese Aktion kann nicht rückgängig gemacht werden.", preferredStyle: UIAlertController.Style.alert)
        
        resetAlert.addAction(UIAlertAction(title: "Zurücksetzen", style: .destructive, handler: { (action: UIAlertAction!) in
            self.resetCoreData()
            self.resetDefaults()
            self.killApp()
        }))
        
        resetAlert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(resetAlert, animated: true, completion: nil)
        
    }
    
    private func resetCoreData() {
        let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Mood.fetchRequest()
        fetchRequest.includesPropertyValues = false
        
        do {
            let items = try viewContext.fetch(fetchRequest) as! [NSManagedObject]
            for item in items {
                viewContext.delete(item)
            }
            try viewContext.save()
        } catch {
            
        }
    }
    
    private func resetDefaults() {
        let defaults = UserDefaults.data
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    private func killApp() {
        // home button pressed programmatically - to thorw app to background
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        // terminaing app in background
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            exit(EXIT_SUCCESS)
        })
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
