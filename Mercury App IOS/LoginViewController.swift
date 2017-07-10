//
//  LoginViewController.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 4/8/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: BaseViewController, UITextFieldDelegate {
    @IBOutlet weak var txt_username: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var btn_remember: UIButton!
    
    let eyeIcon = UIButton()
    var iconClick : Bool!
    var isRemember:Bool!
    var userId: Int = 0
    
    @IBAction func rememberTxtClicked(_ sender: UIButton) {
        if isRemember == true {
            isRemember = false
        }
        else {
            isRemember = true
        }
        
        if isRemember == true {
            btn_remember.setBackgroundImage(#imageLiteral(resourceName: "checked"), for: UIControlState.normal)
            UserDefaults.standard.set(true, forKey: "remember")
        }
        else {
            btn_remember.setBackgroundImage(#imageLiteral(resourceName: "unchecked"), for: UIControlState.normal)
            UserDefaults.standard.set(false, forKey: "remember")
        }
    }
    @IBAction func rememberClicked(_ sender: UIButton) {
        if isRemember == true {
            isRemember = false
        }
        else {
            isRemember = true
        }
        
        if isRemember == true {
            sender.setBackgroundImage(#imageLiteral(resourceName: "checked"), for: UIControlState.normal)
            UserDefaults.standard.set(true, forKey: "remember")
        }
        else {
            sender.setBackgroundImage(#imageLiteral(resourceName: "unchecked"), for: UIControlState.normal)
            UserDefaults.standard.set(false, forKey: "remember")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        iconClick = true
        eyeIcon.addTarget(self, action: #selector(togglePassword), for: .touchUpInside)
        eyeIcon.frame = CGRect(x: txt_password.frame.size.width-25, y: 0, width: 25, height: 25)
        eyeIcon.setBackgroundImage(#imageLiteral(resourceName: "visible"), for: .normal)
        txt_password.rightViewMode = .always
        txt_password.rightView = eyeIcon
        isRemember = UserDefaults.standard.object(forKey: "remember") as? Bool
        txt_username.delegate = self
        txt_password.delegate = self
        txt_username.text = ""
        txt_password.text = ""
        if isRemember == true {
            btn_remember.setBackgroundImage(#imageLiteral(resourceName: "checked"), for: UIControlState.normal)
        }
        else {
            btn_remember.setBackgroundImage(#imageLiteral(resourceName: "unchecked"), for: UIControlState.normal)
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.context //appDelegate.persistentContainer.viewContext
        
        let requestUser = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        requestUser.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(requestUser)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let user_id = result.value(forKey: "userId") as? Int32 {
                        userId = Int(user_id)
                    }
                    if let rusername = result.value(forKey: "username") as? String {
                        if isRemember == true {
                            txt_username.text = rusername
                        }
                    }
                    if let rpassword = result.value(forKey: "password") as? String {
                        if isRemember == true {
                            txt_password.text = rpassword
                        }
                    }
                }
            }
        }
        catch {
            //print("Could not fetch data")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txt_username {
            txt_password.becomeFirstResponder()
        }
        else if textField == txt_password {
            txt_password.resignFirstResponder()
        }
        
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    @IBAction func loginAction(_ sender: UIButton) {
        let username : String? = UserDefaults.standard.object(forKey: "username") as? String
        let password : String? = UserDefaults.standard.object(forKey: "password") as? String
        if txt_username.text == username && txt_password.text == password {
            UserDefaults.standard.set(userId, forKey: "userId")
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
        else {
            displayAlertMessage(messageToDisplay: "Username / Password is incorrect. \n Try Again!")
        }
    }
    
    func displayAlertMessage(messageToDisplay: String)
    {
        let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            //self.txt_password.text = ""
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func togglePassword() {
        if(iconClick == true) {
            txt_password.isSecureTextEntry = false
            iconClick = false
            eyeIcon.setBackgroundImage(#imageLiteral(resourceName: "invisible"), for: .normal)
        } else {
            txt_password.isSecureTextEntry = true
            iconClick = true
            eyeIcon.setBackgroundImage(#imageLiteral(resourceName: "visible"), for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
