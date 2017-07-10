//
//  ReceiptPopupViewController.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 4/24/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit

class ReceiptPopupViewController: UIViewController {
    @IBAction func btn_cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func btn_ok(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
