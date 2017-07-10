//
//  DeliveredOrderViewController.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 4/18/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit
import CoreData

class DeliveredOrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var deliveredOrderTableView: UITableView!

    var initialLblData:[Character] = []
    var receiptLblData:[String] = []
    var dateLblData:[String] = []
    var customerLblData:[String] = []
    
    let searchBar = UISearchBar()
    
    var isSearchIconClicked = false
    
    var counter = 0
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let requestOrder = NSFetchRequest<NSFetchRequestResult>(entityName: "Order_master")
    let requestCustomer = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
    
    var tempOrderId = ""
    var searchActive : Bool = false
    var orderFilter:[Orders] = []
    var filtered:[Orders] = []
    var strReceiptNo: String = ""
    var strCustomerName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showHideSearchBar()
        
        let colorNormal : UIColor = UIColor.init(red: 0.7, green: 0.9, blue: 0.98, alpha: 1.0)
        let colorSelected : UIColor = UIColor.white
        let titleFontAll : UIFont = UIFont(name: "HelveticaNeue-Medium", size: 12.0)!
        
        let attributesNormal = [
            NSForegroundColorAttributeName : colorNormal,
            NSFontAttributeName : titleFontAll
        ]
        
        let attributesSelected = [
            NSForegroundColorAttributeName : colorSelected,
            NSFontAttributeName : titleFontAll
        ]
        
        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes (attributesSelected, for: .selected)
        
        UITabBar.appearance().barTintColor = UIColor.init(red: 0.19, green: 0.65, blue: 0.9, alpha: 1.0)
        
        self.tabBarController?.navigationItem.title = "Delivered Orders"
        
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchOrders))
        
        deliveredOrderTableView.dataSource = self
        deliveredOrderTableView.delegate = self
        
        deliveredOrderTableView.tableFooterView = UIView()
        
        let nibName = UINib(nibName: "DeliveredTableViewCell", bundle: nil)
        deliveredOrderTableView.register(nibName, forCellReuseIdentifier: "DeliveredCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadData()
    }
    
    func loadData() {
        let context = appDelegate.context //appDelegate.persistentContainer.viewContext
        
        requestOrder.returnsObjectsAsFaults = false
        requestCustomer.returnsObjectsAsFaults = false
        
        requestOrder.predicate = NSPredicate(format: "order_status == %@", "Delivered")
        
        do {
            let results = try context.fetch(requestOrder)
            
            tempOrderId = ""
            self.receiptLblData.removeAll()
            self.customerLblData.removeAll()
            self.initialLblData.removeAll()
            self.dateLblData.removeAll()
            self.orderFilter.removeAll()
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let receiptData = result.value(forKey: "order_id") as? String {
                        if tempOrderId != receiptData {
                            receiptLblData.append(receiptData)
                            strReceiptNo = receiptData
                            tempOrderId = receiptData
                            if let customerId = result.value(forKey: "customer_id") as? Int32 {
                                do {
                                    requestCustomer.predicate = NSPredicate(format: "customer_id == %@", "\(customerId)")
                                    let custResults = try context.fetch(requestCustomer)
                                    
                                    if custResults.count > 0 {
                                        for custResult in custResults as! [NSManagedObject] {
                                            if var custName = custResult.value(forKey: "customer_name") as? String {
                                                strCustomerName = custName
                                                custName = custName.capitalized
                                                customerLblData.append(custName)
                                                let firstChar = custName[custName.startIndex]
                                                initialLblData.append(firstChar)
                                            }
                                        }
                                    }
                                }
                                catch {
                                    //print("Could not fetch data for customer")
                                }
                            }
                            if let orderDate = result.value(forKey: "customer_issue_date") as? NSDate {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "dd/MM/yyyy"
                                let date = dateFormatter.string(from: orderDate as Date)
                                dateLblData.append(date)
                            }
                            let newData =  Orders(receiptNo: strReceiptNo, custName: strCustomerName)
                            self.orderFilter.append(newData)
                        }
                    }
                }
            }
        }
        catch {
            //print("Could not fetch data for orders")
        }
    }
    
    func searchOrders() {
        if isSearchIconClicked == false {
            isSearchIconClicked = true
        }
        else {
            isSearchIconClicked = false
        }
        showHideSearchBar()
    }
    
    func showHideSearchBar() {
        if isSearchIconClicked == true {
            searchBar.showsCancelButton = false
            searchBar.placeholder = "Search"
            searchBar.delegate = self
            searchBar.alpha = 0.0
            self.tabBarController?.navigationItem.titleView = searchBar
        }
        else {
            self.tabBarController?.navigationItem.titleView = nil
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //let result = orderFilter.filter({ $0.receiptNoStr.range(of: searchText) != nil || $0.customerNameStr.range(of: searchText) != nil })
        filtered = orderFilter.filter({ (orders) -> Bool in
            return (orders.receiptNoStr.lowercased().range(of: searchText.lowercased()) != nil || orders.customerNameStr.lowercased().range(of: searchText.lowercased()) != nil)
        })
        //filtered = result
        //print(filtered)
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.deliveredOrderTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows: Int = 0
        
        if(searchActive) {
            numberOfRows = filtered.count
        }
        else {
            numberOfRows = receiptLblData.count
        }
        if numberOfRows > 0 {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        }
        else {
            let tbl_backgroundView = UIView()
            let tbl_backgroundImgView = UIView()
            let tbl_backgroundLblView = UIView()
            
            tbl_backgroundView.addSubview(tbl_backgroundImgView)
            tbl_backgroundView.addSubview(tbl_backgroundLblView)
            
            var backgroundImage : UIImageView
            backgroundImage  = UIImageView(frame: CGRect(x: (tableView.bounds.width/2)-55, y: (tableView.bounds.height/2)-120, width: 110, height: 110))
            backgroundImage.image = #imageLiteral(resourceName: "delivered")
            
            tbl_backgroundImgView.addSubview(backgroundImage)
            
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "There are no orders here"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            
            tbl_backgroundLblView.addSubview(noDataLabel)
            
            tableView.backgroundView  = tbl_backgroundView
            tableView.separatorStyle = .none
        }
        return numberOfRows;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        counter = counter + 1
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveredCell", for: indexPath) as! DeliveredTableViewCell
        
        cell.lbl_initial.layer.masksToBounds = true
        cell.lbl_initial.layer.cornerRadius = cell.lbl_initial.frame.height/2
        
        if(searchActive){
            if filtered.count > 0 {
                cell.initCellData(initialLblData[indexPath.row], receiptLbl: filtered[indexPath.row].receiptNoStr, dateLbl: dateLblData[indexPath.row], customerLbl: filtered[indexPath.row].customerNameStr)
            }
            else {
                cell.initCellData(initialLblData[indexPath.row], receiptLbl: receiptLblData[indexPath.row], dateLbl: dateLblData[indexPath.row], customerLbl: customerLblData[indexPath.row])
            }
            
        } else {
            cell.initCellData(initialLblData[indexPath.row], receiptLbl: receiptLblData[indexPath.row], dateLbl: dateLblData[indexPath.row], customerLbl: customerLblData[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deliveredOrderDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeliveredDetail") as! DeliveredDetailViewController
        deliveredOrderDetailsVC.stringPassed = receiptLblData[indexPath.row]
        self.navigationController?.pushViewController(deliveredOrderDetailsVC, animated: true)
        self.deliveredOrderTableView.deselectRow(at: indexPath, animated: true)
    }
}
