//
//  NotificationTableViewController.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 5/5/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit

class NotificationTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var notificationTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationTable.dataSource = self
        notificationTable.delegate = self
        
        notificationTable.tableFooterView = UIView()
        
        self.title = "Notification"
        
        let nibName = UINib(nibName: "PopupTableViewCell", bundle: nil)
        notificationTable.register(nibName, forCellReuseIdentifier: "popup_cell")
        
        let nibName2 = UINib(nibName: "SendNotificationTableViewCell", bundle: nil)
        notificationTable.register(nibName2, forCellReuseIdentifier: "email_cell")
        
        let nibName3 = UINib(nibName: "SendSMSTableViewCell", bundle: nil)
        notificationTable.register(nibName3, forCellReuseIdentifier: "sms_cell")
        
        let nibName4 = UINib(nibName: "ReminderTableViewCell", bundle: nil)
        notificationTable.register(nibName4, forCellReuseIdentifier: "reminder_cell")
        
        let nibName5 = UINib(nibName: "ReminderTimeTableViewCell", bundle: nil)
        notificationTable.register(nibName5, forCellReuseIdentifier: "reminder_time_cell")
        
        let nibName6 = UINib(nibName: "SoundTableViewCell", bundle: nil)
        notificationTable.register(nibName6, forCellReuseIdentifier: "sound_cell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "popup_cell", for: indexPath) as! PopupTableViewCell
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "email_cell", for: indexPath) as! SendNotificationTableViewCell
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sms_cell", for: indexPath) as! SendSMSTableViewCell
            return cell
        }
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reminder_cell", for: indexPath) as! ReminderTableViewCell
            return cell
        }
        else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reminder_time_cell", for: indexPath) as! ReminderTimeTableViewCell
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sound_cell", for: indexPath) as! SoundTableViewCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
