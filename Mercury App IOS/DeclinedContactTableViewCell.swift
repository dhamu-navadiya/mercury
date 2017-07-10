//
//  DeclinedContactTableViewCell.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 5/28/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit

class DeclinedContactTableViewCell: UITableViewCell {
    @IBOutlet weak var txt_receipt: UITextField!
    @IBOutlet weak var txt_order_date: UILabel!
    @IBOutlet weak var txt_delivery_date: UILabel!
    @IBOutlet weak var txt_customer: UITextField!
    @IBOutlet weak var btn_call: UIButton!
    @IBOutlet weak var btn_sms: UIButton!
    @IBOutlet weak var btn_mail: UIButton!
    @IBOutlet weak var txt_comment: UITextView!
    @IBOutlet weak var view_contactC: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initialiseData(receipt: String, orderDate: String, deliveryDate: String, customer: String, mobile: String, email: String, comment: String) {
        txt_receipt.text = "Receipt No: " + receipt
        txt_order_date.text = orderDate
        txt_delivery_date.text = deliveryDate
        txt_customer.text = customer
        btn_call.accessibilityIdentifier = mobile
        btn_sms.accessibilityIdentifier = mobile
        btn_mail.accessibilityIdentifier = email
        txt_comment.text = comment
    }
}
