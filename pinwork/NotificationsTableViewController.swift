//
//  NotificationsTableViewController.swift
//  pinwork
//
//  Created by Pouyan on 8/3/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit
import SwiftyJSON
class NotificationsTableViewController: UITableViewController {

    var notifications = [JSON]()
    var loadingView : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(true, animated: false)
        
        self.tableView.separatorStyle = .none
        self.navigationItem.title = "اعلانیه‌ها"
        self.fetchNotifications()
    }
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (28/100)*UIScreen.main.bounds.height
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notifications.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableCell
        
        DispatchQueue.main.async
            {
                cell.backView.layer.cornerRadius = 10.0;
                cell.frontView.roundCorners([.topLeft, .bottomLeft], radius: 10)
                cell.backView.layer.shadowOffset = CGSize(width: 0, height: 3)
                cell.backView.layer.shadowOpacity = 0.8
                cell.backView.layer.shadowRadius = 4.0
                cell.backView.layer.shadowColor = self.getPinworkColors(color: 0).cgColor
                if self.notifications.count != 0 {
                   
                    cell.summaryLabel.text = self.notifications[indexPath.row]["summary"].stringValue
                    cell.dateLabel.text = String( self.notifications[indexPath.row]["persian_created_at"].stringValue.split(separator: " ")[0]).convertToPersian()
                    cell.timeLabel.text = String( self.notifications[indexPath.row]["persian_created_at"].stringValue.split(separator: " ")[1]).convertToPersian()
                    cell.contentLabel.text = self.notifications[indexPath.row]["content"].stringValue
                }
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // performSegue(withIdentifier: "io", sender: self)
    }
    func fetchNotifications(){
        loadingView = displaySpinner(onView: self.view)
        APIClient.requestForNotifications(rememberToken: getData(key: "rememberToken") as! String) { (response, error) in
            self.removeSpinner(spinner: self.loadingView)
            if response != nil{
                if self.tokenHasExpired(response!["respond"].intValue){
                    self.showTokenExpiredPopUp()
                }
                else{
                    self.notifications = response!["data"]["notifications"].arrayValue
                    if self.notifications.count > 0 {
                        self.tableView.restore()
                    }else{
                        self.tableView.setEmptyMessage("هیچ اعلانی جهت نمایش وجود ندارد")
                    }
                    self.tableView.reloadData()
                }}
            else{
                let retry = self.showNetworkRetryPopUp()
                retry.onDoneBlock = { result in
                    self.fetchNotifications()
                    
                }
            }
        }
    }
    

  
    
 
    
    
}






class NotificationTableCell : UITableViewCell
{
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected{
            backView.backgroundColor = UIColor(red:55/255, green:216/255, blue:250/255, alpha:1.0)
            
            frontView.backgroundColor = UIColor.white
            headerView.backgroundColor =  UIColor(red:0.02, green:0.29, blue:0.36, alpha:1.0)
        }
        
        
    }
    
}


