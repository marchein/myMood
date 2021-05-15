//
//  TipIntroTableViewCell.swift
//  myMood
//
//  Created by Marc Hein on 15.05.21.
//  Copyright © 2021 Marc Hein. All rights reserved.
//

import UIKit

class TipIntroTableViewCell: UITableViewCell {

    // MARK: - Properties
    static let reuseIdentifier = "TipIntroCell"
    
    @IBOutlet weak var introHeadline: UILabel!
    @IBOutlet weak var introText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        introHeadline?.text = "Heyho 😌"
        introText?.text = "Falls Dir myMood sehr gefällt, kannst Du hier mit einer Spende an den Entwickler die Entwicklung unterstützen.\nSelbst wenn Du das nicht möchtest, dennoch danke. Der Gedanke zählt!"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
