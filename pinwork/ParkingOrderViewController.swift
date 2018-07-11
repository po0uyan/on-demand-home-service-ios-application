//
//  ParkingOrderViewController.swift
//  pinwork
//
//  Created by Pouyan on 6/22/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit

class ParkingOrderViewController: UIViewController {

    var OrderTillNow:Dictionary<String,Any> = [:]
    @IBOutlet var choosingButtons: [UIButton]!
    
    @IBOutlet weak var priceConstraint: NSLayoutConstraint!
    var nextLevelButton : UIButton?
    var timeInterval = 0
    var isFailed = false
    @IBOutlet weak var priceLabel: UILabel!
    @IBAction func yardCleaningChanged(_ sender: UISwitch) {
        if sender.isOn{
            OrderTillNow["yard_cleaning"] = 1

        }
        else{
            OrderTillNow["yard_cleaning"] = 0

        }
        self.goForEstimate()

    }
    
    @IBAction func windowCleaningChanged(_ sender: UISwitch) {
        if sender.isOn{
            OrderTillNow["window_cleaning"] = 1

        }
        else{
            OrderTillNow["window_cleaning"] = 0

        }
        self.goForEstimate()

    }
    
    @IBAction func parkingCleaningChanged(_ sender: UISwitch) {
        if sender.isOn{
            OrderTillNow["parking_cleaning"] = 1
        }
        else{
            OrderTillNow["parking_cleaning"] = 0

        }
        self.goForEstimate()

    }
    

    @IBAction func roofCleaningChanged(_ sender: UISwitch) {
        if sender.isOn{
            OrderTillNow["roof_cleaning"] = 1

        }
        else{
            OrderTillNow["roof_cleaning"] = 0

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
            self.OrderTillNow["floor_count"] = result+1
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
            self.OrderTillNow["unit_count"] = result+1
            self.goForEstimate()

        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSetting()
        prepareOrder()
        // Do any additional setup after loading the view.
    }

    func configureSetting(){
        for item in choosingButtons{
            item.layer.borderWidth = 1
            item.layer.cornerRadius = 8
            item.layer.borderColor = getPinworkColors(color: 1).cgColor
            
            priceLabel.clipsToBounds = true
            priceLabel.layer.cornerRadius = 8
            
            
            nextLevelButton = getUIBarButtonItem(title: "مرحله بعدی", image: "move-to-next")
            var items = [UIBarButtonItem]()
            items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
            items.append( UIBarButtonItem(customView: nextLevelButton!))
            items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
            nextLevelButton!.addTarget(self, action: #selector(self.nextLevelClicked), for: .touchUpInside)
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
        OrderTillNow["parking_cleaning"] = 0
        OrderTillNow["roof_cleaning"] = 0
        OrderTillNow["yard_cleaning"] = 0
        OrderTillNow["window_cleaning"] = 0

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CarWashOrderDateTimeViewController {
            destination.currentPrice = priceLabel.text!
            destination.OrderTillNow = OrderTillNow
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
        let token2 = "fced86ff2ba6060a396d18639974900ff425352f"
        OrderTillNow["remember_token"] = token2 //shitt
        OrderTillNow["default_start_date"] = "2018-03-10 17:00:00"
        OrderTillNow["worker_count_request"] = 1
        self.priceConstraint.constant = -30
        UIView.animate(withDuration: 0.6,animations: {
            self.view.layoutIfNeeded()
        })
        APIClient.estimateJointsPrice(requestArray: OrderTillNow, completionHandler: { (response, error) in
            self.hideCostEstimateProgress()
            self.nextLevelButton!.setTitle("مرحله بعدی", for: .normal)
            self.nextLevelButton!.setImage(UIImage(named: "move-to-next")?.withRenderingMode(.alwaysOriginal), for: .normal)
            self.toolbarItems?.insert(UIBarButtonItem(customView: self.nextLevelButton!), at: 1)

            if response != nil{
                self.isFailed = false
                self.nextLevelButton?.setTitle("مرحله بعد", for: .normal)
                self.timeInterval = (response!["data"] as! NSDictionary)["time"] as! Int
                self.priceLabel.text! = "برآورد قیمت : " +
                    String((response!["data"] as! NSDictionary)["price"] as! Int).convertToPersian() + " تومان "
                self.priceConstraint.constant = 10
                UIView.animate(withDuration: 0.9,animations: {
                    self.view.layoutIfNeeded()
                })
            }else{
                //retry
                self.showToast(message: "خطا در ارتباط، لطفا جهت محاسبه قیمت، از پایین صفحه تلاش مجدد را انتخاب نمایید.")
                self.isFailed = true
                self.nextLevelButton!.setTitle(" تلاش مجدد  ", for: .normal)
                self.nextLevelButton!.setImage(UIImage(named: "refresh")?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        })
        
        
        
    }
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
