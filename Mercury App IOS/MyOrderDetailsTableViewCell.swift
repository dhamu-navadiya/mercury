//
//  MyOrderDetailsTableViewCell.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 4/8/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit

class MyOrderDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var img_prdImageView: UIImageView!
    @IBOutlet weak var txt_title_1: UITextField!
    @IBOutlet weak var txt_title_2: UITextField!
    @IBOutlet weak var txt_title_3: UITextField!
    @IBOutlet weak var txt_title_4: UITextField!
    @IBOutlet weak var txt_detail_1: UITextField!
    @IBOutlet weak var txt_detail_2: UITextField!
    @IBOutlet weak var txt_detail_3: UITextField!
    @IBOutlet weak var txt_detail_4: UITextField!
    @IBOutlet weak var txt_description_txt: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
 
    func initCellDtlsData(_ imgName: String, title_1: String, title_2: String, title_3: String, title_4: String, detail_1: String, detail_2: String, detail_3: String, detail_4: String, desc_txt: String) {
        img_prdImageView.image = UIImage(named: imgName)
        txt_title_1.text = title_1
        txt_title_2.text = title_2
        txt_title_3.text = title_3
        txt_title_4.text = title_4
        txt_detail_1.text = detail_1
        txt_detail_2.text = detail_2
        txt_detail_3.text = detail_3
        txt_detail_4.text = detail_4
        txt_description_txt.text = desc_txt
    }
    
}
