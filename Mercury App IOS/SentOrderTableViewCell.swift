//
//  SentOrderTableViewCell.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 4/11/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit

class SentOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_initial: UILabel!
    @IBOutlet weak var lbl_receipt: UILabel!
    @IBOutlet weak var lbl_customer: UILabel!
    @IBOutlet weak var lbl_date: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initCellData(_ initialLbl: Character, receiptLbl: String, dateLbl: String, customerLbl: String) {
        
        lbl_initial.text = "\(initialLbl)"
        lbl_receipt.text = receiptLbl
        lbl_date.text = dateLbl
        lbl_customer.text = customerLbl
    }
}
