//
//  ServiceDetailesViewController.swift
//  pinwork
//
//  Created by Pouyan on 7/22/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//
import SwiftyJSON
import UIKit
import Kingfisher
class ReservedServiceDetailesViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    let defaultProimage = UIImage(named: "user")
   

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serviceDetaileWorkerService.isEmpty ? 0 : self.serviceDetaileWorkerService.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "ReservedServiceWorkerCell", for: indexPath) as! ReservedServiceDetaileWorkerViewCell
        cell.workerImage.kf.setImage(with: URL(string: "https://api.pinwork.co/storage/worker_profile/" + serviceDetaileWorkerService [indexPath.row]["picture"].stringValue)! ,  placeholder: defaultProimage)
            cell.workerRateNumberLabel.text = String( serviceDetaileWorkerService[indexPath.row]["rate_avg"].floatValue ).convertToPersian()
        cell.workerRatingStarView.value = CGFloat(serviceDetaileWorkerService[indexPath.row]["rate_avg"].floatValue)
        if serviceDetaileWorkerService[indexPath.row]["name"].stringValue.contains("درحال") || serviceDetaileWorkerService[indexPath.row]["lastname"].stringValue.contains("جستجو"){
            cell.searchingAnimationView.isHidden = true

        }else{
            cell.lottieSearchAnimation.isHidden = true
        }
            cell.workerFullNameLabel.text = serviceDetaileWorkerService [indexPath.row]["name"].stringValue + " " + serviceDetaileWorkerService[indexPath.row]["lastname"].stringValue
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return (28/100)*UIScreen.main.bounds.height
    }
     func numberOfSections(in tableView: UITableView) -> Int {

        
        return 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
  
    @IBOutlet weak var workerTableView: UITableView!
    
 

    @IBOutlet weak var serviceDetailWorkerHeightConstraints: NSLayoutConstraint!

    
    
    @IBOutlet weak var callForSupportButton: UIButton!
    
    @IBOutlet weak var cancelServiceButton: UIButton!
    
    @IBOutlet weak var serviceType: UILabel!
    
    
    @IBOutlet weak var neededServices: UILabel!
    
    @IBOutlet weak var serviceDate: UILabel!
    
    var animationView: UIView!
    var serviceDetaileWorkerService: JSON = []
    
    @IBOutlet weak var serviceStartTime: UILabel!

    @IBOutlet weak var phonePlace: UILabel!
    
    
    @IBOutlet weak var serviceAddress: UILabel!
    
    @IBOutlet weak var payPrice: UILabel!
    
    
    @IBOutlet weak var serviceImage: UIImageView!
    
    @IBAction func callForSupportClicked(_ sender: UIButton) {
        
    
            if let url = URL(string: "tel://02187700770"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
    }
    
    

    @IBAction func cancelServiceButton(_ sender: UIButton) {
        let retry = self.showAssurancePopUp(toshow: "آیا از لغو کردن این سفارش اطمینان دارید؟")
        retry.onDoneBlock = { result in
            if result{
                self.cancelService()
            }
        }
        
    }
    
    
    
    
    
    
    
    let orderImages = ["home":"home2","office":"work3","garage":"windows2","carwash":"carwash2"]
    var service = JSON()
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.workerTableView.delegate = self
       self.workerTableView.dataSource = self
        self.workerTableView.isScrollEnabled = false
    
        //workerTableView.separatorStyle = .none
        self.workerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        callForSupportButton.layer.cornerRadius = 8
        cancelServiceButton.layer.borderWidth = 1
        cancelServiceButton.layer.borderColor = getPinworkColors(color: 1).cgColor
        cancelServiceButton.layer.cornerRadius = 8
        callForSupportButton.layer.shadowColor = UIColor(red:0.02, green:0.29, blue:0.36, alpha:1.0).cgColor
        callForSupportButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        callForSupportButton.layer.shadowRadius = 2
        callForSupportButton.layer.shadowOpacity = 0.5
        
        cancelServiceButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        cancelServiceButton.layer.shadowRadius = 2
        cancelServiceButton.layer.shadowOpacity = 0.5
        self.navigationItem.title = service["service_code"].stringValue
        preFillContents()
        fillContents()
        
    }
  
    func preFillContents(){ //fill components from service type provided from previouse viewController
        serviceImage.image = UIImage(named: self.getProperImageName(for: self.service))
        serviceType.text = getProperOrderLabel(for: service)
        serviceAddress.text = service["address"].stringValue
        payPrice.text = service["price"].stringValue.convertEngNumToPersianNum() + " " + "تومان  "
        serviceDate.text = getProperDate(inputStringDate: service["default_start_date"].stringValue)
        serviceStartTime.text = String(service["default_start_date"].stringValue.components(separatedBy: " ")[1].dropLast(3)).convertToPersian()
        phonePlace.text = service["service_number"].stringValue.convertToPersian()
        neededServices.text = getProperNeededService(for: service).convertToPersian()
    }
    
    func fillContents(){ // get complete details from api get service details
        animationView = self.displaySpinner(onView: self.view)
        APIClient.serviceDatailes(rememberToken: self.getData(key: "rememberToken") as! String, requestParams: ["service_code":service["service_code"].stringValue, "service_type":getProperServiceName()]) { (respond, error) in
            if respond != nil{
                if self.tokenHasExpired(respond!["respond"].intValue){
                    self.showTokenExpiredPopUp()

                }else if self.checkRespondStatus(respond: respond!["respond"].intValue){
                    self.serviceDetaileWorkerService = respond!["data"]["service_worker"]
                    self.workerTableView.reloadData()
                    self.serviceDetailWorkerHeightConstraints.constant = (28/100)*UIScreen.main.bounds.height * CGFloat(self.serviceDetaileWorkerService.count) + CGFloat(50)
                }
         
            //debugPrint(self.serviceDetaileWorkerService)

            }else{
                debugPrint(error)
                let retry = self.showNetworkRetryPopUp()
                retry.onDoneBlock = { result in
                    self.fillContents()
                }
            }
            
            
            
            self.removeSpinner(spinner: self.animationView)

        }
        
    }
    func cancelService(){
        let requestParams = ["service_code":self.service["service_code"].stringValue,"service_type":getProperServiceName()]
        self.animationView = displaySpinner(onView: self.view)
        APIClient.cancelService(rememberToken: self.getData(key: "rememberToken") as! String, requestParams: requestParams) { (jsonRespond, error) in
            if jsonRespond != nil{
                if self.tokenHasExpired(jsonRespond!["respond"].intValue){
                    self.showTokenExpiredPopUp()
                }else if self.checkRespondStatus(respond: jsonRespond!["respond"].intValue){
                    let informUser = self.showInformUserPopUp(toshow: "سفارش  شما با شماره \n \(self.service["service_code"].stringValue)\n  با موفقیت لغو شد")
                    informUser.onDoneBlock = {
                        result in
                        self.popViewControllers(popViews: 2)
                    }
                }
            }else{
                let retry = self.showNetworkRetryPopUp()
                retry.onDoneBlock = { result in
                    self.cancelService()
                }
            }
            
            
            
            self.removeSpinner(spinner: self.animationView)
        }
    }
    func getProperImageName(for service:JSON)->String{
        switch service["service_type"].stringValue {
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
    func getProperServiceName()->String{
        switch service["service_type"].stringValue {
        case "cleaning_work": //means just cleaning not cleaning work office
           return "cleaning"
        case "carwash":
            return "carwash"
        case "joints":
            return "joints"
        default:
            break
        }
        return "cleaning"
    }
        
    
    
    func getProperNeededService(for service:JSON)->String{
        switch service["service_type"] {
        case "cleaning_work": //means just cleaning not cleaning work office
            if service["cleaning_type"] == "work"{
                return "سرویس نظافت دفتر کار"
            }
            else{
                return "نظافت داخل منزل\n" + calculateworkDuration(for:service)
            }
        case "carwash":
            return "سرویس کارواش"
        case "joints":
            return "سرویس نظافت راه‌پله و پارکینگ"
        default:
            break
        }
        return "سرویس نظافت"
    }
    func calculateworkDuration(for service:JSON)->String{
        let time1 = String(service["default_start_date"].stringValue.components(separatedBy: " ")[1].dropLast(3))
        let time2 = String(service["default_end_date"].stringValue.components(separatedBy: " ")[1].dropLast(3))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        
        let date1 = formatter.date(from: time1)!
        let date2 = formatter.date(from: time2)!
        
        let elapsedTime = date2.timeIntervalSince(date1)
        
        // convert from seconds to hours, rounding down to the nearest hour
        let hours = floor(elapsedTime / 60 / 60)
        
        // we have to subtract the number of seconds in hours from minutes to get
        // the remaining minutes, rounding down to the nearest minute (in case you
        // want to get seconds down the road)
        let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
        if minutes==0{
            return "\(Int(hours)) ساعت کار"

        }
        return "\(Int(hours)) ساعت و \(Int(minutes)) دقیقه کار"
    }
    }
    





