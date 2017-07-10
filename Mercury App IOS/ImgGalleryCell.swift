//
//  ImgGalleryCell.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 4/24/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit

class ImgGalleryCell: UITableViewCell {
    @IBOutlet weak var img_gall_img: UIImageView!
    @IBOutlet weak var lbl_img_gall: UILabel!
    @IBOutlet weak var btn_check: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
