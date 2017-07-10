//
//  MyOrderTableViewCell.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 4/8/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_initial: UILabel!
    @IBOutlet weak var lbl_receipt: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_customer: UILabel!
    @IBOutlet weak var btn_new: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initCellData(_ initialLbl: Character, receiptLbl: String, dateLbl: String, customerLbl: String, btnData: String) {
        
        lbl_initial.text = "\(initialLbl)"
        lbl_receipt.text = receiptLbl
        lbl_date.text = dateLbl
        lbl_customer.text = customerLbl
        btn_new.text = btnData
    }
}
