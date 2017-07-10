//
//  DeliveredDetailViewController.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 5/28/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit
import CoreData

class DeliveredDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var deliveredDetailTableView: UITableView!

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
    
    var manufacturerLblData:[String] = []
    var manufacturerMobileData:[String] = []
    var manufacturerEmailData:[String] = []
    var manufacturerDateLblData:[String] = []
    var manufacturerDeliveryDateData:[String] = []
    var morderDateData:[Date] = []
    var mdeliveryDateData:[Date] = []
    
    let cellSpacingHeight: CGFloat = 10
    var numberOfRows = 0
    var rowCounter = 0
    var stringPassed = ""
    var orderSubId:String!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let requestOrder = NSFetchRequest<NSFetchRequestResult>(entityName: "Order_master")
    let requestCustomer = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
    let requestFieldMaster = NSFetchRequest<NSFetchRequestResult>(entityName: "Field_master")
    let requestOrderTransfer = NSFetchRequest<NSFetchRequestResult>(entityName: "Order_transfer")
    let requestManufacturer = NSFetchRequest<NSFetchRequestResult>(entityName: "Manufacturer")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "In Process Order"
        
        deliveredDetailTableView.dataSource = self
        deliveredDetailTableView.delegate = self
        
        let nibName0 = UINib(nibName: "DeliveredContactTableViewCell", bundle: nil)
        deliveredDetailTableView.register(nibName0, forCellReuseIdentifier: "delivered_contact_cell")
        
        let nibName = UINib(nibName: "DeliveredDetailTableViewCell", bundle: nil)
        deliveredDetailTableView.register(nibName, forCellReuseIdentifier: "delivered_detail_cell")
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        deliveredDetailTableView.reloadData()
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
        let predicate1 = NSPredicate(format: "order_status == %@", "Delivered")
        let predicateCompound = NSCompoundPredicate.init(andPredicateWithSubpredicates: [predicate0, predicate1])
        
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
                        
                        requestOrderTransfer.predicate = NSPredicate(format: "order_id = %@", "\(order_subId)")
                        let orderTransferResult = try context.fetch(requestOrderTransfer)
                        if orderTransferResult.count > 0 {
                            for otresult in orderTransferResult as! [NSManagedObject] {
                                if let toId = otresult.value(forKey: "to_id") as? Int32 {
                                    do {
                                        requestManufacturer.predicate = NSPredicate(format: "manufacturer_id == %@", "\(toId)")
                                        let manufactResults = try context.fetch(requestManufacturer)
                                        
                                        if manufactResults.count > 0 {
                                            for manufactResult in manufactResults as! [NSManagedObject] {
                                                if let manufactName = manufactResult.value(forKey: "manufacturer_name") as? String {
                                                    manufacturerLblData.append(manufactName)
                                                }
                                                if let manufactMobile = manufactResult.value(forKey: "manufacturer_mobile") as? String {
                                                    manufacturerMobileData.append(manufactMobile)
                                                }
                                                if let manufactEmail = manufactResult.value(forKey: "manufacturer_email") as? String {
                                                    manufacturerEmailData.append(manufactEmail)
                                                }
                                            }
                                        }
                                    }
                                    catch {
                                        //print("Could not fetch data for customer")
                                    }
                                }
                                if let orderTransferDate = otresult.value(forKey: "order_transfer_date") as? NSDate {
                                    morderDateData.append(orderTransferDate as Date)
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "dd/MM/yyyy"
                                    let date = dateFormatter.string(from: orderTransferDate as Date)
                                    manufacturerDateLblData.append(date)
                                }
                                
                                if let manufacturerDeliveryDate = otresult.value(forKey: "manufacturer_delivery_date") as? NSDate {
                                    mdeliveryDateData.append(manufacturerDeliveryDate as Date)
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "dd/MM/yyyy"
                                    let date = dateFormatter.string(from: manufacturerDeliveryDate as Date)
                                    manufacturerDeliveryDateData.append(date)
                                }
                            }
                        }
                    }
                }
            }
        }
        catch {
            //print("Could not fetch data for orders")
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
            let cell = deliveredDetailTableView.dequeueReusableCell(withIdentifier: "delivered_contact_cell", for: indexPath) as! DeliveredContactTableViewCell
            let borderColor : UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
            cell.view_contactC.layer.borderColor = borderColor.cgColor
            cell.view_contactC.layer.borderWidth = 1.0
            cell.view_contactC.layer.cornerRadius = 5.0
            
            cell.txt_comment.layer.borderColor = borderColor.cgColor
            cell.txt_comment.layer.borderWidth = 1.0
            cell.txt_comment.layer.cornerRadius = 5.0
            cell.initialiseData(receipt: receiptLblData[indexPath.row], orderDate: dateLblData[indexPath.row], deliveryDate: deliveryDateData[indexPath.row], customer: customerLblData[indexPath.row], mobile: customerMobileData[indexPath.row], email: customerEmailData[indexPath.row], comment: customerCommentArray[indexPath.row])
            
            cell.btn_call.accessibilityIdentifier = customerMobileData[indexPath.row]
            cell.btn_call.addTarget(self, action: #selector(openDialerAction), for: .touchUpInside)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        else {
            let cell = deliveredDetailTableView.dequeueReusableCell(withIdentifier: "delivered_detail_cell", for: indexPath) as! DeliveredDetailTableViewCell
            
            let strManufacturerData:String = manufacturerLblData.count > 0 ? manufacturerLblData[indexPath.row - 1] : ""
            let strManufacturerMobileData:String = manufacturerMobileData.count > 0 ? manufacturerMobileData[indexPath.row - 1] : ""
            let strManufacturerEmailDate:String = manufacturerEmailData.count > 0 ? manufacturerEmailData[indexPath.row - 1] : ""
            let strManufacturerDateData:String = manufacturerDateLblData.count > 0 ? manufacturerDateLblData[indexPath.row - 1] : ""
            let strManufacturerDeliveryDateData:String = manufacturerDeliveryDateData.count > 0 ? manufacturerDeliveryDateData[indexPath.row - 1] : ""
            
            let strMorderDateData:Date = morderDateData.count > 0 ? morderDateData[indexPath.row - 1] : Date()
            let strMdeliveryDateData:Date = mdeliveryDateData.count > 0 ? mdeliveryDateData[indexPath.row - 1] : Date()
            
            cell.setOrderViewLayout(itemCount: String(indexPath.row), prevImage: itemImageArray[indexPath.row - 1], desc: descriptionArray[indexPath.row - 1], titleArray: titleTextArray[indexPath.row - 1], detailArray: detailTextArray[indexPath.row - 1], orderSubIdArray: orderSubIdArray[indexPath.row - 1], counter: indexPath.row, txt_manufacturer: strManufacturerData, txt_mobile: strManufacturerMobileData, txt_email: strManufacturerEmailDate, orderDate: strManufacturerDateData, deliveryDate: strManufacturerDeliveryDateData, orderDateData: strMorderDateData, deliveryDateData: strMdeliveryDateData)
            
            //cell.btn_menu.addTarget(self, action: #selector(pop_action), for: .touchUpInside)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
    func pop_action(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Poke", style: .default, handler: { (action: UIAlertAction) in
            //
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func openDialerAction(_ sender: UIButton) {
        let phone = String(describing: sender.accessibilityIdentifier)
        var validPhoneNumber = ""
        phone.characters.forEach {(character) in
            switch character {
            case "0"..."9":
                validPhoneNumber.characters.append(character)
            default:
                break
            }
        }
        let phoneUrl = "tel://\(validPhoneNumber)"
        if let phoneCallURL = URL(string: phoneUrl) {
            UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
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
            
            let newtitleTextArray:[String] = self.titleTextArray.count > 0 ? self.titleTextArray[indexPath.row - 1] : [""]
            if newtitleTextArray.count > 3
            {
                let textfield_hieght = CGFloat((newtitleTextArray.count - 3) * 45)
                
                return 523 + textfield_hieght
            }
            else
            {
                return 523
                
            }

            //return 450
        }
    }
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
}
