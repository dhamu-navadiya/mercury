//
//  DeclinedTableViewCell.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 5/23/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit

class DeclinedTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_init: UILabel!
    @IBOutlet weak var lbl_receipt: UILabel!
    @IBOutlet weak var lbl_customer: UILabel!
    @IBOutlet weak var lbl_date: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initCellData(_ initialLbl: Character, receiptLbl: String, dateLbl: String, customerLbl: String) {
        
        lbl_init.text = "\(initialLbl)"
        lbl_receipt.text = receiptLbl
        lbl_date.text = dateLbl
        lbl_customer.text = customerLbl
    }
}
