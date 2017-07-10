//
//  RegistrationViewController.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 5/3/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit
import CoreData

class RegistrationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var txt_username: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var txt_mobile: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_city: UITextField!
    @IBOutlet weak var txt_state: UITextField!
    @IBOutlet weak var txt_country: UITextField!
    @IBOutlet weak var txt_zip: UITextField!
    @IBOutlet weak var txt_category: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var isFormValidated = false
    var userIdCounter: Int = 0
    
    @IBAction func registerUser(_ sender: UIButton) {
        
        let providedEmailAddress = txt_email.text
        
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: providedEmailAddress!)
        
        if txt_username.text == "" {
            isFormValidated = false
            displayAlertMessage(messageToDisplay: "Username cannot be left blank", isSuccessful: false)
        }
        else {
            if txt_password.text == "" {
                isFormValidated = false
                displayAlertMessage(messageToDisplay: "Password cannot be left blank", isSuccessful: false)
            }
            else {
                if txt_mobile.text! == "" || isPhoneValid(value: txt_mobile.text!) {
                    isFormValidated = false
                    displayAlertMessage(messageToDisplay: "Mobile number is not valid", isSuccessful: false)
                }
                else {
                    if isEmailAddressValid
                    {
                        if txt_city.text == "" {
                            isFormValidated = false
                            displayAlertMessage(messageToDisplay: "City cannot be left blank", isSuccessful: false)
                        }
                        else {
                            if txt_state.text == "" {
                                isFormValidated = false
                                displayAlertMessage(messageToDisplay: "State cannot be left blank", isSuccessful: false)
                            }
                            else {
                                if txt_country.text == "" {
                                    isFormValidated = false
                                    displayAlertMessage(messageToDisplay: "Country cannot be left blank", isSuccessful: false)
                                }
                                else {
                                    if txt_zip.text == "" {
                                        isFormValidated = false
                                        displayAlertMessage(messageToDisplay: "Zipcode cannot be left blank", isSuccessful: false)
                                    }
                                    else {
                                        if txt_category.text == "" {
                                            isFormValidated = false
                                            displayAlertMessage(messageToDisplay: "Please select a category", isSuccessful: false)
                                        }
                                        else {
                                            isFormValidated = true
                                            if isFormValidated == true {
                                                saveToDatabase()
                                                displayAlertMessage(messageToDisplay: "Registration successful", isSuccessful: true)
                                            }
                                            else {
                                                displayAlertMessage(messageToDisplay: "Registration failed", isSuccessful: false)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        isFormValidated = false
                        displayAlertMessage(messageToDisplay: "Email address is not valid", isSuccessful: false)
                    }
                }
            }
        }
        
    }
    
    var categoryArray = ["Select Category", "Jewellery", "Engineering"]
    var categoryPicker = UIPickerView()
    let toolBar = UIToolbar()
    let doneToolbar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
        txt_username.delegate = self
        txt_password.delegate = self
        txt_email.delegate = self
        txt_city.delegate = self
        txt_state.delegate = self
        txt_country.delegate = self
        txt_zip.delegate = self
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        toolBar.sizeToFit()
        
        doneToolbar.sizeToFit()
        let doneEditing = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneClicked))
        doneToolbar.setItems([doneEditing], animated: true)
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        txt_category.inputView = categoryPicker
        txt_category.inputAccessoryView = toolBar
        
        txt_zip.inputAccessoryView = doneToolbar
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.context //appDelegate.persistentContainer.viewContext
        
        let requestCustomer = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        requestCustomer.returnsObjectsAsFaults = false
        do {
            let user_result = try context.fetch(requestCustomer)
            
            if user_result.count > 0 {
                userIdCounter = user_result.count + 1
            }
            else {
                userIdCounter = 1
            }
        }
        catch {
            //print("Count not retrive customer count")
        }
    }
    
    func saveToDatabase() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.context //appDelegate.persistentContainer.viewContext
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        newUser.setValue(userIdCounter, forKey: "userId")
        newUser.setValue(txt_username.text, forKey: "username")
        newUser.setValue(txt_password.text, forKey: "password")
        newUser.setValue(txt_mobile.text, forKey: "mobile")
        newUser.setValue(txt_email.text, forKey: "email")
        newUser.setValue(txt_city.text, forKey: "city")
        newUser.setValue(txt_state.text, forKey: "state")
        newUser.setValue(txt_country.text, forKey: "country")
        newUser.setValue(txt_zip.text, forKey: "pincode")
        newUser.setValue(txt_category.text, forKey: "category")
        
//        do {
//            try context.save()
//        }
//        catch {
//            displayAlertMessage(messageToDisplay: "User cannot be registered. Please try again.", isSuccessful: false)
//        }
        
        appDelegate.save()
    }
    
    func doneClicked() {
        view.endEditing(true)
    }
    
    func donePicker (sender:UIBarButtonItem)
    {
        txt_category.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txt_category.text = categoryArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row]
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            //print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    func isPhoneValid(value: String) -> Bool {
        let PHONE_REGEX = "(?:(\\+\\d\\d\\s+)?((?:\\(\\d\\d\\)|\\d\\d)\\s+)?)(\\d{4,5}\\-?\\d{4})"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func displayAlertMessage(messageToDisplay: String, isSuccessful: Bool)
    {
        let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            if isSuccessful == true {
                UserDefaults.standard.set(self.userIdCounter, forKey: "userId")
                UserDefaults.standard.set(self.txt_username.text, forKey: "username")
                UserDefaults.standard.set(self.txt_password.text, forKey: "password")
                UserDefaults.standard.set(self.txt_email.text, forKey: "email")
                UserDefaults.standard.set(self.txt_city.text, forKey: "city")
                UserDefaults.standard.set(self.txt_state.text, forKey: "state")
                UserDefaults.standard.set(self.txt_country.text, forKey: "country")
                UserDefaults.standard.set(self.txt_zip.text, forKey: "zip")
                UserDefaults.standard.set(self.txt_category.text, forKey: "category")
                UserDefaults.standard.set(false, forKey: "remember")
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
                self.present(nextViewController, animated:true, completion:nil)
            }
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
}
