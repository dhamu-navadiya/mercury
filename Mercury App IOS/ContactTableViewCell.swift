//
//  ContactTableViewCell.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 5/24/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    @IBOutlet weak var txt_receipt: UITextField!
    @IBOutlet weak var txt_order_date: UITextField!
    @IBOutlet weak var txt_delivery_date: UITextField!
    @IBOutlet weak var txt_customer: UITextField!
    @IBOutlet weak var view_contactC: UIView!
    @IBOutlet weak var btn_call: UIButton!
    @IBOutlet weak var btn_sms: UIButton!
    @IBOutlet weak var btn_mail: UIButton!
    @IBOutlet weak var txt_comment: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initialiseData(receipt: String, orderDate: String, deliveryDate: String, customer: String, mobile: String, email: String, comment: String) {
        txt_receipt.text = receipt
        txt_order_date.text = orderDate
        txt_delivery_date.text = deliveryDate
        txt_customer.text = customer
        btn_call.accessibilityIdentifier = mobile
        btn_sms.accessibilityIdentifier = mobile
        btn_mail.accessibilityIdentifier = email
        txt_comment.text = comment
    }
}
