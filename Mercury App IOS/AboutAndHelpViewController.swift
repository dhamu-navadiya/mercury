//
//  AboutAndHelpViewController.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 5/5/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit

class AboutAndHelpViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var aboutandhelpview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutandhelpview.dataSource = self
        aboutandhelpview.delegate = self
        
        self.title = "About and Help"
        
        //print("hello")
        
        aboutandhelpview.tableFooterView = UIView()
        
        let nibName = UINib(nibName: "WithSubtitleTableViewCell", bundle: nil)
        aboutandhelpview.register(nibName, forCellReuseIdentifier: "withsubtitle_cell")
        
        let nibName2 = UINib(nibName: "WithoutSubtitleTableViewCell", bundle: nil)
        aboutandhelpview.register(nibName2, forCellReuseIdentifier: "withoutsubtitle_cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "withsubtitle_cell", for: indexPath) as! WithSubtitleTableViewCell
            
            cell.lbl_title.text = "FAQ"
            cell.lbl_subtitle.text = "Need help?"
            
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "withsubtitle_cell", for: indexPath) as! WithSubtitleTableViewCell
            
            cell.lbl_title.text = "Feedback"
            cell.lbl_subtitle.text = "Send suggestions to us"
            
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "withsubtitle_cell", for: indexPath) as! WithSubtitleTableViewCell
            
            cell.lbl_title.text = "Contact us"
            cell.lbl_subtitle.text = "Any Questions?"
            
            return cell
        }
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "withoutsubtitle_cell", for: indexPath) as! WithoutSubtitleTableViewCell
            
            cell.lbl_title.text = "Terms & Condition"
            
            return cell
        }
        else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "withoutsubtitle_cell", for: indexPath) as! WithoutSubtitleTableViewCell
            
            cell.lbl_title.text = "Privacy Policy"
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "withoutsubtitle_cell", for: indexPath) as! WithoutSubtitleTableViewCell
            
            cell.lbl_title.text = "About"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
