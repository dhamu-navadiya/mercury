//
//  ViewController.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 4/6/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import CoreData
import AVFoundation

class NewOrderViewController: BaseViewController, CNContactPickerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    let mainLayout = IQKeyboardViewContainer(xoff: 0, yoff: 8, width: UIScreen.main.bounds.width, height: 0)
    let vOrderDetails = VerticalLayout(xoff: 0, yoff: 0, width: UIScreen.main.bounds.width, height: 0)
    
    var heightConstant:CGFloat = 0
    var remove_counter = 0
    
    var title_dtls_view = UIView()
    var sv = UIScrollView()
    
    let mobileChecked = UIImage(named: "checked")
    let mobileUnchecked = UIImage(named: "unchecked")
    let emailChecked = UIImage(named: "checked")
    let emailUnchecked = UIImage(named: "unchecked")
    let orderDatePicker = UIDatePicker()
    let deliveryDatePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var isMobileBoxClicked:Bool!
    var isEmailBoxClicked:Bool!
    
    var txt_receipt = UITextField()
    var txt_comment = UITextView()
    var txtCustomerName = UITextField()
    var txtMobile = UITextField()
    var txtEmail = UITextField()
    var btn_order_date = UITextField()
    var btn_delivery_date = UITextField()
    var lbl_order_date = UITextField()
    var lbl_delivery_date = UITextField()
    var btn_camera = UIButton()
    var btnMobile = UIButton()
    var btnEmail = UIButton()
    
    var arrayOfOrderDetailView:[UIView] = []
    var arrayOfViewLable:[UILabel] = []
    var arrayOfMenuBtn:[UIButton] = []
    var arrayOfCameraBtn:[UIButton] = []
    var arrayOfTitleText:[UITextField] = []
    var arrayOfDetailText:[UITextField] = []
    var arrayOfAddFieldBtn:[UIButton] = []
    var arrayOfDescription:[UITextView] = []
    var arrayOfTitleDetailsView:[UIView] = []
    var arrayOfImageObjects:[UIImage] = []
    
    var offSetVal = 0
    var orderId = ""
    var orderSubId = ""
    var orderCount = 0
    var orderDetailViewCounter = 1
    var activeField: UIView?
    
    let tintColor : UIColor = UIColor(red: 0.1, green: 0.5, blue: 0.9, alpha: 1.0)
    
    var objCaptureSession:AVCaptureSession?
    var objCaptureVideoPreviewLayer:AVCaptureVideoPreviewLayer?
    var vwQRCode:UIView?
    
    var tagCounter = 1;
    
    var created_date = Date()
    var customer_comment: String = ""
    var customer_delivered_date = Date()
    var customer_id: Int = 0
    var customer_issue_date = Date()
    var imageURL = UIImage()
    var isImageSync: Int = 0
    var isOrderSync: Int = 0
    var isReady: Int = 0
    var isReceived: Int = 0
    var order_comment: String = ""
    var order_id: String = ""
    var order_status: String = ""
    var order_sub_id: String = ""
    var reason: String = ""
    var userId: Int = 0
    var titleDtlsCounter = 0
    var title_count = 0
    var reset_count  = 0
    var isFormValidated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSlideMenuButton()
        
        
        sv = UIScrollView(frame: view.bounds)
        sv.addSubview(mainLayout)
        setMainViewLayout()
        mainLayout.addSubview(vOrderDetails)
        setOrderViewLayout()
        setFooterViewLayout()
        automaticallyAdjustsScrollViewInsets = true
        
        view.addSubview(sv)
        
        orderDatePicker.datePickerMode = .date
        deliveryDatePicker.datePickerMode = .date
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currDate = Date()
        created_date = currDate
        let strCurrDate = dateFormatter.string(from: currDate)
        lbl_order_date.text = strCurrDate
        
        orderDatePicker.maximumDate = Date()
        deliveryDatePicker.minimumDate = Date()
        
        createOrderDatePicker()
        createDeliveryDatePicker()
    }
    
    func configureVideoCapture()
    {
        let objCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var error:NSError?
        let objCaptureDeviceInput: AnyObject!
        do {
            objCaptureDeviceInput = try AVCaptureDeviceInput(device: objCaptureDevice) as AVCaptureDeviceInput
            
        } catch let error1 as NSError {
            error = error1
            objCaptureDeviceInput = nil
        }
        if (error != nil) {
            let alertView:UIAlertView = UIAlertView(title: "Device Error", message:"Device not Supported for this Application", delegate: nil, cancelButtonTitle: "Ok Done")
            alertView.show()
            return
        }
        objCaptureSession = AVCaptureSession()
        objCaptureSession?.addInput(objCaptureDeviceInput as! AVCaptureInput)
        let objCaptureMetadataOutput = AVCaptureMetadataOutput()
        objCaptureSession?.addOutput(objCaptureMetadataOutput)
        objCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        objCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
    }
    
    func addVideoPreviewLayer()
    {
        objCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: objCaptureSession)
        objCaptureVideoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        objCaptureVideoPreviewLayer?.frame = view.layer.bounds
        self.view.layer.addSublayer(objCaptureVideoPreviewLayer!)
        objCaptureSession?.startRunning()
    }
    
    func initializeQRView() {
        vwQRCode = UIView()
        vwQRCode?.layer.borderColor = UIColor.red.cgColor
        vwQRCode?.layer.borderWidth = 5
        self.view.addSubview(vwQRCode!)
        self.view.bringSubview(toFront: vwQRCode!)
        let btnCancel = UIButton()
        btnCancel.setTitle("Cancel", for: .normal)
        btnCancel.addTarget(self, action: #selector(scanCancel), for: .touchUpInside)
        vwQRCode?.addSubview(btnCancel)
        self.view.bringSubview(toFront: btnCancel)
    }
    
    func scanCancel() {
        objCaptureSession?.stopRunning()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        setScrollViewHeight()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setScrollViewHeight()
    }
    
    func setScrollViewHeight() {
        var contentRect:CGRect = CGRect.zero
        let subViews = self.sv.subviews
        for subview in subViews{
            contentRect = contentRect.union(subview.frame);
        }
        self.sv.contentSize = contentRect.size;
        
        //print(contentRect.size)
    }
    
    func setMainViewLayout() {
        
        /* Receipt View Start */
        let vReceiptView = VerticalLayout(xoff: 0, yoff: 0, width: mainLayout.frame.width, height: 0)
        mainLayout.addSubview(vReceiptView)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.context //appDelegate.persistentContainer.viewContext
        
        let requestOrderId = NSFetchRequest<NSFetchRequestResult>(entityName: "Order_master")
        
        requestOrderId.returnsObjectsAsFaults = false
        var tempId = ""
        var orderCounter = 1
        do {
            let results = try context.fetch(requestOrderId)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let receiptData = result.value(forKey: "order_id") as? String {
                        if tempId != receiptData {
                            tempId = receiptData
                            orderCounter = orderCounter + 1
                        }
                    }
                }
            }
            
            orderCount = orderCounter
            orderId = "283M" + String(orderCount)
            order_id = orderId
        }
        catch {
            //print("Could not fetch data")
        }
        
        txt_receipt = UITextField(frame: CGRect(x: 8, y: 0, width: vReceiptView.frame.width-16, height: 30))
        //txt_receipt.placeholder = "Receipt No"
        txt_receipt.attributedPlaceholder = NSAttributedString(string: "Receipt No", attributes: [NSForegroundColorAttributeName: UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)])
        txt_receipt.borderStyle = UITextBorderStyle.roundedRect
        txt_receipt.backgroundColor = UIColor.white
        txt_receipt.tintColor = tintColor
        txt_receipt.returnKeyType = .next
        txt_receipt.delegate = self as UITextFieldDelegate
        txt_receipt.isEnabled = false
        txt_receipt.text = "Receipt No: " + order_id
        txt_receipt.tag = tagCounter
        tagCounter = tagCounter + 1
        vReceiptView.addSubview(txt_receipt)
        
        /* Date View Start */
        let vDateContainer = VerticalLayout(xoff: 0, yoff: 0, width: mainLayout.frame.width, height: 0)
        mainLayout.addSubview(vDateContainer)
        
        let hDateViewContainer = HorizontalLayout(xoff: 8, yoff: 0, width: vDateContainer.frame.width-20, height: 64)
        vDateContainer.addSubview(hDateViewContainer)
        
        let dateViewColor : UIColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
        
        let vOrderDateView = VerticalLayout(xoff: 0, yoff: 0, width: hDateViewContainer.frame.width*0.5, height: 0)
        vOrderDateView.backgroundColor = dateViewColor
        hDateViewContainer.addSubview(vOrderDateView)
        
        btn_order_date = UITextField(frame: CGRect(x: 4, y: 4, width: vOrderDateView.frame.width-8, height: 30))
        btn_order_date.text = "ORDER DATE"
        btn_order_date.textAlignment = .center
        btn_order_date.backgroundColor = UIColor(red: 0.86, green: 0.85, blue: 0.85, alpha: 1.0)
        btn_order_date.tintColor = UIColor.clear
        btn_order_date.resignFirstResponder()
        btn_order_date.delegate = self
        vOrderDateView.addSubview(btn_order_date)
        
        lbl_order_date = UITextField(frame: CGRect(x: 4, y: 4, width: vOrderDateView.frame.width-8, height: 30))
        lbl_order_date.textAlignment = .center
        //lbl_order_date.backgroundColor = UIColor(red: 0.86, green: 0.85, blue: 0.85, alpha: 1.0)
        lbl_order_date.tintColor = UIColor.clear
        lbl_order_date.resignFirstResponder()
        lbl_order_date.delegate = self
        lbl_order_date.tag = tagCounter
        tagCounter = tagCounter + 1
        vOrderDateView.addSubview(lbl_order_date)
        
        let vDeliveryDateView = VerticalLayout(xoff: 4, yoff: 0, width: hDateViewContainer.frame.width*0.5, height: 0)
        vDeliveryDateView.backgroundColor = dateViewColor
        hDateViewContainer.addSubview(vDeliveryDateView)
        
        btn_delivery_date = UITextField(frame: CGRect(x: 4, y: 4, width: vDeliveryDateView.frame.width-8, height: 30))
        btn_delivery_date.text = "DELIVERY DATE"
        btn_delivery_date.textAlignment = .center
        btn_delivery_date.backgroundColor = UIColor(red: 0.86, green: 0.85, blue: 0.85, alpha: 1.0)
        btn_delivery_date.tintColor = UIColor.clear
        btn_delivery_date.resignFirstResponder()
        btn_delivery_date.delegate = self
        vDeliveryDateView.addSubview(btn_delivery_date)
        
        lbl_delivery_date = UITextField(frame: CGRect(x: 4, y: 4, width: vDeliveryDateView.frame.width-8, height: 30))
        lbl_delivery_date.textAlignment = .center
        //lbl_delivery_date.backgroundColor = UIColor(red: 0.86, green: 0.85, blue: 0.85, alpha: 1.0)
        lbl_delivery_date.tintColor = UIColor.clear
        lbl_delivery_date.resignFirstResponder()
        lbl_delivery_date.delegate = self
        lbl_delivery_date.tag = tagCounter
        tagCounter = tagCounter + 1
        vDeliveryDateView.addSubview(lbl_delivery_date)
        lbl_delivery_date.isEnabled = false
        
        setContactView()
        
        let vCommentView = VerticalLayout(xoff: 0, yoff: 8, width: mainLayout.frame.width, height: 0)
        mainLayout.addSubview(vCommentView)
        
        txt_comment = UITextView(frame: CGRect(x: 8, y: 0, width: vCommentView.frame.width - 20, height: 30))
        let borderColor : UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        txt_comment.layer.borderColor = borderColor.cgColor
        txt_comment.layer.borderWidth = 1.0
        txt_comment.layer.cornerRadius = 5.0
        txt_comment.tintColor = tintColor
        txt_comment.delegate = self as UITextViewDelegate
        txt_comment.backgroundColor = UIColor.white
        txt_comment.isScrollEnabled = false
        txt_comment.tag = tagCounter
        tagCounter = tagCounter + 1
        if txt_comment.text == "" {
            textViewDidEndEditing(txt_comment)
        }
        
        vCommentView.addSubview(txt_comment)
    }
    
    func setContactView() {
        let vContactViewContainer = VerticalLayout(xoff: 0, yoff: 0, width: mainLayout.frame.width, height: 0)
        mainLayout.addSubview(vContactViewContainer)
        
        /* Customer View Start */
        let vCustomerViewContainer = VerticalLayout(xoff: 0, yoff: 0, width: vContactViewContainer.frame.width, height: 0)
        vContactViewContainer.addSubview(vCustomerViewContainer)
        
        let hCustomerView = HorizontalLayout(xoff: 8, yoff: 0, width: vCustomerViewContainer.frame.width-20, height: 26)
        vCustomerViewContainer.addSubview(hCustomerView)
        
        txtCustomerName = UITextField(frame: CGRect(x: 0, y: 0, width: hCustomerView.frame.width-34, height: 30))
        //txtCustomerName.placeholder = "Customer Name"
        txtCustomerName.attributedPlaceholder = NSAttributedString(string: "Customer Name", attributes: [NSForegroundColorAttributeName: UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)])
        txtCustomerName.borderStyle = UITextBorderStyle.roundedRect
        txtCustomerName.backgroundColor = UIColor.white
        txtCustomerName.tintColor = tintColor
        txtCustomerName.returnKeyType = .next
        txtCustomerName.tag = tagCounter
        tagCounter = tagCounter + 1
        hCustomerView.addSubview(txtCustomerName)
        
        let btnContact = UIButton(frame: CGRect(x: 4, y: 0, width: 30, height: 30))
        btnContact.setBackgroundImage(#imageLiteral(resourceName: "contact"), for: .normal)
        btnContact.addTarget(self, action: #selector(btnSelectContact), for: .touchUpInside)
        hCustomerView.addSubview(btnContact)
        
        /* Mobile View Start */
        let vMobileViewContainer = VerticalLayout(xoff: 0, yoff: 0, width: vContactViewContainer.frame.width, height: 0)
        vContactViewContainer.addSubview(vMobileViewContainer)
        
        let hMobileView = HorizontalLayout(xoff: 8, yoff: 0, width: vMobileViewContainer.frame.width-20, height: 26)
        vMobileViewContainer.addSubview(hMobileView)
        
        txtMobile = UITextField(frame: CGRect(x: 0, y: 0, width: hMobileView.frame.width, height: 30))
        //txtMobile.placeholder = "Mobile"
        txtMobile.attributedPlaceholder = NSAttributedString(string: "Mobile", attributes: [NSForegroundColorAttributeName: UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)])
        txtMobile.borderStyle = UITextBorderStyle.roundedRect
        txtMobile.backgroundColor = UIColor.white
        txtMobile.tintColor = tintColor
        txtMobile.returnKeyType = .next
        txtMobile.tag = tagCounter
        tagCounter = tagCounter + 1
        hMobileView.addSubview(txtMobile)
        
        /* Email View Start */
        let vEmailViewContainer = VerticalLayout(xoff: 0, yoff: 0, width: vContactViewContainer.frame.width, height: 0)
        vContactViewContainer.addSubview(vEmailViewContainer)
        
        let hEmailView = HorizontalLayout(xoff: 8, yoff: 0, width: vEmailViewContainer.frame.width-20, height: 26)
        vEmailViewContainer.addSubview(hEmailView)
        //print(vEmailViewContainer.frame.height)
        
        txtEmail = UITextField(frame: CGRect(x: 0, y: 0, width: hEmailView.frame.width, height: 30))
        //txtEmail.placeholder = "Email"
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)])
        txtEmail.borderStyle = UITextBorderStyle.roundedRect
        txtEmail.backgroundColor = UIColor.white
        txtEmail.tintColor = tintColor
        txtEmail.returnKeyType = .next
        txtEmail.tag = tagCounter
        tagCounter = tagCounter + 1
        hEmailView.addSubview(txtEmail)
        
    }
    
    func setFooterViewLayout() {
        let vAddView = VerticalLayout(xoff: 0, yoff: 0, width: mainLayout.frame.width, height: 0)
        mainLayout.addSubview(vAddView)
        
        let btnAdd = UIButton(frame: CGRect(x: 8, y: 0, width: vAddView.frame.width-16, height: 40))
        btnAdd.setTitle("...+ Add more", for: .normal)
        btnAdd.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 32)
        let myColor : UIColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        btnAdd.setTitleColor(myColor, for: .normal)
        btnAdd.contentHorizontalAlignment = .center
        btnAdd.addTarget(self, action: #selector(addOrderDetailsView), for: .touchUpInside)
        vAddView.addSubview(btnAdd)
        
        let btnContainer = VerticalLayout(xoff: 0, yoff: 0, width: mainLayout.frame.width, height: 0)
        mainLayout.addSubview(btnContainer)
        
        let hbtnContainer = HorizontalLayout(xoff: 8, yoff: 0, width: btnContainer.frame.width-20, height: 38)
        btnContainer.addSubview(hbtnContainer)
        
        let vResetContainer = UIView(frame: CGRect(x: 0, y: 0, width: hbtnContainer.frame.width*0.5, height: 38))
        hbtnContainer.addSubview(vResetContainer)
        
        let btnReset = UIButton(frame: CGRect(x: 0, y: 0, width: vResetContainer.frame.width, height: 40))
        btnReset.setTitle("RESET", for: .normal)
        btnReset.backgroundColor = UIColor(red: 0.86, green: 0.85, blue: 0.85, alpha: 1.0)
        btnReset.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1.0), for: .normal)
        btnReset.addTarget(self, action: #selector(resetOrderForm1), for: .touchUpInside)
        vResetContainer.addSubview(btnReset)
        
        let vSaveContainer = UIView(frame: CGRect(x: 4, y: 0, width: hbtnContainer.frame.width*0.5, height: 38))
        hbtnContainer.addSubview(vSaveContainer)
        
        let btnSave = UIButton(frame: CGRect(x: 0, y: 0, width: vSaveContainer.frame.width, height: 40))
        btnSave.setTitle("SAVE", for: .normal)
        btnSave.backgroundColor = UIColor(red: 0.86, green: 0.85, blue: 0.85, alpha: 1.0)
        btnSave.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1.0), for: .normal)
        btnSave.addTarget(self, action: #selector(validateOrderForm), for: .touchUpInside)
        vSaveContainer.addSubview(btnSave)
    }
    
    func addOrderDetailsView(_ sender: UIButton)
    {
        
        if orderDetailViewCounter < 4 {
            //print(orderDetailViewCounter)
            // titleDtlsCounter = 0
            if orderDetailViewCounter == 3
            {
                
                orderDetailViewCounter = orderDetailViewCounter + 1
                setOrderViewLayout()
                let viewHeight = self.vOrderDetails.frame.height
                if reset_count > 0
                {
                    
                    self.sv.contentSize.height = self.sv.contentSize.height + viewHeight - 640  - CGFloat(title_count * 35)
                }
                else
                {
                    self.sv.contentSize.height = self.sv.contentSize.height + viewHeight - 640 - CGFloat(title_count * 35)
                    
                }
            }
            else if orderDetailViewCounter == 2
            {
                orderDetailViewCounter = orderDetailViewCounter + 1
                setOrderViewLayout()
                let viewHeight = self.vOrderDetails.frame.height
                if reset_count ==  0
                {
                    self.sv.contentSize.height = self.sv.contentSize.height + viewHeight - 320 - CGFloat(title_count * 35)
                }
                else
                {
                    self.sv.contentSize.height = self.sv.contentSize.height + viewHeight - 320  - CGFloat(title_count * 35)
                }
            }
            else
            {
                orderDetailViewCounter = orderDetailViewCounter + 1
                setOrderViewLayout()
                let viewHeight = self.vOrderDetails.frame.height
                self.sv.contentSize.height = self.sv.contentSize.height + viewHeight - CGFloat(title_count * 35)
                
            }
        }
    }
    
    func setOrderViewLayout()
    {
        
        let vLayout = VerticalLayout(xoff: 8, yoff: 8, width: mainLayout.frame.width-16, height: 0)
        let mainViewColor : UIColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
        vLayout.backgroundColor = mainViewColor
        arrayOfOrderDetailView.append(vLayout)
        vOrderDetails.addSubview(vLayout)
        
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
        let getItemCount = String(arrayOfViewLable.count + 1)
        lbl_item_no.text = getItemCount + ". item"
        arrayOfViewLable.append(lbl_item_no)
        vlbl_view.addSubview(lbl_item_no)
        
        let btn_menu = UIButton(frame: CGRect(x: vBtn_view.frame.width-25, y: 4, width: 25, height: 25))
        btn_menu.setBackgroundImage(#imageLiteral(resourceName: "menu"), for: .normal)
        btn_menu.addTarget(self, action: #selector(pop_action), for: .touchUpInside)
        btn_menu.tag = (arrayOfOrderDetailView.count - 1)
        arrayOfMenuBtn.append(btn_menu)
        vBtn_view.addSubview(btn_menu)
        
        /* Image View Start */
        let img_view = VerticalLayout(xoff: 0, yoff: 4, width: vLayout.frame.width, height: 0)
        vLayout.addSubview(img_view)
        
        btn_camera = UIButton(frame: CGRect(x: (img_view.frame.width * 0.5) - 65, y: 4, width: 110, height: 110))
        btn_camera.setBackgroundImage(#imageLiteral(resourceName: "new_camera_edit"), for: .normal)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        btn_camera.isUserInteractionEnabled = true
        btn_camera.addGestureRecognizer(tapGestureRecognizer)
        arrayOfCameraBtn.append(btn_camera)
        img_view.addSubview(btn_camera)
        
        /* Title detail View Start */
        title_dtls_view = VerticalLayout(xoff: 0, yoff: 0, width: vLayout.frame.width, height: 0)
        arrayOfTitleDetailsView.append(title_dtls_view)
        vLayout.addSubview(title_dtls_view)
        
        for _ in 0 ..< 3 {
            title_dtls_view.addSubview(addTitleDetaiFields(xOff: 0, yOff: 0, width: title_dtls_view.frame.width, height: 0))
        }
        
        /* Add Field Button View Start */
        let add_field_view = VerticalLayout(xoff: 0, yoff: 0, width: vLayout.frame.width, height: 0)
        vLayout.addSubview(add_field_view)
        
        let btn_add_fields = UIButton(frame: CGRect(x: 8, y: 0, width: add_field_view.frame.width-16, height: 30))
        btn_add_fields.setTitle("...+ Add fields", for: .normal)
        btn_add_fields.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 10)
        let myColor : UIColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        btn_add_fields.setTitleColor(myColor, for: .normal)
        btn_add_fields.contentHorizontalAlignment = .left
        btn_add_fields.tag = arrayOfAddFieldBtn.count
        btn_add_fields.addTarget(self, action: #selector(addFieldAction), for: .touchUpInside)
        arrayOfAddFieldBtn.append(btn_add_fields)
        add_field_view.addSubview(btn_add_fields)
        
        /* Description View Start */
        let vViewDescription = VerticalLayout(xoff: 0, yoff: 0, width: vLayout.frame.width, height: 40)
        vLayout.addSubview(vViewDescription)
        
        let txt_description = UITextView(frame: CGRect(x: 4, y: 0, width: vViewDescription.frame.width - 8, height: 30))
        let borderColor : UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        txt_description.layer.borderColor = borderColor.cgColor
        txt_description.layer.borderWidth = 1.0
        txt_description.layer.cornerRadius = 5.0
        txt_description.tintColor = tintColor
        txt_description.delegate = self as UITextViewDelegate
        txt_description.backgroundColor = UIColor.white
        txt_description.tag = tagCounter
        tagCounter = tagCounter + 1
        if txt_description.text == "" {
            textViewDidEndEditing(txt_description)
        }
        arrayOfDescription.append(txt_description)
        vViewDescription.addSubview(txt_description)
    }
    
    func addFieldAction(sender: UIButton) {
        if countTextField(sv: arrayOfTitleDetailsView[sender.tag]) < 10 {
            titleDtlsCounter = titleDtlsCounter + 1
            title_count = title_count + 1
            arrayOfTitleDetailsView[sender.tag].addSubview(addTitleDetaiFields(xOff: 0, yOff: 0, width: title_dtls_view.frame.width, height: 0))
            self.sv.contentSize.height = self.sv.contentSize.height + 35
        }
    }
    
    func countTextField(sv: UIView) -> Int {
        var counter = 0
        for view in sv.subviews {
            if view is UITextField {
                counter = counter + 1
            }
            else if view is UIView
            {
                _ = countTextField(sv: view)
            }
        }
        return counter
    }
    
    func addTitleDetaiFields(xOff: CGFloat, yOff: CGFloat, width: CGFloat, height: CGFloat)->UIView {
        let vTitleDtlContainer = VerticalLayout(xoff: xOff, yoff: yOff, width: width, height: height)
        
        let rowTitleDetail_view = HorizontalLayout(xoff: 0, yoff: 0, width: 0, height: 34)
        vTitleDtlContainer.addSubview(rowTitleDetail_view)
        
        let txtTitle = UITextField(frame: CGRect(x: 4, y: 0, width: vTitleDtlContainer.frame.width*0.4, height: 30))
        //txtTitle.placeholder = "Title"
        txtTitle.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSForegroundColorAttributeName: UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)])
        txtTitle.borderStyle = UITextBorderStyle.roundedRect
        txtTitle.backgroundColor = UIColor.white
        txtTitle.tintColor = tintColor
        txtTitle.returnKeyType = .next
        txtTitle.tag = tagCounter
        tagCounter = tagCounter + 1
        txtTitle.accessibilityIdentifier = String(orderDetailViewCounter)
        arrayOfTitleText.append(txtTitle)
        rowTitleDetail_view.addSubview(txtTitle)
        
        let txtDetail = UITextField(frame: CGRect(x: 4, y: 0, width: vTitleDtlContainer.frame.width*0.56, height: 30))
        //txtDetail.placeholder = "Detail"
        txtDetail.attributedPlaceholder = NSAttributedString(string: "Detail", attributes: [NSForegroundColorAttributeName: UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)])
        txtDetail.borderStyle = UITextBorderStyle.roundedRect
        txtDetail.backgroundColor = UIColor.white
        txtDetail.tintColor = tintColor
        txtDetail.tag = tagCounter
        tagCounter = tagCounter + 1
        txtDetail.returnKeyType = .next
        txtDetail.accessibilityIdentifier = String(orderDetailViewCounter)
        arrayOfDetailText.append(txtDetail)
        rowTitleDetail_view.addSubview(txtDetail)
        return vTitleDtlContainer
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "") {
            if textView.tag == 4 {
                textView.text = "Comment"
            }
            else {
                textView.text = "Description"
            }
            
            textView.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView){
        if textView.text == "Comment" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        else if textView.text == "Description" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == lbl_order_date && textField == lbl_delivery_date && textField == btn_order_date && textField == btn_delivery_date {
            return false
        }
        else {
            return true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let contentSize = textView.sizeThatFits(textView.bounds.size)
        var frame = textView.frame
        frame.size.height = contentSize.height
        if contentSize.height < 90.0
        {
            textView.isScrollEnabled = false
            textView.frame = frame
            self.sv.contentSize.height = self.sv.contentSize.height
        }
        else
        {
            textView.isScrollEnabled = true
        }
        
        return true
    }
    
    func pop_action(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Scan QR", style: .default, handler: { (action: UIAlertAction) in
            self.configureVideoCapture()
            self.addVideoPreviewLayer()
            self.initializeQRView()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction) in
            
            if sender.tag < self.arrayOfOrderDetailView.count
            {
                let view1 = self.arrayOfOrderDetailView[sender.tag]
                let height = view1.frame.height
                self.orderDetailViewCounter = self.orderDetailViewCounter - 1
                self.sv.contentSize.height = self.sv.contentSize.height - height
                
                self.arrayOfOrderDetailView[sender.tag].removeFromSuperview()
                self.arrayOfOrderDetailView.remove(at: sender.tag)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func btnSelectContact(_ sender: Any) {
        let entityType = CNEntityType.contacts
        let authStatus = CNContactStore.authorizationStatus(for: entityType)
        
        if authStatus == CNAuthorizationStatus.notDetermined {
            let contactStore = CNContactStore.init()
            
            contactStore.requestAccess(for: entityType, completionHandler: { (success, nil) in
                
                if success {
                    self.openContacts()
                }
                else {
                    //print("Not authorized")
                }
            })
        }
        else if authStatus == CNAuthorizationStatus.authorized {
            self.openContacts()
        }
    }
    
    func displayAlertMessage(messageToDisplay: String, isSuccessful: Bool)
    {
        let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func displayprintMessage(messageToDisplay: String)
    {
        let alertController = UIAlertController(title: "print", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "YES", style: .default) { (action:UIAlertAction!) in
            
        }
        let CANCELAction = UIAlertAction(title: "NO", style: .default) { (action:UIAlertAction!) in
            
        }
        
        alertController.addAction(OKAction)
        alertController.addAction(CANCELAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func openContacts() {
        let contactPicker = CNContactPickerViewController.init()
        contactPicker.delegate = self
        
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        picker.dismiss(animated: true) {
            
        }
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let customerName = "\(contact.givenName) \(contact.familyName)"
        self.txtCustomerName.text = customerName
        
        var email = "Not available"
        
        if !contact.emailAddresses.isEmpty {
            let emailString = (((contact.emailAddresses[0] as AnyObject).value(forKey: "labelValuePair") as AnyObject).value(forKey: "value"))
            
            email = emailString! as! String
        }
        
        self.txtEmail.text = email
        
        var mobile = "Not available"
        
        let mobileString = ((((contact.phoneNumbers[0] as AnyObject).value(forKey: "labelValuePair") as AnyObject).value(forKey: "value") as AnyObject).value(forKey: "stringValue"))
        
        mobile = mobileString! as! String
        
        self.txtEmail.text = email
        self.txtMobile.text = mobile
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let image = UIImagePickerController()
        image.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                image.sourceType = .camera
                self.present(image, animated: true, completion: nil)
            }
            else {
                //print("Camera not available")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo library", style: .default, handler: { (action: UIAlertAction) in
            image.sourceType = .photoLibrary
            self.present(image, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageObj = info[UIImagePickerControllerOriginalImage] as? UIImage {
            arrayOfImageObjects.append(imageObj)
            btn_camera.setBackgroundImage(imageObj, for: .normal)
        }
        else {
            //print("Something went wrong")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func createOrderDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneOrderPressed))
        toolbar.setItems([doneButton], animated: false)
        
        btn_order_date.inputAccessoryView = toolbar
        btn_order_date.inputView = orderDatePicker
    }
    
    func doneOrderPressed() {
        customer_issue_date = orderDatePicker.date
        let strDate = dateFormatter.string(from: customer_issue_date)
        lbl_order_date.text = strDate
        self.view.endEditing(true)
    }
    
    func createDeliveryDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDeliveryPressed))
        toolbar.setItems([doneButton], animated: false)
        
        btn_delivery_date.inputAccessoryView = toolbar
        btn_delivery_date.inputView = deliveryDatePicker
    }
    
    func doneDeliveryPressed() {
        customer_delivered_date = deliveryDatePicker.date
        let strDate = dateFormatter.string(from: customer_delivered_date)
        lbl_delivery_date.text = strDate
        self.view.endEditing(true)
    }
    
    func saveOrderDetails() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.context //appDelegate.persistentContainer.viewContext
        
        let requestCustomer = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
        
        requestCustomer.predicate = NSPredicate(format: "customer_name = %@", txtCustomerName.text!)
        
        requestCustomer.returnsObjectsAsFaults = false
        var customerId = 0
        
        customer_comment = txt_comment.text
        isImageSync = 0
        isOrderSync = 0
        isReady = 0
        isReceived = 0
        order_status = "New"
        let user_id : Int? = UserDefaults.standard.object(forKey: "userId") as? Int
        userId = user_id!
        
        do {
            let customer_results = try context.fetch(requestCustomer)
            
            if customer_results.count > 0 {
                for cust_result in customer_results as! [NSManagedObject] {
                    if let custId = cust_result.value(forKey: "customer_id") as? Int32 {
                        customerId = Int(custId)
                    }
                }
            }
            else {
                let requestCustomer = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
                requestCustomer.returnsObjectsAsFaults = false
                do {
                    let customer_results = try context.fetch(requestCustomer)
                    
                    if customer_results.count > 0 {
                        customerId = customer_results.count + 1
                    }
                    else {
                        customerId = 1
                    }
                }
                catch {
                    //print("Count not retrive customer count")
                }
                let newCustomer = NSEntityDescription.insertNewObject(forEntityName: "Customer", into: context)
                newCustomer.setValue(customerId, forKey: "customer_id")
                newCustomer.setValue(txtCustomerName.text, forKey: "customer_name")
                newCustomer.setValue(txtEmail.text, forKey: "customer_email")
                newCustomer.setValue(txtMobile.text, forKey: "customer_mobile")
            }
            customer_id = customerId
        }
        catch {
            //print("Could not fetch customer data")
        }
        
        for i in 0 ..< arrayOfOrderDetailView.count {
            order_comment = arrayOfDescription[i].text
            let newOrder = NSEntityDescription.insertNewObject(forEntityName: "Order_master", into: context)
            newOrder.setValue(order_comment, forKey: "order_comment")
            var data: NSData?
            
            if i < arrayOfImageObjects.count {
                imageURL = arrayOfImageObjects[i]
                if let cgImage = imageURL.cgImage, cgImage.renderingIntent == .defaultIntent {
                    data = UIImageJPEGRepresentation(imageURL, 0.8) as NSData?
                }
                else {
                    data = UIImagePNGRepresentation(imageURL) as NSData?
                }
            }
            
            newOrder.setValue(order_id, forKey: "order_id")
            orderSubId = order_id + "_" + String(i+1)
            newOrder.setValue(orderSubId, forKey: "order_sub_id")
            
            newOrder.setValue(i+1, forKey: "order_sort_id")
            
            let createdDate = Date()
            newOrder.setValue(createdDate, forKey: "created_date")
            newOrder.setValue(customer_issue_date, forKey: "customer_issue_date")
            newOrder.setValue(customer_delivered_date, forKey: "customer_delivered_date")
            newOrder.setValue(customer_id, forKey: "customer_id")
            newOrder.setValue(customer_comment, forKey: "customer_comment")
            newOrder.setValue(order_status, forKey: "order_status")
            newOrder.setValue(data, forKey: "imageURL")
            newOrder.setValue(isImageSync, forKey: "isImageSync")
            newOrder.setValue(isOrderSync, forKey: "isOrderSync")
            newOrder.setValue(isReady, forKey: "isReady")
            newOrder.setValue(isReceived, forKey: "isReceived")
            newOrder.setValue(userId, forKey: "userId")
        }
        
        for j in 0 ..< arrayOfTitleText.count {
            if arrayOfTitleText[j].text != "" {
                let newFieldMaster = NSEntityDescription.insertNewObject(forEntityName: "Field_master", into: context)
                orderSubId = order_id + "_" + arrayOfTitleText[j].accessibilityIdentifier!
                newFieldMaster.setValue(orderSubId, forKey: "order_sub_id")
                newFieldMaster.setValue(arrayOfTitleText[j].text, forKey: "field_title")
                newFieldMaster.setValue(arrayOfDetailText[j].text, forKey: "field_value")
                newFieldMaster.setValue(0, forKey: "isSync")
                //order_sub_sort_id
                newFieldMaster.setValue(j, forKey: "order_sub_sort_id")
            }
        }
        
//        do {
//            try context.save()
//            display//printMessage(messageToDisplay: "Would you like to //print the order.")
//            self.resetOrderForm1()
//            
//            
//            self.orderCount = self.orderCount + 1
//            self.order_id = "283M" + String(self.orderCount)
//            self.txt_receipt.text = "Receipt No: " + self.order_id
//        }
//        catch {
//            displayAlertMessage(messageToDisplay: "Error while saving data to core data", isSuccessful: false)
//        }
        
        appDelegate.save()
        displayprintMessage(messageToDisplay: "Would you like to //print the order.")
        self.resetOrderForm1()
        
        
        self.orderCount = self.orderCount + 1
        self.order_id = "283M" + String(self.orderCount)
        self.txt_receipt.text = "Receipt No: " + self.order_id
    }
    func resetOrderForm1()
    {
        orderDetailViewCounter = 1
        //        for view1 in sv.subviews
        //        {
        //           view1.removeFromSuperview()
        //        }
        //        viewDidLoad()
        reset_count += 1
        var cv = 0
        //print(arrayOfOrderDetailView.count)
        for view in  arrayOfOrderDetailView
        {
            view.removeFromSuperview()
            if cv > 0
            {
                
                sv.contentSize.height =  sv.contentSize.height - view.frame.height
            }
            
            cv += 1
        }
        //print(arrayOfTitleText.count)
        arrayOfOrderDetailView.removeAll()
        // sv.removeFromSuperview()
        //  viewDidLoad()
        //  viewWillAppear(true)
        // viewDidAppear(true)
        // viewDidLayoutSubviews()
        
        resetOrderForm()
       
        // sv.contentSize.height =  657.0
        
    }
    
    func resetOrderForm()
    {
        
        let currDate = Date()
        let strCurrDate = dateFormatter.string(from: currDate)
        lbl_order_date.text = strCurrDate
        lbl_delivery_date.text = ""
        txtCustomerName.text = ""
        txtMobile.text = ""
        txtEmail.text = ""
        btnMobile.setBackgroundImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        btnEmail.setBackgroundImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        txt_comment.text = ""
        if (txt_comment.text == "") {
            txt_comment.text = "Comment"
            
            txt_comment.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        }
        btn_camera.setBackgroundImage(#imageLiteral(resourceName: "new_camera_edit"), for: .normal)
        
        for view in vOrderDetails.subviews {
            view.removeFromSuperview()
        }
        
        
        
        arrayOfOrderDetailView.removeAll()
        arrayOfViewLable.removeAll()
        arrayOfMenuBtn.removeAll()
        arrayOfCameraBtn.removeAll()
        arrayOfTitleText.removeAll()
        arrayOfDetailText.removeAll()
        arrayOfAddFieldBtn.removeAll()
        arrayOfDescription.removeAll()
        arrayOfTitleDetailsView.removeAll()
        arrayOfImageObjects.removeAll()
        
        setOrderViewLayout()
        // sv.contentSize.height = 657.0
        // viewDidLayoutSubviews()
        //viewDidAppear(true)
        //sv.contentSize.height = 657.0
        // setScrollViewHeight()
        
        //NewOrderViewController.layoutSubviews()
        
//        let myOrderDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tes123tViewController") as! tes123tViewController
//        
//        self.navigationController?.pushViewController(myOrderDetailsViewController, animated: true)
    }
    
    func validateOrderForm() {
        if txtCustomerName.text == "" {
            isFormValidated = false
            displayAlertMessage(messageToDisplay: "Customer name cannot be left blank", isSuccessful: false)
        }
        else {
            if txtMobile.text == "" {
                isFormValidated = false
                displayAlertMessage(messageToDisplay: "Mobile number cannot be left blank", isSuccessful: false)
            }
            else {
                if lbl_order_date.text == "" {
                    isFormValidated = false
                    displayAlertMessage(messageToDisplay: "Please select order date", isSuccessful: false)
                }
                else {
                    if lbl_delivery_date.text == "" {
                        isFormValidated = false
                        displayAlertMessage(messageToDisplay: "Please select delivery date", isSuccessful: false)
                    }
                    else {
                        var tempAcc = ""
                        for j in 0 ..< arrayOfTitleText.count {
                            if arrayOfTitleText[j].accessibilityIdentifier != tempAcc {
                                tempAcc = arrayOfTitleText[j].accessibilityIdentifier!
                                if arrayOfTitleText[j].text == "" {
                                    isFormValidated = false
                                }
                                else {
                                    if arrayOfDetailText[j].text == "" {
                                        isFormValidated = false
                                    }
                                    else {
                                        isFormValidated = true
                                    }
                                }
                            }
                        }
                        if isFormValidated == false {
                            displayAlertMessage(messageToDisplay: "Every product must have atleat one title and detail", isSuccessful: false)
                        }
                        else {
                            isFormValidated = true
                            saveOrderDetails()
                        }
                    }
                }
            }
        }
    }
}

class VerticalLayout: UIView {
    
    var yOffsets: [CGFloat] = []
    
    init(xoff: CGFloat, yoff: CGFloat, width: CGFloat, height: CGFloat) {
        super.init(frame: CGRect(x:xoff, y:yoff, width: width, height: height))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        var height: CGFloat = 0
        
        for i in 0..<subviews.count {
            let view = subviews[i] as UIView
            view.layoutSubviews()
            height += yOffsets[i]
            view.frame.origin.y = height
            height += view.frame.height
        }
        
        self.frame.size.height = height + 5
        
    }
    
    override func addSubview(_ view: UIView) {
        
        yOffsets.append(view.frame.origin.y)
        super.addSubview(view)
    }
    
    func removeAll()
    {
        
        for view in subviews {
            view.removeFromSuperview()
        }
        yOffsets.removeAll(keepingCapacity: false)
        
    }
    
}

class HorizontalLayout: UIView {
    
    var xOffsets: [CGFloat] = []
    var yOffsets: [CGFloat] = []
    
    init(xoff: CGFloat, yoff: CGFloat, width: CGFloat, height: CGFloat) {
        super.init(frame: CGRect(x: xoff, y: xoff, width: width, height: height))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        var width: CGFloat = 0
        
        for i in 0..<subviews.count {
            let view = subviews[i] as UIView
            view.layoutSubviews()
            width += xOffsets[i]
            view.frame.origin.x = width
            width += view.frame.width
        }
        
        self.frame.size.width = width + 8
        
    }
    
    override func addSubview(_ view: UIView) {
        
        xOffsets.append(view.frame.origin.x)
        super.addSubview(view)
    }
    
    func removeAll() {
        
        for view in subviews {
            view.removeFromSuperview()
        }
        xOffsets.removeAll(keepingCapacity: false)
        
    }
    
}


class IQKeyboardViewContainer: UIView {
    var yOffsets: [CGFloat] = []
    
    init(xoff: CGFloat, yoff: CGFloat, width: CGFloat, height: CGFloat) {
        super.init(frame: CGRect(x:xoff, y:yoff, width: width, height: height))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        var height: CGFloat = 0
        
        for i in 0..<subviews.count {
            let view = subviews[i] as UIView
            view.layoutSubviews()
            height += yOffsets[i]
            view.frame.origin.y = height
            height += view.frame.height
        }
        
        self.frame.size.height = height + 5
        
    }
    
    override func addSubview(_ view: UIView) {
        
        yOffsets.append(view.frame.origin.y)
        super.addSubview(view)
        
    }
    
    func removeAll() {
        
        for view in subviews {
            view.removeFromSuperview()
        }
        yOffsets.removeAll(keepingCapacity: false)
        
    }
}
