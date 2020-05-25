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

    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var moodLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
