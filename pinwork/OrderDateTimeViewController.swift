//
//  OrderDateTimeViewController.swift
//  pinwork
//
//  Created by Pouyan on 6/16/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit
import Lottie

class OrderDateTimeViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var priceLabelConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var timeIntervalPickerButton: UIButton!
    
    @IBOutlet weak var dateTimePickerButton: UIButton!
    
    var isFailed = false

    
    var nextLevelButton : UIButton?
    var retryButton : UIButton?

    enum action{
        case officeCleaning
        case homeCleaning
        case garageCleaning
    }
    var orderType = action.homeCleaning
    var OrderTillNow :Dictionary<String,Any> = [:]
    var startTime = [String]()
    var timeInterval = [String]()
    var selectedStartTime = Int()
    var selectedTimeInterval = Int()
    var selectedStartDate = Date()
    let myLocale = Locale(identifier: "fa_IR")
    var calendar = Calendar(identifier: .persian)

    var startTimeLimit = 0
    var timeIntervalLimit = 0
    
    @IBAction func timeIntervalClicked(_ sender: UIButton) {
        let title = "انتخاب مدت زمان کار"
        let pickerController = getPickerViewOneComponent(attributes: timeInterval, title: title)
        pickerController.limit = timeIntervalLimit
        self.present(pickerController, animated: true)
        pickerController.onDoneBlock = { result in
            self.selectedTimeInterval = result
            self.timeIntervalPickerButton.setTitle( self.timeInterval[result], for: .normal)
            self.startTimeLimit = self.getStartTimeLimit(result: result)
            self.goForEstimate()
        }
    }
    
    @IBAction func dateTimePickerClicked(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let popUpDateTime = storyBoard.instantiateViewController(withIdentifier: "datepickerpopup") as! PopUpDatePickerViewController
        popUpDateTime.validDates = getValidDatesForType()
        popUpDateTime.validTimes = startTime
        popUpDateTime.limit = startTimeLimit
        popUpDateTime.modalTransitionStyle = .crossDissolve
        popUpDateTime.isModalInPopover = true
        popUpDateTime.modalPresentationStyle = .overCurrentContext
        self.present(popUpDateTime, animated: true)
        popUpDateTime.onDoneBlock = { date , time in
            let _startTime = self.startTime[time]
            self.selectedStartDate = date
            self.selectedStartTime = time
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            formatter.dateFormat = "yyyy-MM-dd"
            let stringTime = formatter.string(from: date)
            self.OrderTillNow["default_start_date"] = (stringTime + " " + _startTime.convertToEnglish() + ":00")
            self.dateTimePickerButton.setTitle(self.getProperDate(date: date) + " ساعت " + _startTime, for: .normal)
            self.timeIntervalLimit = self.getTimeIntervalLimit(result: time)
            self.goForEstimate()
            
        }
        
        
        
    }
    
    func getValidDatesForType()->[Date]{
        var date = Date()
        var dateComponent = DateComponents()
        var tempDateArray = [Date]()
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        if hour == 20 && minutes >= 59{
            date = Calendar.current.date(byAdding: dateComponent, to: date)!
            
        }
        else if hour >= 21{
            date = Calendar.current.date(byAdding: dateComponent, to: date)!
            
        }
        
        dateComponent.day = 1
        for _ in 1...14{
            date = Calendar.current.date(byAdding: dateComponent, to: date)!
            tempDateArray.append(date)
            
        }
        return tempDateArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch orderType{
        case .officeCleaning:
            print("office")
            prepareSetting()
        case .homeCleaning:
            print("home")
            prepareSetting()
        case .garageCleaning:
            print("garage")
       
        }
        setting()
    }
  

    func setting(){
        dateTimePickerButton.layer.borderWidth = 1
        dateTimePickerButton.layer.borderColor = getPinworkColors(color: 1).cgColor
        dateTimePickerButton.layer.cornerRadius = 8
        timeIntervalPickerButton.layer.borderWidth = 1
        timeIntervalPickerButton.layer.borderColor = getPinworkColors(color: 1).cgColor
        timeIntervalPickerButton.layer.cornerRadius = 8
        priceLabel.clipsToBounds = true
        priceLabel.layer.cornerRadius = 8
        //priceLabel.text! = currentPrice!
        
        nextLevelButton = getUIBarButtonItemForNextLevel(title:"مرحله بعدی", image: "move-to-next")
        retryButton = getUIBarButtonItemForRetry(title:" تلاش مجدد ", image: "refresh")
        
        var items = [UIBarButtonItem]()
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        items.append( UIBarButtonItem(customView: nextLevelButton!))
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        nextLevelButton!.addTarget(self, action: #selector(self.nextLevelClicked), for: .touchUpInside)
        retryButton!.addTarget(self, action: #selector(self.nextLevelClicked), for: .touchUpInside)
        self.toolbarItems = items
        
    }
    func prepareSetting(){
        switch orderType {
        case .officeCleaning:
            self.navigationItem.title =  "نظافت دفتر"

        startTime = ["۸:۰۰","۸:۳۰","۹:۰۰","۹:۳۰","۱۰:۰۰","۱۰:۳۰","۱۱:۰۰","۱۱:۳۰","۱۲:۰۰","۱۲:۳۰","۱۳:۰۰","۱۳:۳۰","۱۴:۰۰","۱۴:۳۰","۱۵:۰۰","۱۵:۳۰","۱۶:۰۰","۱۶:۳۰","۱۷:۰۰","۱۷:۳۰","۱۸:۰۰","۱۸:۳۰","۱۹:۰۰"]
        timeInterval = ["۱ ساعت","۲ ساعت","۳ ساعت","۴ ساعت","۵ ساعت","۶ ساعت","۷ ساعت","۸ ساعت","۹ ساعت","۱۰ ساعت","۱۱ ساعت"]
        
        case .homeCleaning:
            self.navigationItem.title = "نظافت منزل"

                startTime = ["۹:۰۰","۹:۳۰","۱۰:۰۰","۱۰:۳۰","۱۱:۰۰","۱۱:۳۰","۱۲:۰۰","۱۲:۳۰","۱۳:۰۰","۱۳:۳۰","۱۴:۰۰","۱۴:۳۰","۱۵:۰۰","۱۵:۳۰","۱۶:۰۰","۱۶:۳۰","۱۷:۰۰","۱۷:۳۰","۱۸:۰۰","۱۸:۳۰","۱۹:۰۰"]
                timeInterval = ["۱ ساعت","۲ ساعت","۳ ساعت","۴ ساعت","۵ ساعت","۶ ساعت","۷ ساعت","۸ ساعت","۹ ساعت","۱۰ ساعت","۱۱ ساعت"]
            
        default:
            break
        }
        timeIntervalLimit = timeInterval.count
        startTimeLimit = startTime.count
    }
    func isFullyFilled()->Bool{
        if timeIntervalPickerButton.currentTitle == "انتخاب کنید" || dateTimePickerButton.currentTitle == "انتخاب کنید"{
            return false
        }
        return true
    }
    @objc func nextLevelClicked(){
        if isFailed{
            goForEstimate()
        }
        else{
            if isFullyFilled(){
                self.performSegue(withIdentifier: "segueToWorkerPicker", sender: self)
            }
            else{
                showToast(message: "لطفا تمامی موراد خواسته شده را تکمیل نمایید.")
            }
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! WorkerPickerViewController
        destination.currentPrice = priceLabel.text
        destination.OrderTillNow = self.OrderTillNow

    }
    func getStartTimeLimit(result: Int)-> Int{
        return 2*(startTime.count/2 - result )
        }
    func getTimeIntervalLimit(result: Int)->Int{
        return startTime.count/2 - (result+1)/2
    }
    
    func goForEstimate(){
        if self.isFullyFilled(){
            self.showCostEstimateProgress()

            self.priceLabelConstraint.constant = -30
            UIView.animate(withDuration: 0.6,animations: {
                self.view.layoutIfNeeded()
            })
            
            prepareRequest()
            APIClient.estimateHomeOrOfficeCleaningPrice(requestArray: OrderTillNow, completionHandler: { (response, error) in
                self.hideCostEstimateProgress()
                if response != nil{
                    self.isFailed = false
                    self.toolbarItems?.insert(UIBarButtonItem(customView: self.nextLevelButton!), at: 1)
                    self.priceLabel.text! = "برآورد قیمت : " +
                        String((response!["data"] as! NSDictionary)["price"] as! Int).convertToPersian() + " تومان "
                    self.priceLabelConstraint.constant = 10
                    UIView.animate(withDuration: 0.9,animations: {
                        self.view.layoutIfNeeded()
                    })
                }else{
                    self.isFailed = true
                    self.toolbarItems?.insert(UIBarButtonItem(customView: self.retryButton!), at: 1)

                }
            })
            
            
        }
        
        
    }
    func prepareRequest(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.dateFormat = "yyyy-MM-dd"
        let stringTime = formatter.string(from: selectedStartDate)
        if selectedStartTime+2*(selectedTimeInterval+1) >= startTime.count{
            OrderTillNow["default_end_date"] = (stringTime + " " + "20:00")
            
        }
        else{
            OrderTillNow["default_end_date"] = (stringTime + " " + startTime[selectedStartTime+2*(selectedTimeInterval+1)].convertToEnglish() + ":00")
        }
        OrderTillNow["worker_count_request"] = 1
        OrderTillNow["man_count_request"] = 0
        OrderTillNow["woman_count_request"] = 0
        //let token = self.getData(key: "rememberToken") as! String
        let token2 = "fced86ff2ba6060a396d18639974900ff425352f"
        OrderTillNow["remember_token"] = token2
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
        
    }
    

   

}
