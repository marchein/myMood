//
//  PieChartTableViewCell.swift
//  myMood
//
//  Created by Marc Hein on 14.05.21.
//  Copyright © 2021 Marc Hein. All rights reserved.
//

import UIKit
import Charts

class PieChartTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "PieChartTableCell"

    @IBOutlet weak var pieChart: PieChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
