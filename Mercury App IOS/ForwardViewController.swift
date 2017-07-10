//
//  ForwardViewController.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 5/23/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import CoreData

class ForwardViewController: UIViewController, CNContactPickerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var txt_manufacturer: UITextField!
    @IBOutlet weak var txt_mobile: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var btn_date: UITextField!
    
    var subOrderId:String = ""
    
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let requestOrder = NSFetchRequest<NSFetchRequestResult>(entityName: "Order_master")
    let requestOrderTransfer = NSFetchRequest<NSFetchRequestResult>(entityName: "Order_transfer")
    let requestCustomer = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
    let requestManufacturer = NSFetchRequest<NSFetchRequestResult>(entityName: "Manufacturer")
    
    var orderId: String = ""
    var fromId: Int32 = 0
    var toId: Int32 = 0
    var parentId: Int32 = 0
    var manufacturerDate: Date = Date()
    var orderTransferDate: Date = Date()
    var orderStatus: String = ""
    var statusDate: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerMode = .date
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        btn_date.delegate = self
        createDeliveryDatePicker()
    }
    @IBAction func btn_contact(_ sender: UIButton) {
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
    @IBAction func btn_cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func btn_inhouse(_ sender: UIButton) {
        
        if txt_manufacturer.text!.characters.count > 0 && txt_mobile.text!.characters.count > 0  && lbl_date.text!.characters.count > 0 && txt_email.text!.characters.count > 0{
            actionForward(actionName: "In House")
            dismiss(animated: true, completion: nil)
        }
        else{
            let actionSheet = UIAlertController(title: "Mercury", message: "Please fill all required fields!", preferredStyle: .alert)
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    @IBAction func btn_forward(_ sender: UIButton) {
        if txt_manufacturer.text!.characters.count > 0 && txt_mobile.text!.characters.count > 0  && lbl_date.text!.characters.count > 0 && txt_email.text!.characters.count > 0{
            actionForward(actionName: "Sent")
            dismiss(animated: true, completion: nil)
        }
        else{
            let actionSheet = UIAlertController(title: "Mercury", message: "Please fill all required fields!", preferredStyle: .alert)
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(actionSheet, animated: true, completion: nil)
        }
       
    }
    
    func actionForward(actionName: String) {
        orderId = subOrderId
        orderStatus = actionName
        let context = appDelegate.context //appDelegate.persistentContainer.viewContext
        let predicate0 = NSPredicate(format: "order_sub_id == %@", "\(subOrderId)")
        requestOrder.predicate = predicate0
        requestOrder.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(requestOrder)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    
                    requestManufacturer.predicate = NSPredicate(format: "manufacturer_name = %@", txt_manufacturer.text!)
                    
                    requestManufacturer.returnsObjectsAsFaults = false
                    var manufacturerId = 0
                    let manufacturer_results = try context.fetch(requestManufacturer)
                    
                    if manufacturer_results.count > 0 {
                        for manufact_result in manufacturer_results as! [NSManagedObject] {
                            if let manufactId = manufact_result.value(forKey: "manufacturer_id") as? Int32 {
                                manufacturerId = Int(manufactId)
                            }
                        }
                    }
                    else {
                        do {
                            let manufact_results = try context.fetch(requestCustomer)
                            
                            if manufact_results.count > 0 {
                                manufacturerId = manufact_results.count + 1
                            }
                            else {
                                manufacturerId = 1
                            }
                        }
                        catch {
                            //print("Count not retrive manufacturer count")
                        }
                        let newManufacturer = NSEntityDescription.insertNewObject(forEntityName: "Manufacturer", into: context)
                        newManufacturer.setValue(manufacturerId, forKey: "manufacturer_id")
                        newManufacturer.setValue(txt_manufacturer.text, forKey: "manufacturer_name")
                        newManufacturer.setValue(txt_email.text, forKey: "manufacturer_email")
                        newManufacturer.setValue(txt_mobile.text, forKey: "manufacturer_mobile")
                    }
                    
                    toId = Int32(manufacturerId)
                    
                    let newOrderTransfer = NSEntityDescription.insertNewObject(forEntityName: "Order_transfer", into: context)
                    newOrderTransfer.setValue(orderId, forKey: "order_id")
                    if let userId = result.value(forKey: "userId") as? Int32 {
                        newOrderTransfer.setValue(userId, forKey: "from_id")
                        newOrderTransfer.setValue(userId, forKey: "parent_id")
                    }
                    newOrderTransfer.setValue(toId, forKey: "to_id")
                    newOrderTransfer.setValue(manufacturerDate, forKey: "manufacturer_delivery_date")
                    newOrderTransfer.setValue(orderTransferDate, forKey: "order_transfer_date")
                    newOrderTransfer.setValue(orderStatus, forKey: "order_status")
                    newOrderTransfer.setValue(statusDate, forKey: "status_date")
                    
                    //orderStatus
                    if let _:String = result.value(forKey: "order_status") as? String {
                        result.setValue(actionName, forKey: "order_status")
                    }
                    
//                    do {
//                        try context.save()
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
//                    }
//                    catch {
//                        //print("Could not update order")
//                    }
                    
                    appDelegate.save()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                }
            }
        }
        catch {
            //print("Could not fetch data for orders")
        }
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
        self.txt_manufacturer.text = customerName
        
        var email = "Not available"
        
        if !contact.emailAddresses.isEmpty {
            let emailString = (((contact.emailAddresses[0] as AnyObject).value(forKey: "labelValuePair") as AnyObject).value(forKey: "value"))
            
            email = emailString! as! String
        }
        
        self.txt_email.text = email
        
        var mobile = "Not available"
        
        let mobileString = ((((contact.phoneNumbers[0] as AnyObject).value(forKey: "labelValuePair") as AnyObject).value(forKey: "value") as AnyObject).value(forKey: "stringValue"))
        
        mobile = mobileString! as! String
        
        self.txt_email.text = email
        self.txt_mobile.text = mobile
    }
    
    func createDeliveryDatePicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDeliveryPressed))
        toolbar.setItems([doneButton], animated: false)
        
        btn_date.inputAccessoryView = toolbar
        btn_date.inputView = datePicker
    }
    
    func doneDeliveryPressed() {
        manufacturerDate = datePicker.date
        let strDate = dateFormatter.string(from: manufacturerDate)
        lbl_date.text = strDate
        self.view.endEditing(true)
    }
}
