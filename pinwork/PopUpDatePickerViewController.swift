//
//  PopUpDatePickerViewController.swift
//  pinwork
//
//  Created by Pouyan on 6/14/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit

class PopUpDatePickerViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var timePicker: UIPickerView!
    
    @IBOutlet weak var submitUIButton: UIButton!
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var cancelUIButton: UIButton!
    var validDates = [Date]()
    var validTimes = [String]()
    var onDoneBlock : ((Date,Int) -> Void)?
    var limit = 0
    @IBAction func submitClicked(_ sender: UIButton) {
        if timePicker.selectedRow(inComponent: 0)>limit{
            showToast(message: " جهت ایجاد امکان انتخاب این زمان، مدت‌زمان کار را به گونه‌ای تغییر دهید، که کار مورد نظر حداکثر تا ساعت ۲۰ تکمیل شود. ")
        }
        else{
        self.dismiss(animated: true, completion: nil)
        onDoneBlock!(validDates[timePicker.selectedRow(inComponent: 1)],timePicker.selectedRow(inComponent: 0))
    
        }}
    @IBAction func cancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        
    }
    func setting(){
//        datePicker.calendar = NSCalendar(identifier: .persian)! as Calendar
        submitUIButton.layer.cornerRadius = 5
        cancelUIButton.layer.cornerRadius = 5
        cancelUIButton.layer.borderWidth = 1
        submitUIButton.layer.borderColor = submitUIButton.currentTitleColor.cgColor
        cancelUIButton.layer.borderColor = cancelUIButton.currentTitleColor.cgColor
        innerView.layer.cornerRadius = 5
        timePicker.delegate = self
        timePicker.dataSource = self
        timePicker.showsSelectionIndicator = true
//        datePicker.delegate = self
//        datePicker.dataSource = self
//        pickerView.selectRow(1, inComponent: 0, animated: true)
    }
 
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 2
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if component == 1{
            return validDates.count
        }
        return   validTimes.count

    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 1{
            return getProperDate(date:validDates[row])
        }
        return validTimes[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // use the row to get the selected row from the picker view
        // using the row extract the value from your datasource (array[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if component == 1{
        var label = UILabel()
        if let v = view {
            label = v as! UILabel
        }
        label.font = UIFont(name: "IRAN SansMobile(NoEn)", size: 15.0)
            label.text =  getProperDate(date: validDates[row])
        label.textAlignment = .center
        return label
        
        }
        var label = UILabel()
        if let v = view {
            label = v as! UILabel
        }
        label.font = UIFont(name: "IRAN SansMobile(NoEn)", size: 15.0)
        if row>limit{
            label.textColor = UIColor.red
        }
        label.text =  validTimes[row]
        label.textAlignment = .center
        return label
    }
    func pickerView(_ pickerView: UIPickerView,
                    rowHeightForComponent component: Int) -> CGFloat{
        return CGFloat(35)
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
