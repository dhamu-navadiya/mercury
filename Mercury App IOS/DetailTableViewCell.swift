//
//  DetailTableViewCell.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 5/27/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell,UITextFieldDelegate {

    var btn_menu = UIButton()
    var btn_camera = UIButton()
    var btn_add_fields = UIButton()
    var txt_description = UITextView()
    //var arrayOfTitleText:[UITextField] = []
     var arrayOfTitleText:[[UITextField]] = []
    var arrayOfDetailText:[UITextField] = []
    var btnContainer = UIView()
    var btnReset = UIButton()
    var btnSave = UIButton()
    var arrayOfAddFieldBtn:[UIButton] = []
    var add_field_view = UIView()
    var title_dtls_view = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setOrderViewLayout(itemCount: String, prevImage: UIImage, desc: String, titleArray: [String], detailArray: [String], orderSubIdArray: String, counter: Int) {
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
        lbl_item_no.text = String(itemCount) + " item"
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
        title_dtls_view = VerticalLayout(xoff: 0, yoff: 4, width: vLayout.frame.width, height: 0)
        vLayout.addSubview(title_dtls_view)
        
        for j in 0 ..< titleArray.count {
             let tag = (10 * counter ) + j
            title_dtls_view.addSubview(addTitleDetaiFields(xOff: 0, yOff: 0, width: title_dtls_view.frame.width, height: 0, titleText: titleArray[j], detailText: detailArray[j], cnt: counter,isEdit:false,rownumber:tag))
        }
        
        /* Add Field Button View Start */
        add_field_view = VerticalLayout(xoff: 0, yoff: 0, width: vLayout.frame.width, height: 0)
        
        vLayout.addSubview(add_field_view)
        
         btn_add_fields = UIButton(frame: CGRect(x: 8, y: 0, width: add_field_view.frame.width-16, height: 30))
        btn_add_fields.setTitle("...+ Add fields", for: .normal)
        btn_add_fields.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 10)
        let myColor : UIColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        btn_add_fields.setTitleColor(myColor, for: .normal)
        btn_add_fields.contentHorizontalAlignment = .left
       // btn_add_fields.tag = arrayOfAddFieldBtn.count
       // btn_add_fields.addTarget(self, action: #selector(addFieldAction), for: .touchUpInside)
        arrayOfAddFieldBtn.append(btn_add_fields)
        add_field_view.addSubview(btn_add_fields)
        
        add_field_view.isHidden = true
        
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
        
        btnContainer = VerticalLayout(xoff: 0, yoff: 0, width: vLayout.frame.width, height: 0)
        vLayout.addSubview(btnContainer)
        
        let hbtnContainer = HorizontalLayout(xoff: 8, yoff: 0, width: btnContainer.frame.width-20, height: 38)
        btnContainer.addSubview(hbtnContainer)
        
        let vResetContainer = UIView(frame: CGRect(x: 0, y: 0, width: hbtnContainer.frame.width*0.5, height: 38))
        hbtnContainer.addSubview(vResetContainer)
        
        btnReset = UIButton(frame: CGRect(x: 0, y: 0, width: vResetContainer.frame.width, height: 30))
        btnReset.setTitle("CANCEL", for: .normal)
        btnReset.backgroundColor = UIColor(red: 0.86, green: 0.85, blue: 0.85, alpha: 1.0)
        btnReset.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1.0), for: .normal)
        //btnReset.addTarget(self, action: #selector(resetOrderForm), for: .touchUpInside)
        vResetContainer.addSubview(btnReset)
        
        let vSaveContainer = UIView(frame: CGRect(x: 4, y: 0, width: hbtnContainer.frame.width*0.5, height: 38))
        hbtnContainer.addSubview(vSaveContainer)
        
        btnSave = UIButton(frame: CGRect(x: 0, y: 0, width: vSaveContainer.frame.width, height: 30))
        btnSave.setTitle("SAVE", for: .normal)
        btnSave.backgroundColor = UIColor(red: 0.86, green: 0.85, blue: 0.85, alpha: 1.0)
        btnSave.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1.0), for: .normal)
        //btnSave.addTarget(self, action: #selector(saveOrderDetails), for: .touchUpInside)
        vSaveContainer.addSubview(btnSave)
        
        btnContainer.isHidden = true
    }
    
    func setOrderViewLayout_reset(itemCount: String, prevImage: UIImage, desc: String, titleArray: [String], detailArray: [String], orderSubIdArray: String, counter: Int) {
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
        lbl_item_no.text = String(itemCount) + " item"
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
        title_dtls_view = VerticalLayout(xoff: 0, yoff: 4, width: vLayout.frame.width, height: 0)
        vLayout.addSubview(title_dtls_view)
        
        for j in 0 ..< titleArray.count {
            let tag = (10 * (counter + 1)) + j
            title_dtls_view.addSubview(addTitleDetaiFields(xOff: 0, yOff: 0, width: title_dtls_view.frame.width, height: 0, titleText: titleArray[j], detailText: detailArray[j], cnt: counter,isEdit:false,rownumber:tag))
        }
        
        /* Add Field Button View Start */
        add_field_view = VerticalLayout(xoff: 0, yoff: 0, width: vLayout.frame.width, height: 0)
        
        vLayout.addSubview(add_field_view)
        
        btn_add_fields = UIButton(frame: CGRect(x: 8, y: 0, width: add_field_view.frame.width-16, height: 30))
        btn_add_fields.setTitle("...+ Add fields", for: .normal)
        btn_add_fields.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 10)
        let myColor : UIColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        btn_add_fields.setTitleColor(myColor, for: .normal)
        btn_add_fields.contentHorizontalAlignment = .left
        // btn_add_fields.tag = arrayOfAddFieldBtn.count
        // btn_add_fields.addTarget(self, action: #selector(addFieldAction), for: .touchUpInside)
        arrayOfAddFieldBtn.append(btn_add_fields)
        add_field_view.addSubview(btn_add_fields)
        
        add_field_view.isHidden = true
        
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
        
