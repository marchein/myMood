//
//  MoodTableViewCell.swift
//  myMood
//
//  Created by Marc Hein on 25.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit

class MoodTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "MoodTableCell"
    
    // MARK: -
    var mood: Mood? {
        didSet {
            self.moodLabel.text = mood?.mood
            
            guard let description = mood?.desc, description.count > 0 else {
                self.descriptionLabel.isHidden = true
                return
            }
            
            self.descriptionLabel.text = description
            self.descriptionLabel.isHidden = false
        }
    }
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var moodLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func toggleDescription() {
        self.descriptionLabel.isHidden = !self.descriptionLabel.isHidden
    }
}
