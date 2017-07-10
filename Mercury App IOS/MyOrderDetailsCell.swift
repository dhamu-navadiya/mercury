//
//  MyOrderDetailsCell.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 4/10/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit

class MyOrderDetailsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setOrderViewLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setOrderViewLayout() {
        let vLayout = VerticalLayout(xoff: 8, yoff: 8, width: bounds.width, height: 0)
        let mainViewColor : UIColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
        vLayout.backgroundColor = mainViewColor
        addSubview(vLayout)
        
        /* Header View Start */
        let vheader_view = VerticalLayout(xoff: 0, yoff: 8, width: vLayout.frame.width, height: 0)
        vLayout.addSubview(vheader_view)
        
        let hheader_view = HorizontalLayout(xoff: 0, yoff: 0, width: 0, height: 25)
        vheader_view.addSubview(hheader_view)
        
        let vlbl_view = VerticalLayout(xoff: 0, yoff: 0, width: vheader_view.frame.width*0.5, height: 25)
        hheader_view.addSubview(vlbl_view)
        
        let vBtn_view = VerticalLayout(xoff: 0, yoff: 0, width: vheader_view.frame.width*0.5, height: 25)
        hheader_view.addSubview(vBtn_view)
        
        let lbl_item_no = UILabel(frame: CGRect(x: 8, y:4, width: vlbl_view.frame.width-16, height: 25))
        lbl_item_no.textColor = UIColor.black
        lbl_item_no.textAlignment = .left
        lbl_item_no.text = "1. item"
        vlbl_view.addSubview(lbl_item_no)
        
        let btn_menu = UIButton(frame: CGRect(x: vBtn_view.frame.width-25, y: 4, width: 25, height: 25))
        btn_menu.setBackgroundImage(#imageLiteral(resourceName: "menu"), for: .normal)
        vBtn_view.addSubview(btn_menu)
        
        /* Image View Start */
        let img_view = VerticalLayout(xoff: 0, yoff: 4, width: vLayout.frame.width, height: 0)
        vLayout.addSubview(img_view)
        
        let btn_camera = UIButton(frame: CGRect(x: (img_view.frame.width * 0.5) - 65, y: 4, width: 110, height: 110))
        btn_camera.setBackgroundImage(#imageLiteral(resourceName: "new_camera_edit"), for: .normal)
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        btn_camera.isUserInteractionEnabled = true
        //btn_camera.addGestureRecognizer(tapGestureRecognizer)
        img_view.addSubview(btn_camera)
        
        /* Title detail View Start */
        let title_dtls_view = VerticalLayout(xoff: 0, yoff: 4, width: vLayout.frame.width, height: 0)
        vLayout.addSubview(title_dtls_view)
        
//        for _ in 0 ..< 3 {
//            title_dtls_view.addSubview(addTitleDetaiFields(xOff: 0, yOff: 0, width: title_dtls_view.frame.width, height: 0))
//        }
        
        /* Add Field Button View Start */
        let add_field_view = VerticalLayout(xoff: 0, yoff: 0, width: vLayout.frame.width, height: 0)
        vLayout.addSubview(add_field_view)
        
        /* Description View Start */
        let vViewDescription = VerticalLayout(xoff: 0, yoff: 0, width: vLayout.frame.width, height: 0)
        vLayout.addSubview(vViewDescription)
        
        let txt_description = UITextView(frame: CGRect(x: 4, y: 0, width: vViewDescription.frame.width - 8, height: 30))
        let borderColor : UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        txt_description.layer.borderColor = borderColor.cgColor
        txt_description.layer.borderWidth = 1.0
        txt_description.layer.cornerRadius = 5.0
        txt_description.backgroundColor = UIColor.white
        vViewDescription.addSubview(txt_description)
    }
    
}
