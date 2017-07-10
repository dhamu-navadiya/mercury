//
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32, boolValue: Bool)
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /**
     *  Array to display menu options
     */
    @IBOutlet var tblMenuOptions : UITableView!
    
    /**
     *  Transparent button to hide menu
     */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    /**
     *  Array containing menu options
     */
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    /**
     *  Menu button which was tapped to display the menu
     */
    var btnMenu : UIButton!
    
    /**
     *  Delegate of the MenuVC
     */
    var delegate : SlideMenuDelegate?
    
    var isArrowClicked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMenuOptions.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeDataSource(_ sender: UIButton) {
        arrayMenuOptions.removeAll()
        
        if isArrowClicked == true {
            isArrowClicked = false
        }
        else if isArrowClicked == false {
            isArrowClicked = true
        }
        
        let baseViewInstance = BaseViewController()
        
        if isArrowClicked == true {
            sender.setImage(#imageLiteral(resourceName: "spinner_up"), for: .normal)
            arrayMenuOptions.append(["title":"Edit User", "icon":"edit_profile"])
            baseViewInstance.changeBoolForArrowClick(isArrowClick: true)
        }
        else if isArrowClicked == false {
            sender.setImage(#imageLiteral(resourceName: "spinner"), for: .normal)
            arrayMenuOptions.append(["title":"New Order", "icon":"new_order"])
            arrayMenuOptions.append(["title":"My Orders", "icon":"my_orders"])
            arrayMenuOptions.append(["title":"Sent Order", "icon":"sent_order"])
            arrayMenuOptions.append(["title":"Declined Order", "icon":"declined_order"])
            arrayMenuOptions.append(["title":"Overdue Order", "icon":"overdue_order"])
            arrayMenuOptions.append(["title":"Order Status", "icon":"order_status"])
            arrayMenuOptions.append(["title":"Search Order", "icon":"search_order"])
            arrayMenuOptions.append(["title":"Offer & Promotion", "icon":"offer_promotion"])
            arrayMenuOptions.append(["title":"Settings", "icon":"settings"])
            arrayMenuOptions.append(["title":"Add User", "icon":"add_user"])
            baseViewInstance.changeBoolForArrowClick(isArrowClick: false)
        }
        
        tblMenuOptions.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions(){
        arrayMenuOptions.append(["title":"New Order", "icon":"new_order"])
        arrayMenuOptions.append(["title":"My Orders", "icon":"my_orders"])
        arrayMenuOptions.append(["title":"Sent Order", "icon":"sent_order"])
        arrayMenuOptions.append(["title":"Declined Order", "icon":"declined_order"])
        arrayMenuOptions.append(["title":"Overdue Order", "icon":"overdue_order"])
        arrayMenuOptions.append(["title":"Order Status", "icon":"order_status"])
        arrayMenuOptions.append(["title":"Search Order", "icon":"search_order"])
        arrayMenuOptions.append(["title":"Offer & Promotion", "icon":"offer_promotion"])
        arrayMenuOptions.append(["title":"Settings", "icon":"settings"])
        arrayMenuOptions.append(["title":"Add User", "icon":"add_user"])
        
        tblMenuOptions.reloadData()
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index, boolValue: isArrowClicked)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        
        imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
}
