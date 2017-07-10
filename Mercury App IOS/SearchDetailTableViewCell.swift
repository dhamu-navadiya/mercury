//
//  SearchDetailTableViewCell.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 5/29/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit

class SearchDetailTableViewCell: UITableViewCell {

    var btn_menu = UIButton()
    var btn_camera = UIButton()
    var txt_description = UITextView()
    var arrayOfTitleText:[UITextField] = []
    var arrayOfDetailText:[UITextField] = []
    var btnContainer = UIView()
    var btnReset = UIButton()
    var btnSave = UIButton()
    var arrayOfAddFieldBtn:[UIButton] = []
    var add_field_view = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setOrderViewLayout(itemCount: String, prevImage: UIImage, desc: String, titleArray: [String], detailArray: [String], orderSubIdArray: String, counter: Int, txt_manufacturer: String, txt_mobile: String, txt_email: String, orderDate: String, deliveryDate: String) {
        let vLayout = VerticalLayout(xoff: 8, yoff: 0, width: bounds.width-16, height: 0)
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
        lbl_item_no.text = itemCount + " item"
        vlbl_view.addSubview(lbl_item_no)
        
        btn_menu = UIButton(frame: CGRect(x: vBtn_view.frame.width-25, y: 4, width: 25, height: 25))
        btn_menu.setBackgroundImage(#imageLiteral(resourceName: "menu"), for: .normal)
        btn_menu.accessibilityIdentifier = orderSubIdArray
        btn_menu.tag = counter
        vBtn_view.addSubview(btn_menu)
        
        /* Image View Start */
        let img_view = VerticalLayout(xoff: 0, yoff: 4, width: vLayout.frame.width, height: 0)
        vLayout.addSubview(img_view)
        
        btn_camera = UIButton(frame: CGRect(x: (img_view.frame.width * 0.5) - 65, y: 4, width: 110, height: 110))
        btn_camera.setBackgroundImage(#imageLiteral(resourceName: "new_camera_edit"), for: .normal)
        
        btn_camera.isUserInteractionEnabled = true
        btn_camera.setBackgroundImage(prevImage, for: .normal)
        
        img_view.addSubview(btn_camera)
        
        /* Title detail View Start */
        let title_dtls_view = VerticalLayout(xoff: 0, yoff: 4, width: vLayout.frame.width, height: 0)
        vLayout.addSubview(title_dtls_view)
        
        for j in 0 ..< titleArray.count {
            title_dtls_view.addSubview(addTitleDetaiFields(xOff: 0, yOff: 0, width: title_dtls_view.frame.width, height: 0, titleText: titleArray[j], detailText: detailArray[j], cnt: counter))
        }
        
        /* Description View Start */
        let vViewDescription = VerticalLayout(xoff: 0, yoff: 0, width: vLayout.frame.width, height: 0)
        vLayout.addSubview(vViewDescription)
        
        txt_description = UITextView(frame: CGRect(x: 4, y: 0, width: vViewDescription.frame.width - 8, height: 30))
        let borderColor : UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        txt_description.layer.borderColor = borderColor.cgColor
        txt_description.layer.borderWidth = 1.0
        txt_description.layer.cornerRadius = 5.0
        txt_description.text = desc
        txt_description.isEditable = false
        txt_description.backgroundColor = UIColor.white
        vViewDescription.addSubview(txt_description)
        
        if txt_manufacturer != "" {
            let manufacturer_lbl = UILabel(frame: CGRect(x: 4, y: 0, width: vLayout.frame.width - 8, height: 30))
            manufacturer_lbl.text = "Manufacturer Details"
            manufacturer_lbl.textAlignment = .center
            vLayout.addSubview(manufacturer_lbl)
            
            let vContactLayerView = VerticalLayout(xoff: 0, yoff: 0, width: vLayout.frame.width, height: 0)
            vLayout.addSubview(vContactLayerView)
            
            let rowTitleDetail_view = HorizontalLayout(xoff: 0, yoff: 0, width: 0, height: 30)
            vContactLayerView.addSubview(rowTitleDetail_view)
            
            let txtManufacturer = UITextField(frame: CGRect(x: 4, y: 0, width: vContactLayerView.frame.width*0.48, height: 30))
            txtManufacturer.text = txt_manufacturer
            txtManufacturer.borderStyle = UITextBorderStyle.roundedRect
            txtManufacturer.backgroundColor = UIColor.white
            txtManufacturer.isEnabled = false
            txtManufacturer.isUserInteractionEnabled = false
            rowTitleDetail_view.addSubview(txtManufacturer)
            
            let rowCntDetailsView = UIView(frame: CGRect(x: 4, y: 0, width: vContactLayerView.frame.width*0.48, height: 30))
            rowCntDetailsView.layer.borderColor = borderColor.cgColor
            rowCntDetailsView.backgroundColor = UIColor.white
            rowCntDetailsView.layer.borderWidth = 1.0
            rowCntDetailsView.layer.cornerRadius = 5.0
            rowTitleDetail_view.addSubview(rowCntDetailsView)
            
            let rowMobile = HorizontalLayout(xoff: 0, yoff: 0, width: 0, height: 30)
            rowCntDetailsView.addSubview(rowMobile)
            
            let btn_mobile = UIButton(frame: CGRect(x: 8, y: 4, width: 24, height: 24))
            btn_mobile.setBackgroundImage(#imageLiteral(resourceName: "call"), for: .normal)
            btn_mobile.accessibilityIdentifier = txt_mobile
            rowMobile.addSubview(btn_mobile)
            
            let rowSMS = HorizontalLayout(xoff: 0, yoff: 0, width: 0, height: 30)
            rowCntDetailsView.addSubview(rowSMS)
            
            let btn_sms = UIButton(frame: CGRect(x: 20, y: 4, width: 32, height: 24))
            btn_sms.setBackgroundImage(#imageLiteral(resourceName: "sms"), for: .normal)
            btn_sms.accessibilityIdentifier = txt_mobile
            rowMobile.addSubview(btn_sms)
            
            let rowMail = HorizontalLayout(xoff: 0, yoff: 0, width: 0, height: 30)
            rowCntDetailsView.addSubview(rowMail)
            
            let btn_mail = UIButton(frame: CGRect(x: 20, y: 4, width: 32, height: 24))
            btn_mail.setBackgroundImage(#imageLiteral(resourceName: "mail"), for: .normal)
            btn_mail.accessibilityIdentifier = txt_mobile
            rowMobile.addSubview(btn_mail)
            
            /* Date View Start */
            let vDateContainer = VerticalLayout(xoff: 0, yoff: 0, width: vLayout.frame.width, height: 0)
            vLayout.addSubview(vDateContainer)
            
            let hDateViewContainer = HorizontalLayout(xoff: 8, yoff: 0, width: vDateContainer.frame.width-20, height: 64)
            vDateContainer.addSubview(hDateViewContainer)
            
            let dateViewColor : UIColor = UIColor.white
            
            let vOrderDateView = VerticalLayout(xoff: 0, yoff: 0, width: hDateViewContainer.frame.width*0.5, height: 0)
            vOrderDateView.backgroundColor = dateViewColor
            hDateViewContainer.addSubview(vOrderDateView)
            
            let btn_order_date = UITextField(frame: CGRect(x: 4, y: 4, width: vOrderDateView.frame.width-8, height: 30))
            btn_order_date.text = "ORDER DATE"
            btn_order_date.textAlignment = .center
            btn_order_date.backgroundColor = UIColor(red: 0.86, green: 0.85, blue: 0.85, alpha: 1.0)
            btn_order_date.tintColor = UIColor.clear
            btn_order_date.resignFirstResponder()
            vOrderDateView.addSubview(btn_order_date)
            
            let lbl_order_date = UITextField(frame: CGRect(x: 4, y: 4, width: vOrderDateView.frame.width-8, height: 30))
            lbl_order_date.textAlignment = .center
            lbl_order_date.tintColor = UIColor.clear
            lbl_order_date.resignFirstResponder()
            lbl_order_date.text = orderDate
            vOrderDateView.addSubview(lbl_order_date)
            
            let vDeliveryDateView = VerticalLayout(xoff: 4, yoff: 0, width: hDateViewContainer.frame.width*0.5, height: 0)
            vDeliveryDateView.backgroundColor = dateViewColor
            hDateViewContainer.addSubview(vDeliveryDateView)
            
            let btn_delivery_date = UITextField(frame: CGRect(x: 4, y: 4, width: vDeliveryDateView.frame.width-8, height: 30))
            btn_delivery_date.text = "DELIVERY DATE"
            btn_delivery_date.textAlignment = .center
            btn_delivery_date.backgroundColor = UIColor(red: 0.86, green: 0.85, blue: 0.85, alpha: 1.0)
            btn_delivery_date.tintColor = UIColor.clear
            btn_delivery_date.resignFirstResponder()
            vDeliveryDateView.addSubview(btn_delivery_date)
            
            let lbl_delivery_date = UITextField(frame: CGRect(x: 4, y: 4, width: vDeliveryDateView.frame.width-8, height: 30))
            lbl_delivery_date.textAlignment = .center
            //lbl_delivery_date.backgroundColor = UIColor(red: 0.86, green: 0.85, blue: 0.85, alpha: 1.0)
            lbl_delivery_date.tintColor = UIColor.clear
            lbl_delivery_date.resignFirstResponder()
            lbl_delivery_date.text = deliveryDate
            vDeliveryDateView.addSubview(lbl_delivery_date)
            
            let lbl_info = UILabel(frame: CGRect(x: 0, y: 0, width: vLayout.frame.width, height: 30))
            lbl_info.text = "Waiting for response..."
            vLayout.addSubview(lbl_info)
        }
    }
    
    func addTitleDetaiFields(xOff: CGFloat, yOff: CGFloat, width: CGFloat, height: CGFloat, titleText: String, detailText: String, cnt: Int)->UIView {
        let vTitleDtlContainer = VerticalLayout(xoff: xOff, yoff: yOff, width: width, height: height)
        
        let rowTitleDetail_view = HorizontalLayout(xoff: 0, yoff: 0, width: 0, height: 40)
        vTitleDtlContainer.addSubview(rowTitleDetail_view)
        
        let txtTitle = UITextField(frame: CGRect(x: 4, y: 0, width: vTitleDtlContainer.frame.width*0.4, height: 30))
        txtTitle.text = titleText
        txtTitle.borderStyle = UITextBorderStyle.roundedRect
        txtTitle.backgroundColor = UIColor.white
        txtTitle.isEnabled = false
        txtTitle.isUserInteractionEnabled = false
        arrayOfTitleText.append(txtTitle)
        rowTitleDetail_view.addSubview(txtTitle)
        
        let txtDetail = UITextField(frame: CGRect(x: 4, y: 0, width: vTitleDtlContainer.frame.width*0.57, height: 30))
        txtDetail.text = detailText
        txtDetail.borderStyle = UITextBorderStyle.roundedRect
        txtDetail.backgroundColor = UIColor.white
        txtDetail.isUserInteractionEnabled = false
        arrayOfDetailText.append(txtDetail)
        rowTitleDetail_view.addSubview(txtDetail)
        return vTitleDtlContainer
    }
}
