//
//  OrdersTableViewController.swift
//  pinwork
//
//  Created by Pouyan on 7/16/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit
import SwiftyJSON
class OrdersTableViewController: UITableViewController {
    var services = [JSON]()
    let orderImages = ["home":"home2","office":"work3","garage":"windows2","carwash":"carwash2"]
    var isReservedOrder = false
    var loadingView : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(true, animated: false)

        self.tableView.separatorStyle = .none
        if isReservedOrder{
            self.navigationItem.title = "سفارش‌های رزرو"

        self.fetchReservedServices()
        }
        else{
            self.navigationItem.title = "سفارش‌های قبلی"

        self.fetchDoneServices()
        }
    }
    
  
   

 

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (28/100)*UIScreen.main.bounds.height
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
     
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return services.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! tableCell

        DispatchQueue.main.async
            {
                cell.backView.layer.cornerRadius = 10.0;
            cell.frontView.roundCorners([.topLeft, .bottomLeft], radius: 10)
                cell.backView.layer.shadowOffset = CGSize(width: 0, height: 3)
                cell.backView.layer.shadowOpacity = 0.8
                cell.backView.layer.shadowRadius = 4.0
                cell.backView.layer.shadowColor = self.getPinworkColors(color: 0).cgColor
                if self.services.count != 0 {
                    cell.orderTypeImage.image = UIImage(named: self.getProperImageName(for: self.services[indexPath.row]))
                    cell.serviceCodeLabel.text = self.services[indexPath.row]["service_code"].stringValue
                    cell.orderTypeLabel.text = self.getProperOrderLabel(for: self.services[indexPath.row])
                    cell.orderStartDateLabel.text = self.getProperStartDateLabel(for: self.services[indexPath.row])
                    cell.orderPrimaryAddress.text = self.services[indexPath.row]["address"].stringValue
                }
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isReservedOrder{
            performSegue(withIdentifier: "ReservedServiceDetailesWorkerSegue", sender: services[indexPath.row])
            
        }else{
            performSegue(withIdentifier: "DoneServiceDetailesWorkerSegue", sender: services[indexPath.row])

        }
    }
    func fetchDoneServices(){
        loadingView = displaySpinner(onView: self.view)
        APIClient.requestForDoneServices(rememberToken: getData(key: "rememberToken") as! String) { (response, error) in
            self.removeSpinner(spinner: self.loadingView)
            if response != nil{
                if self.tokenHasExpired(response!["respond"].intValue){
                    self.showTokenExpiredPopUp()
                }
                else{
                self.services = response!["data"]["services"].arrayValue
                if self.services.count > 0 {
                    self.tableView.restore()
                }else{
                    self.tableView.setEmptyMessage("برای شما تا کنون سفارشی ثبت نشده است")
                }
                self.tableView.reloadData()
            }}
            else{
                let retry = self.showNetworkRetryPopUp()
                retry.onDoneBlock = { result in
                    self.fetchDoneServices()
                    
                }
            }
        }
    }
    
    func fetchReservedServices(){
        loadingView = displaySpinner(onView: self.view)
        APIClient.requestForUserProfile(rememberToken: getData(key: "rememberToken") as! String) { (response, error) in
            self.removeSpinner(spinner: self.loadingView)
            if response != nil{
                if self.tokenHasExpired(response!["respond"].intValue){
                    self.showTokenExpiredPopUp()
                }
                else{
                self.services = response!["data"]["services"].arrayValue
                //print(self.services)
                if self.services.count > 0 {
                    self.tableView.restore()
                }else{
                    self.tableView.setEmptyMessage("برای شما تا کنون سفارشی ثبت نشده است")
                }
                self.tableView.reloadData()

            }}
            else{
                let retry = self.showNetworkRetryPopUp()
                retry.onDoneBlock = { result in
                    self.fetchDoneServices()
                    
                }
            }
        }
    }
    func getProperImageName(for service:JSON)->String{
        switch service["service_type"] {
        case "cleaning_work": //means just cleaning not cleaning work office
            return orderImages["office"]!
        case "cleaning_house":
            return orderImages["home"]!
        case "carwash":
            return orderImages["carwash"]!
        case "joints":
            return orderImages["garage"]!
        default:
            break
        }
return orderImages["home"]!
        
    }
    func getProperOrderLabel(for service:JSON)->String{
        switch service["service_type"] {
        case "cleaning_work": //means just cleaning not cleaning work office
             return "سرویس نظافت دفتر کار"
        case "cleaning_house":
            return "سرویس نظافت منزل"
        case "carwash":
            return "سرویس کارواش"
        case "joints":
            return "سرویس نظافت راه‌پله و پارکینگ"
        default:
            break
        }
        return "سرویس نظافت"
    }
    
    func getProperStartDateLabel(for service:JSON)->String{
        
        let startDateValues = service["default_start_date"].stringValue.split(separator: " ")
        let startDate = startDateValues[0]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: String(startDate))!
        return self.getProperDate(date: date) + " ساعت " + String(startDateValues[1]).convertToPersian()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier {
        case "DoneServiceDetailesWorkerSegue":

            if let destination = segue.destination as? DoneServiceDetailesViewController{
                destination.service = sender as! JSON
            }
        default:

            if let destination = segue.destination as? ReservedServiceDetailesViewController{
                destination.service = sender as! JSON
            }
        }
      
    }
    
}






class tableCell : UITableViewCell
{
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var serviceCodeLabel: UILabel!
    @IBOutlet weak var orderTypeLabel: UILabel!
    @IBOutlet weak var orderTypeImage: UIImageView!
    @IBOutlet weak var orderStartDateLabel: UILabel!
    @IBOutlet weak var orderPrimaryAddress: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        if selected{
            backView.backgroundColor = UIColor(red:55/255, green:216/255, blue:250/255, alpha:1.0)
            
            frontView.backgroundColor = UIColor.white
        }
        
        
    }
    
}
extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
    
    
extension UITableView {
    
    func setEmptyMessage(_ message:String) {
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        noDataLabel.text = message
        noDataLabel.font = UIFont(name: "IRAN SansMobile(NoEn)", size: 18.0)
        noDataLabel.numberOfLines = 0
        noDataLabel.textColor     = UIColor.lightGray
        noDataLabel.textAlignment = .center
        self.backgroundView  = noDataLabel
        
        self.backgroundView = noDataLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
        self.separatorStyle = .none
    }
}