//        btnContainer = VerticalLayout(xoff: 0, yoff: 0, width: vLayout.frame.width, height: 0)
//        vLayout.addSubview(btnContainer)
//        
//        let hbtnContainer = HorizontalLayout(xoff: 8, yoff: 0, width: btnContainer.frame.width-20, height: 38)
//        btnContainer.addSubview(hbtnContainer)
//        
//        let vResetContainer = UIView(frame: CGRect(x: 0, y: 0, width: hbtnContainer.frame.width*0.5, height: 38))
//        hbtnContainer.addSubview(vResetContainer)
//        
//        btnReset = UIButton(frame: CGRect(x: 0, y: 0, width: vResetContainer.frame.width, height: 30))
//        btnReset.setTitle("CANCEL", for: .normal)
//        btnReset.backgroundColor = UIColor(red: 0.86, green: 0.85, blue: 0.85, alpha: 1.0)
//        btnReset.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1.0), for: .normal)
//        //btnReset.addTarget(self, action: #selector(resetOrderForm), for: .touchUpInside)
//        vResetContainer.addSubview(btnReset)
//        
//        let vSaveContainer = UIView(frame: CGRect(x: 4, y: 0, width: hbtnContainer.frame.width*0.5, height: 38))
//        hbtnContainer.addSubview(vSaveContainer)
//        
//        btnSave = UIButton(frame: CGRect(x: 0, y: 0, width: vSaveContainer.frame.width, height: 30))
//        btnSave.setTitle("SAVE", for: .normal)
//        btnSave.backgroundColor = UIColor(red: 0.86, green: 0.85, blue: 0.85, alpha: 1.0)
//        btnSave.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1.0), for: .normal)
//        //btnSave.addTarget(self, action: #selector(saveOrderDetails), for: .touchUpInside)
//        vSaveContainer.addSubview(btnSave)
//        
//        btnContainer.isHidden = true
    }

    
    func setOrderViewLayout_add_fiels(itemCount: String, prevImage: UIImage, desc: String, titleArray: [String], detailArray: [String], orderSubIdArray: String, counter: Int) {
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
        lbl_item_no.text = String(itemCount) + " item"
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
        title_dtls_view = VerticalLayout(xoff: 0, yoff: 4, width: vLayout.frame.width, height: 0)
        vLayout.addSubview(title_dtls_view)
        
        for j in 0 ..< titleArray.count {
            let tag = 10 * counter + j
            
            title_dtls_view.addSubview(addTitleDetaiFields(xOff: 0, yOff: 0, width: title_dtls_view.frame.width, height: 0, titleText: titleArray[j], detailText: detailArray[j], cnt: counter,isEdit:true,rownumber:tag))
        }
        //title_dtls_view.addSubview(addTitleDetaiFields(xOff: 0, yOff: 0, width: title_dtls_view.frame.width, height: 0, titleText: "", detailText: "", cnt: counter + 1))
        
        /* Add Field Button View Start */
        add_field_view = VerticalLayout(xoff: 0, yoff: 0, width: vLayout.frame.width, height: 0)
        vLayout.addSubview(add_field_view)
        
        btn_add_fields = UIButton(frame: CGRect(x: 8, y: 0, width: add_field_view.frame.width-16, height: 30))
        btn_add_fields.setTitle("...+ Add fields", for: .normal)
        btn_add_fields.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 10)
        let myColor : UIColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        btn_add_fields.setTitleColor(myColor, for: .normal)
        btn_add_fields.contentHorizontalAlignment = .left
        btn_add_fields.tag = arrayOfAddFieldBtn.count
         //btn_add_fields.addTarget(self, action: #selector(MyOrderDetailsViewController.btn_add_field_click), for: .touchUpInside)
        arrayOfAddFieldBtn.append(btn_add_fields)
        add_field_view.addSubview(btn_add_fields)
        
        add_field_view.isHidden = false
        
        /* Description View Start */
        let vViewDescription = VerticalLayout(xoff: 0, yoff: 0, width: vLayout.frame.width, height: 0)
        vLayout.addSubview(vViewDescription)
        
        txt_description = UITextView(frame: CGRect(x: 4, y: 0, width: vViewDescription.frame.width - 8, height: 30))
        let borderColor : UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        txt_description.layer.borderColor = borderColor.cgColor
        txt_description.layer.borderWidth = 1.0
        txt_description.layer.cornerRadius = 5.0
        txt_description.text = desc
        txt_description.isEditable = true
        txt_description.backgroundColor = UIColor.white
        vViewDescription.addSubview(txt_description)
        
        btnContainer = VerticalLayout(xoff: 0, yoff: 0, width: vLayout.frame.width, height: 0)
        vLayout.addSubview(btnContainer)
        
        let hbtnContainer = HorizontalLayout(xoff: 8, yoff: 0, width: btnContainer.frame.width-20, height: 38)
        btnContainer.addSubview(hbtnContainer)
        
        let vResetContainer = UIView(frame: CGRect(x: 0, y: 0, width: hbtnContainer.frame.width*0.5, height: 38))
        hbtnContainer.addSubview(vResetContainer)
        
        btnReset = UIButton(frame: CGRect(x: 0, y: 0, width: vResetContainer.frame.width, height: 30))
        btnReset.setTitle("CANCEL", for: .normal)
        btnReset.backgroundColor = UIColor(red: 0.86, green: 0.85, blue: 0.85, alpha: 1.0)
        btnReset.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1.0), for: .normal)
        btnReset.tag = counter
        //btnReset.addTarget(self, action: #selector(resetOrderForm), for: .touchUpInside)
        vResetContainer.addSubview(btnReset)
        
        let vSaveContainer = UIView(frame: CGRect(x: 4, y: 0, width: hbtnContainer.frame.width*0.5, height: 38))
        hbtnContainer.addSubview(vSaveContainer)
        
        btnSave = UIButton(frame: CGRect(x: 0, y: 0, width: vSaveContainer.frame.width, height: 30))
        btnSave.setTitle("SAVE", for: .normal)
        btnSave.backgroundColor = UIColor(red: 0.86, green: 0.85, blue: 0.85, alpha: 1.0)
        btnSave.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1.0), for: .normal)
        //btnSave.addTarget(self, action: #selector(saveOrderDetails), for: .touchUpInside)
        vSaveContainer.addSubview(btnSave)
        btnContainer.isHidden = false
    }

    
    func addTitleDetaiFields(xOff: CGFloat, yOff: CGFloat, width: CGFloat, height: CGFloat, titleText: String, detailText: String, cnt: Int,isEdit:Bool,rownumber:Int)->UIView {
        let vTitleDtlContainer = VerticalLayout(xoff: xOff, yoff: yOff, width: width, height: height)
        
        let rowTitleDetail_view = HorizontalLayout(xoff: 0, yoff: 0, width: 0, height: 40)
        vTitleDtlContainer.addSubview(rowTitleDetail_view)
        
        let txtTitle = UITextField(frame: CGRect(x: 4, y: 0, width: vTitleDtlContainer.frame.width*0.4, height: 30))
        if titleText == "Title"
        {
            txtTitle.placeholder = "Title"
        }
        else
        {
          txtTitle.text = titleText
        }
        
        txtTitle.borderStyle = UITextBorderStyle.roundedRect
        txtTitle.backgroundColor = UIColor.white
        txtTitle.isEnabled = isEdit
        txtTitle.isUserInteractionEnabled = isEdit
        txtTitle.tag = rownumber
        txtTitle.delegate = self
        rowTitleDetail_view.addSubview(txtTitle)
        
        let txtDetail = UITextField(frame: CGRect(x: 4, y: 0, width: vTitleDtlContainer.frame.width*0.57, height: 30))
        
        if detailText == "Details"
        {
            txtDetail.placeholder = "Details"
        }
        else
        {
            txtDetail.text = detailText
        }
        
        
        txtDetail.borderStyle = UITextBorderStyle.roundedRect
        txtDetail.backgroundColor = UIColor.white
        txtDetail.isUserInteractionEnabled = isEdit
        txtDetail.isEnabled = isEdit
        txtDetail.delegate = self
        txtDetail.tag = rownumber + 500
        
        arrayOfDetailText.append(txtDetail)
        rowTitleDetail_view.addSubview(txtDetail)
        return vTitleDtlContainer
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        let dic = ["tag":textField.tag,"text":textField.text!] as [String : Any]
        
        NotificationCenter.default.post(name: Notification.Name("editDataset"), object: dic)
       
    }
}
