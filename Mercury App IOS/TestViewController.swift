//
//  TestViewController.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 4/21/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    
    func setLayout() {
        let txt_receipt = UITextField(frame: CGRect(x: 8, y: 8, width: view.frame.width - 20, height: 30))
        txt_receipt.placeholder = "Receipt No"
        view.viewWithTag(1)?.addSubview(txt_receipt)
    }
}
