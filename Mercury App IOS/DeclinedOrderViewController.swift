//
//  DeclinedOrderViewController.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 4/8/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit
import CoreData

class DeclinedOrderViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var declinedOrderTableView: UITableView!

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
    
    @IBAction func searchOrders(_ sender: UIBarButtonItem) {
        if isSearchIconClicked == false {
            isSearchIconClicked = true
        }
        else {
            isSearchIconClicked = false
        }
        showHideSearchBar()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        showHideSearchBar()
        self.title = "Declined Orders"
        
        declinedOrderTableView.dataSource = self
        declinedOrderTableView.delegate = self
        
        declinedOrderTableView.tableFooterView = UIView()
        
        let context = appDelegate.context //appDelegate.persistentContainer.viewContext
        
        requestOrder.returnsObjectsAsFaults = false
        requestCustomer.returnsObjectsAsFaults = false
        
        requestOrder.predicate = NSPredicate(format: "order_status == %@", "Declined")
        
        do {
            let results = try context.fetch(requestOrder)
            
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
        
        let nibName = UINib(nibName: "DeclinedTableViewCell", bundle: nil)
        declinedOrderTableView.register(nibName, forCellReuseIdentifier: "DeclinedOrderCell")
    }
    
    func showHideSearchBar() {
        if isSearchIconClicked == true {
            searchBar.showsCancelButton = false
            searchBar.placeholder = "Search"
            searchBar.delegate = self
            searchBar.alpha = 0.0
            self.navigationItem.titleView = searchBar
        }
        else {
            self.navigationItem.titleView = nil
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
        self.declinedOrderTableView.reloadData()
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
            backgroundImage.image = #imageLiteral(resourceName: "declined_order")
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeclinedOrderCell", for: indexPath) as! DeclinedTableViewCell
        
        cell.lbl_init.layer.masksToBounds = true
        cell.lbl_init.layer.cornerRadius = cell.lbl_init.frame.height/2
        
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
        let declinedOrderDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeclinedDetail") as! DeclinedDetailViewController
        declinedOrderDetailsVC.stringPassed = receiptLblData[indexPath.row]
        self.navigationController?.pushViewController(declinedOrderDetailsVC, animated: true)
        self.declinedOrderTableView.deselectRow(at: indexPath, animated: true)
    }
}
