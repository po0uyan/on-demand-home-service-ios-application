//
//  ParkingOrderViewController.swift
//  pinwork
//
//  Created by Pouyan on 6/22/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit

class ParkingOrderViewController: UIViewController {

    var order = Order()
    @IBOutlet var choosingButtons: [UIButton]!
    
    @IBOutlet weak var priceConstraint: NSLayoutConstraint!
    var nextLevelButton : UIButton?
    var retryButton : UIButton?
    var timeInterval = 0
    var isFailed = false
    @IBOutlet weak var priceLabel: UILabel!
    @IBAction func yardCleaningChanged(_ sender: UISwitch) {
        if sender.isOn{
            self.order.orderTillNow["yard_cleaning"] = 1

        }
        else{
            self.order.orderTillNow["yard_cleaning"] = 0

        }
        self.goForEstimate()

    }
    
    @IBAction func windowCleaningChanged(_ sender: UISwitch) {
        if sender.isOn{
            self.order.orderTillNow["window_cleaning"] = 1

        }
        else{
            self.order.orderTillNow["window_cleaning"] = 0

        }
        self.goForEstimate()

    }
    
    @IBAction func parkingCleaningChanged(_ sender: UISwitch) {
        if sender.isOn{
            self.order.orderTillNow["parking_cleaning"] = 1
        }
        else{
            self.order.orderTillNow["parking_cleaning"] = 0

        }
        self.goForEstimate()

    }
    

    @IBAction func roofCleaningChanged(_ sender: UISwitch) {
        if sender.isOn{
            self.order.orderTillNow["roof_cleaning"] = 1

        }
        else{
            self.order.orderTillNow["roof_cleaning"] = 0

        }
        self.goForEstimate()

    }
    
    
    
    @IBAction func flourCountClicked(_ sender: UIButton) {
        let attributes = ["۱ طبقه","۲ طبقه","۳ طبقه","۴ طبقه","۵ طبقه","۶ طبقه","۷ طبقه"]
        let title = "انتخاب تعداد طبقات"
        let pickerController = getPickerViewOneComponent(attributes: attributes, title: title)
        pickerController.limit = attributes.count
        self.present(pickerController, animated: true)
        pickerController.onDoneBlock = { result in
            self.choosingButtons[0].setTitle(attributes[result],for: .normal)
            self.self.order.orderTillNow["floor_count"] = result+1
            self.goForEstimate()

        }

    }
    
    @IBAction func unitInFlourClicked(_ sender: UIButton) {
        let attributes = [" ۱ واحد","۲ واحد","۳ واحد","۴ واحد"]
        let title = "انتخاب تعداد واحد در طبقه"
        let pickerController = getPickerViewOneComponent(attributes: attributes, title: title)
        pickerController.limit = attributes.count
        self.present(pickerController, animated: true)
        pickerController.onDoneBlock = { result in
            self.choosingButtons[1].setTitle(attributes[result],for: .normal)
            self.self.order.orderTillNow["unit_count"] = result+1
            self.goForEstimate()

        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setToolbarHidden(false, animated: false)
        order.orderType = .garageCleaning
        configureSetting()
        prepareOrder()
        // Do any additional setup after loading the view.
    }

    func configureSetting(){
        self.navigationItem.title = "مشاعات"
        for item in choosingButtons{
            item.layer.borderWidth = 1
            item.layer.cornerRadius = 8
            item.layer.borderColor = getPinworkColors(color: 1).cgColor
            
            priceLabel.clipsToBounds = true
            priceLabel.layer.cornerRadius = 8
            
            
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
    }
    
    
    
    @objc func nextLevelClicked(){
        if isFailed{
            goForEstimate()
        }
        else{
        if isFullyFilled(){
            self.performSegue(withIdentifier: "segueToDateTimeOrder", sender: self)
        }
        else{
            showToast(message: "لطفا تمامی موراد خواسته شده را تکمیل نمایید.")
        }
        
        }}
    func prepareOrder(){
        self.order.orderTillNow["parking_cleaning"] = 0
        self.order.orderTillNow["roof_cleaning"] = 0
        self.order.orderTillNow["yard_cleaning"] = 0
        self.order.orderTillNow["window_cleaning"] = 0

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CarWashOrderDateTimeViewController {
            destination.currentPrice = priceLabel.text!
            destination.order = self.order
            let tempInterval = (Double(self.timeInterval)/60)
            destination.timeInterval = tempInterval
        }
        
    }
    func isFullyFilled()->Bool{
        for item in choosingButtons{
            if item.currentTitle == "انتخاب کنید"{
                return false
            }
        }
        return true

    }
    
    
    
    
    func goForEstimate(){
        if isFullyFilled(){
        self.showCostEstimateProgress()
        self.order.orderTillNow["remember_token"] = self.getData(key: "rememberToken") as! String
        self.order.orderTillNow["default_start_date"] = "2018-03-10 17:00:00"
        self.order.orderTillNow["worker_count_request"] = 1
        self.priceConstraint.constant = -30
        UIView.animate(withDuration: 0.6,animations: {
            self.view.layoutIfNeeded()
        })
        APIClient.estimateJointsPrice(requestArray: self.order.orderTillNow, completionHandler: { (response, error) in
            self.hideCostEstimateProgress()

            if response != nil{
                if self.tokenHasExpired(response!["respond"] as! Int){
                    self.showTokenExpiredPopUp()
                }
                else{
                self.isFailed = false
                self.toolbarItems?.insert(UIBarButtonItem(customView: self.nextLevelButton!), at: 1)
                self.timeInterval = (response!["data"] as! NSDictionary)["time"] as! Int
                self.priceLabel.text! = "برآورد قیمت : " +
                    String((response!["data"] as! NSDictionary)["price"] as! Int).convertToPersian() + " تومان "
                self.priceConstraint.constant = 10
                UIView.animate(withDuration: 0.9,animations: {
                    self.view.layoutIfNeeded()
                })
            }}else{
                //retry
                self.toolbarItems?.insert(UIBarButtonItem(customView: self.retryButton!), at: 1)
                self.showToast(message: "خطا در ارتباط، لطفا جهت محاسبه قیمت، از پایین صفحه تلاش مجدد را انتخاب نمایید.")
                self.isFailed = true
            }
        })
        
        
        
    }
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
