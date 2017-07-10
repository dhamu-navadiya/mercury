//
//  SettingReceiptCell.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 4/24/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit

class SettingReceiptCell: UITableViewCell {
    @IBOutlet weak var img_setting_receipt: UIImageView!
    @IBOutlet weak var lbl_receipt_title: UILabel!
    @IBOutlet weak var lbl_receipt_subtitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
