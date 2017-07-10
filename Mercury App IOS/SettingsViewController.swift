//
//  SettingsViewController.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 4/8/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var settingTableView: UITableView!

    let settingsItemArray = ["setting_order", "setting_tax_rupee", "setting_notification", "setting_storage", "setting_invite", "setting_help"]
    let settingsTitleArray = ["Receipt Number", "Tax Rules", "Notification", "Save Images In Gallery", "Invite a friend", "About and help"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        
        settingTableView.dataSource = self
        settingTableView.delegate = self
        
        settingTableView.tableFooterView = UIView()
        
        let nibName = UINib(nibName: "SettingsTableViewCell", bundle: nil)
        settingTableView.register(nibName, forCellReuseIdentifier: "settings_cell")
        
        let nibName2 = UINib(nibName: "SettingReceiptCell", bundle: nil)
        settingTableView.register(nibName2, forCellReuseIdentifier: "receipt_cell")
        
        let nibName3 = UINib(nibName: "ImgGalleryCell", bundle: nil)
        settingTableView.register(nibName3, forCellReuseIdentifier: "img_gallery_cell")
        isChecked = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsItemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "receipt_cell", for: indexPath) as! SettingReceiptCell
            
            cell.img_setting_receipt.image = #imageLiteral(resourceName: "setting_order")
            cell.lbl_receipt_title.text = settingsTitleArray[indexPath.item]
            cell.lbl_receipt_subtitle.text = "Set your receipt number index"
            
            return cell
        }
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "img_gallery_cell", for: indexPath) as! ImgGalleryCell
            
            cell.img_gall_img.image = UIImage(named: settingsItemArray[indexPath.item])
            cell.lbl_img_gall.text = settingsTitleArray[indexPath.item]
            cell.btn_check.setBackgroundImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            cell.btn_check.addTarget(self, action: #selector(handleChecked), for: .touchUpInside)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "settings_cell", for: indexPath) as! SettingsTableViewCell
            
            cell.initSettingsData(settingsItemArray[indexPath.item], title: settingsTitleArray[indexPath.item])
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let receiptPopupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReceiptPopup") as! ReceiptPopupViewController
            self.navigationController?.present(receiptPopupViewController, animated: true, completion: nil)
            self.settingTableView.deselectRow(at: indexPath, animated: true)
        }
        else if indexPath.row == 1 {
            let taxRulesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaxRules") as! TaxRulesViewController
            self.navigationController?.pushViewController(taxRulesVC, animated: true)
            self.settingTableView.deselectRow(at: indexPath, animated: true)
        }
        else if indexPath.row == 2 {
            let notificationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Notification") as! NotificationTableViewController
            self.navigationController?.pushViewController(notificationVC, animated: true)
            self.settingTableView.deselectRow(at: indexPath, animated: true)
        }
        else if indexPath.row == 5 {
            let aboutVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutAndHelp") as! AboutAndHelpViewController
            self.navigationController?.pushViewController(aboutVC, animated: true)
            self.settingTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    var isChecked:Bool!
    
    func handleChecked(sender: UIButton) {
        if isChecked == true {
            isChecked = false
        }
        else {
            isChecked = true
        }
        
        if isChecked == true {
            sender.setBackgroundImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        }
        else {
            sender.setBackgroundImage(#imageLiteral(resourceName: "checked"), for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
