//
//  WithSubtitleTableViewCell.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 5/5/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit

class WithSubtitleTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_subtitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
