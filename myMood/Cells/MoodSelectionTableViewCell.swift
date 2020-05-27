//
//  MoodSelectionTableViewCell.swift
//  myMood
//
//  Created by Marc Hein on 27.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit

class MoodSelectionTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "moodSelectionCell"
    
    @IBOutlet weak var emojiStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
