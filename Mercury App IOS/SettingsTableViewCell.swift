//
//  SettingsTableViewCell.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 4/12/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var img_icon: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initSettingsData(_ img_ico: String, title: String) {
        img_icon.image = UIImage(named: img_ico)
        lbl_title.text = title
    }
}
