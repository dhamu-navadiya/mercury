//
//  ReceivedViewController.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 4/11/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit
import CoreData

class MyOrderDetailsViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var myOrderDetailsTableView: UITableView!
    
    var initialLblData:[Character] = []
    var receiptLblData:[String] = []
    var itemNoArray:[Character] = []
    var dateLblData:[String] = []
    var arr_edit_option:[String] = []
    var deliveryDateData:[String] = []
    var customerCommentArray:[String] = []
    var customerLblData:[String] = []
    var customerMobileData:[String] = []
    var customerEmailData:[String] = []
    var itemImageArray:[UIImage] = []
    var descriptionArray:[String] = []
    var orderSubIdArray:[String] = []
    var orderSortIdArray:[String] = []
    var titleTextArray:[[String]] = []
    var detailTextArray:[[String]] = []
   // var arrayOfTitleText:[[UITextField]] = []
    //var arrayOfDetailText:[[UITextField]] = []
    
    var org_titleTextArray:[[String]] = []
    var org_detailTextArray:[[String]] = []
    
    
    let cellSpacingHeight: CGFloat = 15
    var numberOfRows = 0
    var rowCounter = 0
    var stringPassed = ""
    var orderSubId:String!
    
    var rowIndex1 = -1
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let requestOrder = NSFetchRequest<NSFetchRequestResult>(entityName: "Order_master")
    let requestCustomer = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
    let requestFieldMaster = NSFetchRequest<NSFetchRequestResult>(entityName: "Field_master")
    
    var toId: Int32 = 0
    var orderId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Order"
        myOrderDetailsTableView.allowsSelection = false
        let emailBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(sendOrderThroughEmail))
        NotificationCenter.default.addObserver(self, selector: #selector(MyOrderDetailsViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("editDataset"), object: nil)
        
        let menuButton = UIButton(type: .custom)
        menuButton.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        menuButton.addTarget(self, action: #selector(popupMenuAction), for: .touchUpInside)
        menuButton.frame = CGRect(x: 4, y: 4, width: 24, height: 24)
        menuButton.tintColor = UIColor.white
        let menuBarButtonItem = UIBarButtonItem(customView: menuButton)
        
        self.navigationItem.rightBarButtonItems = [menuBarButtonItem, emailBarButtonItem]
        
        loadData()
        
        myOrderDetailsTableView.dataSource = self
        myOrderDetailsTableView.delegate = self
        
        let nibName0 = UINib(nibName: "ContactDetailTableViewCell", bundle: nil)
        myOrderDetailsTableView.register(nibName0, forCellReuseIdentifier: "myorder_contact_cell")
        
        let nibName = UINib(nibName: "DetailTableViewCell", bundle: nil)
        myOrderDetailsTableView.register(nibName, forCellReuseIdentifier: "myorder_detail_cell")
    }
    
    func methodOfReceivedNotification(notification: Notification){
        
        let dic = notification.object as! NSDictionary
        let tag = dic["tag"] as! Int
        
        if  tag > 9 && tag < 100
        {
           
          // //print(tag / 10)
            let  item_number = (tag / 10) - 1
            let  textfield_num = (tag % 10)
            let text =  dic["text"] as! String
            titleTextArray[item_number][textfield_num] = (text as NSString) as String
           // //print(titleTextArray[item_number])
            
        }
        else if tag > 500
        {
            let details_tag = tag - 500
            let  item_number = (details_tag / 10) - 1
            let  textfield_num = (details_tag % 10)
            let text =  dic["text"] as! String
            detailTextArray[item_number][textfield_num] = (text as NSString) as String
          //  //print(detailTextArray[item_number])
            
        }
        //print(detailTextArray)
        
        //Take Action on Notification
    }
    
    func sendOrderThroughEmail(_ sender: UIBarButtonItem) {
        
    }
    
    func popupMenuAction(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "print", style: .default, handler: { (action: UIAlertAction) in
            self.displayAlertMessage(messageToDisplay: "Would you like to //print the order?")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction) in
            //
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "load"), object: nil)
    }

    func loadData() {
        
        initialLblData.removeAll()
        receiptLblData.removeAll()
        dateLblData.removeAll()
        customerCommentArray.removeAll()
        customerLblData.removeAll()
        itemImageArray.removeAll()
        descriptionArray.removeAll()
        orderSubIdArray.removeAll()
        titleTextArray.removeAll()
        detailTextArray.removeAll()
        arr_edit_option.removeAll()
        orderSortIdArray.removeAll()
        numberOfRows = 0
        rowCounter = 0
        
        let context = appDelegate.context //appDelegate.persistentContainer.viewContext
        
        requestOrder.returnsObjectsAsFaults = false
        requestCustomer.returnsObjectsAsFaults = false
        requestFieldMaster.returnsObjectsAsFaults = false
        
        let predicate0 = NSPredicate(format: "order_id == %@", "\(stringPassed)")
        let predicate1 = NSPredicate(format: "order_status == %@", "New")
        let predicateCompound = NSCompoundPredicate.init(andPredicateWithSubpredicates: [predicate0, predicate1])
        
        requestOrder.predicate = predicateCompound
        let sortDescriptor = NSSortDescriptor(key: "order_sort_id", ascending: true)
        let sortDescriptors = [sortDescriptor]
        requestOrder.sortDescriptors = sortDescriptors
        
        do {
            let results = try context.fetch(requestOrder)
            
            if results.count > 0 {
                numberOfRows = results.count
                for result in results as! [NSManagedObject] {
                    if let customerId = result.value(forKey: "customer_id") as? Int32 {
                        toId = customerId
                        do {
                            requestCustomer.predicate = NSPredicate(format: "customer_id == %@", "\(customerId)")
                            let custResults = try context.fetch(requestCustomer)
                            
                            if custResults.count > 0 {
                                for custResult in custResults as! [NSManagedObject] {
                                    if var custName = custResult.value(forKey: "customer_name") as? String {
                                        customerLblData.append(custName)
                                        custName = custName.capitalized
                                        let firstChar = custName[custName.startIndex]
                                        initialLblData.append(firstChar)
                                    }
                                    if let custMobile = custResult.value(forKey: "customer_mobile") as? String {
                                        customerMobileData.append(custMobile)
                                    }
                                    if let custEmail = custResult.value(forKey: "customer_email") as? String {
                                        customerEmailData.append(custEmail)
                                    }
                                }
                            }
                        }
                        catch {
                            //print("Could not fetch data for customer")
                        }
                    }
                    if let receiptData = result.value(forKey: "order_id") as? String {
                        orderId = receiptData
                        receiptLblData.append(receiptData)
                    }
                    if let orderSortID = result.value(forKey: "order_sort_id") as? Int16 {
                        orderSortIdArray.append(String(orderSortID))
                    }
                    if let orderDate = result.value(forKey: "customer_issue_date") as? NSDate {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        let date = dateFormatter.string(from: orderDate as Date)
                        dateLblData.append(date)
                    }
                    
                    if let deliveryDate = result.value(forKey: "customer_delivered_date") as? NSDate {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        let date = dateFormatter.string(from: deliveryDate as Date)
                        deliveryDateData.append(date)
                    }
                    if let commentTxt = result.value(forKey: "customer_comment") as? String {
                        customerCommentArray.append(commentTxt)
                    }
                    
                    if let imageData = result.value(forKey: "imageURL") as? NSData {
                        if let image = UIImage(data:imageData as Data) {
                            itemImageArray.append(image)
                        }
                        else {
                            itemImageArray.append(#imageLiteral(resourceName: "new_camera_edit"))
                        }
                    }
                    else {
                        itemImageArray.append(#imageLiteral(resourceName: "new_camera_edit"))
                    }
                    
                    if let description = result.value(forKey: "order_comment") as? String {
                        descriptionArray.append(description)
                    }
                    
                    if let order_subId = result.value(forKey: "order_sub_id") as? String {
                        let lastChar = order_subId[order_subId.index(before: order_subId.endIndex)]
                        itemNoArray.append(lastChar)
                        orderSubIdArray.append(order_subId)
                        requestFieldMaster.predicate = NSPredicate(format: "order_sub_id = %@", "\(order_subId)")
                        let sortDescriptor1 = NSSortDescriptor(key: "order_sub_sort_id", ascending: true)
                        let sortDescriptors1 = [sortDescriptor1]
                        requestFieldMaster.sortDescriptors = sortDescriptors1
                        arr_edit_option.append("0")
                        let fieldResults = try context.fetch(requestFieldMaster)
                        if fieldResults.count > 0 {
                            var arrayTitle:[String] = []
                            var arrayDetail:[String] = []
                            for fields in fieldResults as! [NSManagedObject] {
                                if let txtTitle = fields.value(forKey: "field_title") as? String {
                                    arrayTitle.append(txtTitle)
                                }
                                if let txtDetails = fields.value(forKey: "field_value") as? String {
                                    arrayDetail.append(txtDetails)
                                }
                            }
                            rowCounter = rowCounter + 1
                            titleTextArray.append(arrayTitle)
                            detailTextArray.append(arrayDetail)
                        }
                    }
                }
                
                org_titleTextArray = titleTextArray
                org_detailTextArray = detailTextArray
            }
        }
        catch {
            //print("Could not fetch data for orders")
        }
        
        if rowCounter > 0 {
            myOrderDetailsTableView.reloadData()
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        if let rect = self.navigationController?.navigationBar.frame {
            let y = rect.size.height + rect.origin.y
            myOrderDetailsTableView.contentInset = UIEdgeInsetsMake( y, 0, 0, 0)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = myOrderDetailsTableView.dequeueReusableCell(withIdentifier: "myorder_contact_cell", for: indexPath) as! ContactDetailTableViewCell
            let borderColor : UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
            cell.view_contactC.layer.borderColor = borderColor.cgColor
            cell.view_contactC.layer.borderWidth = 1.0
            cell.view_contactC.layer.cornerRadius = 5.0
            
            cell.txt_comment.layer.borderColor = borderColor.cgColor
            cell.txt_comment.layer.borderWidth = 1.0
            cell.txt_comment.layer.cornerRadius = 5.0
            cell.initialiseData(receipt: receiptLblData[indexPath.row], orderDate: dateLblData[indexPath.row], deliveryDate: deliveryDateData[indexPath.row], customer: customerLblData[indexPath.row], mobile: customerMobileData[indexPath.row], email: customerEmailData[indexPath.row], comment: customerCommentArray[indexPath.row])
            return cell
        }
        else {
            let cell = myOrderDetailsTableView.dequeueReusableCell(withIdentifier: "myorder_detail_cell", for: indexPath) as! DetailTableViewCell
            let newtitleTextArray:[String] = self.titleTextArray.count > 0 ? self.titleTextArray[indexPath.row - 1] : [""]
            let newdetailTextArray:[String] = self.detailTextArray.count > 0 ? self.detailTextArray[indexPath.row - 1] : [""]
            let neworderSubIdArray:String = self.orderSubIdArray.count > 0 ? self.orderSubIdArray[indexPath.row - 1] : ""
            
             let orderSortId:String = self.orderSortIdArray.count > 0 ? self.orderSortIdArray[indexPath.row - 1] : ""
            
            if arr_edit_option[indexPath.row - 1] == "0"
            {
                cell.setOrderViewLayout(itemCount: orderSortId, prevImage: itemImageArray[indexPath.row - 1], desc: descriptionArray[indexPath.row - 1], titleArray: newtitleTextArray, detailArray: newdetailTextArray, orderSubIdArray: neworderSubIdArray, counter: indexPath.row)
                
            }
            else
            {
               cell.setOrderViewLayout_add_fiels(itemCount: orderSortId, prevImage: itemImageArray[indexPath.row - 1], desc: descriptionArray[indexPath.row - 1], titleArray: newtitleTextArray, detailArray: newdetailTextArray, orderSubIdArray: neworderSubIdArray, counter: indexPath.row)
               
            }
            cell.btn_add_fields.addTarget(self, action: #selector(btn_add_field_click), for: .touchUpInside)
            cell.btn_add_fields.addTarget(self, action: #selector(btn_add_field_click), for: .touchUpInside)
            cell.btnReset.addTarget(self, action: #selector(btn_cancel_field_click), for: .touchUpInside)
            cell.btnSave.addTarget(self, action: #selector(btn_Save_Item), for: .touchUpInside)
            cell.btn_menu.addTarget(self, action: #selector(pop_action), for: .touchUpInside)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            cell.btn_camera.addGestureRecognizer(tapGestureRecognizer)
            cell.btnReset.tag = indexPath.row
            cell.btnSave.tag = indexPath.row
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.clear
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 220
        }
        else {
             let newtitleTextArray:[String] = self.titleTextArray.count > 0 ? self.titleTextArray[indexPath.row - 1] : [""]
            if newtitleTextArray.count > 3
            {
                //print(" title_count : \(newtitleTextArray.count)")
                let textfield_hieght = CGFloat((newtitleTextArray.count - 3) * 45)
                
                return 390 + 50 + textfield_hieght
            }
            else
            {
                //print(" title_count : \(newtitleTextArray.count)")
                return 390 + 50
            }
        }
    }
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func pop_action(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Forward", style: .default, handler: { (action: UIAlertAction) in
            let receiptPopupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForwardPopup") as! ForwardViewController
            receiptPopupViewController.subOrderId = sender.accessibilityIdentifier!
            self.navigationController?.present(receiptPopupViewController, animated: true, completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "print", style: .default, handler: { (action: UIAlertAction) in
            self.displayAlertMessage(messageToDisplay: "Would you like to //print the order?")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action: UIAlertAction) in
            let rowIndex = sender.tag
            self.rowIndex1 = sender.tag
            let indexPath : NSIndexPath = NSIndexPath(row: rowIndex, section: 0)
            
            let cell = self.myOrderDetailsTableView.cellForRow(at: indexPath as IndexPath) as? DetailTableViewCell
            cell?.txt_description.isEditable = true
            self.arr_edit_option[sender.tag - 1] = "1"
            
            //            for j in 0 ..< (cell?.arrayOfTitleText.count)! {
            //                cell?.arrayOfTitleText[j].isEnabled = true
            //                cell?.arrayOfTitleText[j].isUserInteractionEnabled = true
            //            }
            
            
            self.enableTextField(sv: (cell?.title_dtls_view)!)
            
            cell?.btnContainer.isHidden = false
            cell?.add_field_view.isHidden = false
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction) in
            let context = self.appDelegate.context //self.appDelegate.persistentContainer.viewContext
            let predicate0 = NSPredicate(format: "order_sub_id == %@", "\(sender.accessibilityIdentifier!)")
            self.requestOrder.predicate = predicate0
            self.requestOrder.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(self.requestOrder)
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject]
                    {
                        //orderStatus
                        if let _:String = result.value(forKey: "order_status") as? String {
                            result.setValue("Deleted", forKey: "order_status")
                    }
                        
                        let deletedDate = Date()
                        result.setValue(deletedDate, forKey: "deleted_date")
                        
//                        do {
//                            try context.save()
//                            self.loadData()
//                        }
//                        catch {
//                            //print("Could not delete order")
//                        }
                        
                        self.appDelegate.save()
                        self.loadData()
                    }
                }
            }
            catch {
                //print("Could not fetch data for orders")
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Mark as Ready", style: .default, handler: { (action: UIAlertAction) in
            let context = self.appDelegate.context //self.appDelegate.persistentContainer.viewContext
            let predicate0 = NSPredicate(format: "order_sub_id == %@", "\(sender.accessibilityIdentifier!)")
            self.requestOrder.predicate = predicate0
            self.requestOrder.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(self.requestOrder)
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        //orderStatus
                        if let _:String = result.value(forKey: "order_status") as? String {
                            result.setValue("Ready", forKey: "order_status")
                        }
                        
                        let newOrderTransfer = NSEntityDescription.insertNewObject(forEntityName: "Order_transfer", into: context)
                        self.orderId = sender.accessibilityIdentifier!
                        newOrderTransfer.setValue(self.orderId, forKey: "order_id")
                        if let userId = result.value(forKey: "userId") as? Int32 {
                            newOrderTransfer.setValue(userId, forKey: "from_id")
                            newOrderTransfer.setValue(userId, forKey: "parent_id")
                        }
                        newOrderTransfer.setValue(self.toId, forKey: "to_id")
                        
                        let transferDate = Date()
                        
                        newOrderTransfer.setValue(transferDate, forKey: "order_transfer_date")
                        newOrderTransfer.setValue("Ready", forKey: "order_status")
                        newOrderTransfer.setValue(transferDate, forKey: "status_date")
                        
//                        do {
//                            try context.save()
//                            self.loadData()
//                        }
//                        catch {
//                            //print("Could not update order")
//                        }
                        
                        self.appDelegate.save()
                        self.loadData()
                    }
                }
            }
            catch {
                //print("Could not fetch data for orders")
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func enableTextField(sv: UIView) {
        for view in sv.subviews {
            if let textField = view as? UITextField {
                textField.isEnabled = true
                textField.isUserInteractionEnabled = true
            }
            else if view is UIView {
                _ = enableTextField(sv: view)
            }
        }
    }
    
    func displayAlertMessage(messageToDisplay: String)
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
    // save edite
    func btn_Save_Item(sender: UIButton)
    {
        self.view.endEditing(true)
//        let indexPath : NSIndexPath = NSIndexPath(row: sender.tag, section: 0)
//        let cell = self.myOrderDetailsTableView.cellForRow(at: indexPath as IndexPath) as? DetailTableViewCell
       
//        //print("title : \(self.titleTextArray)")
//        //print("detail : \(self.detailTextArray)")
        
        //Get sub order id
        let orderSubId:String = orderSubIdArray[sender.tag-1]

        //Fetch existing one to delete it
        let fieldMasterRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Field_master")
        let predicate = NSPredicate(format: "order_sub_id == %@", "\(orderSubId)")
        let predicateCompound = NSCompoundPredicate.init(andPredicateWithSubpredicates: [predicate])
        fieldMasterRequest.predicate = predicateCompound
        do {
            let results:[NSManagedObject] = try appDelegate.context.fetch(fieldMasterRequest) as! [NSManagedObject]
            
            for subOrderItemManagedObject:NSManagedObject in results {
                appDelegate.context.delete(subOrderItemManagedObject)
            }
        }
        catch {
            //print("Could not fetch data for Field_master table")
        }
    
        //Now add new one
        let titleArray:[String] = self.titleTextArray[sender.tag-1]
        let detailArray:[String] = self.detailTextArray[sender.tag-1]
        var j:Int = 0
        for strTitle:String in titleArray {
            
            let strNewTitle:String = strTitle == "Title" ? "" : strTitle
            let strDetail:String = detailArray[j] == "Details" ? "" : detailArray[j]
            
            if strNewTitle.characters.count > 0 || strDetail.characters.count > 0 {
                let newFieldMaster = NSEntityDescription.insertNewObject(forEntityName: "Field_master", into: appDelegate.context)
                newFieldMaster.setValue(orderSubId, forKey: "order_sub_id")
                newFieldMaster.setValue(strNewTitle, forKey: "field_title")
                newFieldMaster.setValue(strDetail, forKey: "field_value")
                newFieldMaster.setValue(0, forKey: "isSync")
                //order_sub_sort_id
                newFieldMaster.setValue(j, forKey: "order_sub_sort_id")
                
                j += 1
            }
        }
        
        appDelegate.save()
        
        let alertController = UIAlertController(title: "Mercury", message: "Sub order item saved successfully", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    func btn_cancel_field_click(sender: UIButton)
    {
        self.view.endEditing(true)
        
        let indexPath : NSIndexPath = NSIndexPath(row: sender.tag, section: 0)
        
        let cell = self.myOrderDetailsTableView.cellForRow(at: indexPath as IndexPath) as? DetailTableViewCell
        self.arr_edit_option[sender.tag - 1] = "0"
        titleTextArray[sender.tag - 1] = org_titleTextArray[sender.tag - 1]
        detailTextArray[sender.tag - 1] = org_detailTextArray[sender.tag - 1]
        let newtitleTextArray:[String] = self.org_titleTextArray.count > 0 ? self.org_titleTextArray[indexPath.row - 1] : [""]
        let newdetailTextArray:[String] = self.org_detailTextArray.count > 0 ? self.org_detailTextArray[indexPath.row - 1] : [""]
        let neworderSubIdArray:String = self.orderSubIdArray.count > 0 ? self.orderSubIdArray[indexPath.row - 1] : ""
        
        let orderSortId:String = self.orderSortIdArray.count > 0 ? self.orderSortIdArray[indexPath.row - 1] : ""
        
          //  self.self.detailTextArray[indexPath.row - 1] = newdetailTextArray
            
            //self.titleTextArray[indexPath.row - 1] = newtitleTextArray
            
            
            
            cell?.setOrderViewLayout_reset(itemCount:orderSortId, prevImage: itemImageArray[indexPath.row - 1], desc: descriptionArray[indexPath.row - 1], titleArray: newtitleTextArray, detailArray: newdetailTextArray, orderSubIdArray: neworderSubIdArray, counter: newtitleTextArray.count)
            
            cell?.btn_add_fields.addTarget(self, action: #selector(btn_add_field_click), for: .touchUpInside)
            //cell?.addTitleDetaiFields(xOff: 0, yOff: 4, width: <#T##CGFloat#>, height: <#T##CGFloat#>, titleText: <#T##String#>, detailText: <#T##String#>, cnt: <#T##Int#>)
            cell?.btn_add_fields.isEnabled = false
            cell?.btnContainer.isHidden = true
            cell?.add_field_view.isHidden = true
             cell?.reloadInputViews()
            //cell?.btnContainer.removeFromSuperview()
           // myOrderDetailsTableView.reloadData()
             myOrderDetailsTableView.reloadInputViews()
           // cell?.reloadInputViews()
           myOrderDetailsTableView.reloadData()
           myOrderDetailsTableView.setNeedsLayout()
        

        
        
    }
    
    func btn_add_field_click(sender: UIButton)
    {
        
        
        let indexPath : NSIndexPath = NSIndexPath(row: rowIndex1, section: 0)
        
        let cell = self.myOrderDetailsTableView.cellForRow(at: indexPath as IndexPath) as? DetailTableViewCell
       
        var newtitleTextArray:[String] = self.titleTextArray.count > 0 ? self.titleTextArray[indexPath.row - 1] : [""]
        var newdetailTextArray:[String] = self.detailTextArray.count > 0 ? self.detailTextArray[indexPath.row - 1] : [""]
        let neworderSubIdArray:String = self.orderSubIdArray.count > 0 ? self.orderSubIdArray[indexPath.row - 1] : ""
        
        let orderSortId:String = self.orderSortIdArray.count > 0 ? self.orderSortIdArray[indexPath.row - 1] : ""
        
        if newtitleTextArray.count < 9
        {
        newtitleTextArray.append("Title")
        newdetailTextArray.append("Details")
        self.self.detailTextArray[indexPath.row - 1] = newdetailTextArray
        
        self.titleTextArray[indexPath.row - 1] = newtitleTextArray
        
        
      
            cell?.setOrderViewLayout_add_fiels(itemCount: orderSortId, prevImage: itemImageArray[indexPath.row - 1], desc: descriptionArray[indexPath.row - 1], titleArray: newtitleTextArray, detailArray: newdetailTextArray, orderSubIdArray: neworderSubIdArray, counter: newtitleTextArray.count)
        
         cell?.btn_add_fields.addTarget(self, action: #selector(btn_add_field_click), for: .touchUpInside)
        //cell?.addTitleDetaiFields(xOff: 0, yOff: 4, width: <#T##CGFloat#>, height: <#T##CGFloat#>, titleText: <#T##String#>, detailText: <#T##String#>, cnt: <#T##Int#>)
        
        cell?.btn_add_fields.isEnabled = true
        cell?.btnContainer.isHidden = false
        cell?.add_field_view.isHidden = false
        cell?.reloadInputViews()
        myOrderDetailsTableView.reloadData()
        }
        
        self.enableTextField(sv: (cell?.title_dtls_view)!)
        
        cell?.btnContainer.isHidden = false
        cell?.add_field_view.isHidden = false
        
        
        
        
        
    }

    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageObj:UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //print("\(imageObj)")
            //arrayOfImageObjects.append(imageObj)
            //btn_camera.setBackgroundImage(imageObj, for: .normal)
        }
        else {
            //print("Something went wrong")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
//    func saveOrderDetails() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        
//        let requestCustomer = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
//        
//        requestCustomer.predicate = NSPredicate(format: "customer_name = %@", txtCustomerName.text!)
//        
//        requestCustomer.returnsObjectsAsFaults = false
//        var customerId = 0
//        
//        customer_comment = txt_comment.text
//        isImageSync = 0
//        isOrderSync = 0
//        isReady = 0
//        isReceived = 0
//        order_status = "New"
//        let user_id : Int? = UserDefaults.standard.object(forKey: "userId") as? Int
//        userId = user_id!
//        
//        do {
//            let customer_results = try context.fetch(requestCustomer)
//            
//            if customer_results.count > 0 {
//                for cust_result in customer_results as! [NSManagedObject] {
//                    if let custId = cust_result.value(forKey: "customer_id") as? Int32 {
//                        customerId = Int(custId)
//                    }
//                }
//            }
//            else {
//                let requestCustomer = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
//                requestCustomer.returnsObjectsAsFaults = false
//                do {
//                    let customer_results = try context.fetch(requestCustomer)
//                    
//                    if customer_results.count > 0 {
//                        customerId = customer_results.count + 1
//                    }
//                    else {
//                        customerId = 1
//                    }
//                }
//                catch {
//                    //print("Count not retrive customer count")
//                }
//                let newCustomer = NSEntityDescription.insertNewObject(forEntityName: "Customer", into: context)
//                newCustomer.setValue(customerId, forKey: "customer_id")
//                newCustomer.setValue(txtCustomerName.text, forKey: "customer_name")
//                newCustomer.setValue(txtEmail.text, forKey: "customer_email")
//                newCustomer.setValue(txtMobile.text, forKey: "customer_mobile")
//            }
//            customer_id = customerId
//        }
//        catch {
//            //print("Could not fetch customer data")
//        }
//        
//        for i in 0 ..< arrayOfOrderDetailView.count {
//            order_comment = arrayOfDescription[i].text
//            let newOrder = NSEntityDescription.insertNewObject(forEntityName: "Order_master", into: context)
//            newOrder.setValue(order_comment, forKey: "order_comment")
//            var data: NSData?
//            
//            if i < arrayOfImageObjects.count {
//                imageURL = arrayOfImageObjects[i]
//                if let cgImage = imageURL.cgImage, cgImage.renderingIntent == .defaultIntent {
//                    data = UIImageJPEGRepresentation(imageURL, 0.8) as NSData?
//                }
//                else {
//                    data = UIImagePNGRepresentation(imageURL) as NSData?
//                }
//            }
//            
//            newOrder.setValue(order_id, forKey: "order_id")
//            orderSubId = order_id + "_" + String(i+1)
//            newOrder.setValue(orderSubId, forKey: "order_sub_id")
//            
//            let createdDate = Date()
//            
//            newOrder.setValue(createdDate, forKey: "created_date")
//            newOrder.setValue(customer_issue_date, forKey: "customer_issue_date")
//            newOrder.setValue(customer_delivered_date, forKey: "customer_delivered_date")
//            newOrder.setValue(customer_id, forKey: "customer_id")
//            newOrder.setValue(customer_comment, forKey: "customer_comment")
//            newOrder.setValue(order_status, forKey: "order_status")
//            newOrder.setValue(data, forKey: "imageURL")
//            newOrder.setValue(isImageSync, forKey: "isImageSync")
//            newOrder.setValue(isOrderSync, forKey: "isOrderSync")
//            newOrder.setValue(isReady, forKey: "isReady")
//            newOrder.setValue(isReceived, forKey: "isReceived")
//            newOrder.setValue(userId, forKey: "userId")
//        }
//        
//        
//        
//        for j in 0 ..< arrayOfTitleText.count {
//            if arrayOfTitleText[j].text != "" {
//                let newFieldMaster = NSEntityDescription.insertNewObject(forEntityName: "Field_master", into: context)
//                orderSubId = order_id + "_" + arrayOfTitleText[j].accessibilityIdentifier!
//                newFieldMaster.setValue(orderSubId, forKey: "order_sub_id")
//                newFieldMaster.setValue(arrayOfTitleText[j].text, forKey: "field_title")
//                newFieldMaster.setValue(arrayOfDetailText[j].text, forKey: "field_value")
//                newFieldMaster.setValue(0, forKey: "isSync")
//                //order_sub_sort_id
//                newFieldMaster.setValue(j, forKey: "order_sub_sort_id")
//            }
//        }
//        
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
//    }
    

    
}
