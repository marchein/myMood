//
//  MainViewController+TableView.swift
//  myMood
//
//  Created by Marc Hein on 27.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit

extension MainViewController {
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Wie geht es Dir gerade?"
        case 1:
            return "Letzter Eintrag"
        case 2:
            return "Statistiken"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let moodSelectionCell = self.tableView.dequeueReusableCell(withIdentifier: MoodSelectionTableViewCell.reuseIdentifier) as? MoodSelectionTableViewCell else {
                return UITableViewCell()
            }
            self.loadEmojis(for: moodSelectionCell)
            return moodSelectionCell
        case 1:
            guard let latestMoodCell = self.tableView.dequeueReusableCell(withIdentifier: MoodTableViewCell.reuseIdentifier) as? MoodTableViewCell else {
                return UITableViewCell()
            }
            guard let fetchedMood = Model.getLastEntry() else {
                return UITableViewCell()
            }
            latestMoodCell.mood = fetchedMood
            latestMoodCell.timeLabel.text = "\(fetchedMood.isoDate) um \(fetchedMood.isoTime) Uhr"
            guard let _ = fetchedMood.desc else {
                latestMoodCell.descriptionLabel.text = "Keine Beschreibung vorhanden"
                latestMoodCell.toggleDescription()
                return latestMoodCell
            }
            return latestMoodCell
        case 2:
            let cell = UITableViewCell()
            cell.textLabel?.text = "Hier erscheinen demnächst Statistiken"
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
