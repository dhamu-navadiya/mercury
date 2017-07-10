//
//  ReceivedViewController.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 4/11/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit
import CoreData

class ReceivedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var receivedOrderTableView: UITableView!
    
    var initialLblData:[Character] = []
    var receiptLblData:[String] = []
    var dateLblData:[String] = []
    var deliveryDateData:[String] = []
    var customerCommentArray:[String] = []
    var customerLblData:[String] = []
    var customerMobileData:[String] = []
    var customerEmailData:[String] = []
    var itemImageArray:[UIImage] = []
    var descriptionArray:[String] = []
    var orderSubIdArray:[String] = []
    var titleTextArray:[[String]] = []
    var detailTextArray:[[String]] = []
    
    let cellSpacingHeight: CGFloat = 10
    var numberOfRows = 0
    var rowCounter = 0
    var stringPassed = ""
    var orderSubId:String!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let requestOrder = NSFetchRequest<NSFetchRequestResult>(entityName: "Order_master")
    let requestCustomer = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
    let requestFieldMaster = NSFetchRequest<NSFetchRequestResult>(entityName: "Field_master")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Received Order"
        
        receivedOrderTableView.dataSource = self
        receivedOrderTableView.delegate = self
        
        let nibName0 = UINib(nibName: "ContactTableViewCell", bundle: nil)
        receivedOrderTableView.register(nibName0, forCellReuseIdentifier: "contact_cell")
        
        let nibName = UINib(nibName: "ReceivedTableViewCell", bundle: nil)
        receivedOrderTableView.register(nibName, forCellReuseIdentifier: "received_cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        receivedOrderTableView.reloadData()
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
        
        numberOfRows = 0
        rowCounter = 0
        
        let context = appDelegate.context //appDelegate.persistentContainer.viewContext
        
        requestOrder.returnsObjectsAsFaults = false
        requestCustomer.returnsObjectsAsFaults = false
        requestFieldMaster.returnsObjectsAsFaults = false
        
        let predicate0 = NSPredicate(format: "order_id == %@", "\(stringPassed)")
        let predicate1 = NSPredicate(format: "order_status == %@", "Received")
        let predicateCompound = NSCompoundPredicate.init(andPredicateWithSubpredicates: [predicate0,  predicate1])
        
        requestOrder.predicate = predicateCompound
        
        do {
            let results = try context.fetch(requestOrder)
            
            if results.count > 0 {
                numberOfRows = results.count
                for result in results as! [NSManagedObject] {
                    if let customerId = result.value(forKey: "customer_id") as? Int32 {
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
                        receiptLblData.append(receiptData)
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
                    }
                    else {
                        itemImageArray.append(#imageLiteral(resourceName: "new_camera_edit"))
                    }
                    
                    if let description = result.value(forKey: "order_comment") as? String {
                        descriptionArray.append(description)
                    }
                    
                    if let order_subId = result.value(forKey: "order_sub_id") as? String {
                        orderSubIdArray.append(order_subId)
                        requestFieldMaster.predicate = NSPredicate(format: "order_sub_id = %@", "\(order_subId)")
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
            }
        }
        catch {
            //print("Could not fetch data for orders")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        if let rect = self.navigationController?.navigationBar.frame {
            let y = rect.size.height + rect.origin.y
            receivedOrderTableView.contentInset = UIEdgeInsetsMake( y, 0, 0, 0)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        //return productImageData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return numberOfRows + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = receivedOrderTableView.dequeueReusableCell(withIdentifier: "contact_cell", for: indexPath) as! ContactTableViewCell
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
            let cell = receivedOrderTableView.dequeueReusableCell(withIdentifier: "received_cell", for: indexPath) as! ReceivedTableViewCell
            cell.setOrderViewLayout(itemCount: String(indexPath.row), prevImage: itemImageArray[indexPath.row - 1], desc: descriptionArray[indexPath.row - 1], titleArray: titleTextArray[indexPath.row - 1], detailArray: detailTextArray[indexPath.row - 1], orderSubIdArray: orderSubIdArray[indexPath.row - 1], counter: indexPath.row)
            
            cell.btn_menu.addTarget(self, action: #selector(pop_action), for: .touchUpInside)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            cell.btn_camera.addGestureRecognizer(tapGestureRecognizer)
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
            return 192
        }
        else {
            return 380
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
        }))
        
        actionSheet.addAction(UIAlertAction(title: "print", style: .default, handler: { (action: UIAlertAction) in
            self.displayAlertMessage(messageToDisplay: "Would you like to //print the order?")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action: UIAlertAction) in
            let rowIndex = sender.tag
            let indexPath : NSIndexPath = NSIndexPath(row: rowIndex, section: 0)
            
            let cell = self.receivedOrderTableView.cellForRow(at: indexPath as IndexPath) as? ReceivedTableViewCell
            cell?.txt_description.isEditable = true
            
            for j in 0 ..< (cell?.arrayOfTitleText.count)! {
                cell?.arrayOfTitleText[j].isEnabled = true
                cell?.arrayOfTitleText[j].isUserInteractionEnabled = true
            }
            cell?.btnContainer.isHidden = false
            cell?.add_field_view.isHidden = false
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction) in
            //
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Mark as Ready", style: .default, handler: { (action: UIAlertAction) in
            let context = self.appDelegate.context //appDelegate.persistentContainer.viewContext
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
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let _:UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
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
}
