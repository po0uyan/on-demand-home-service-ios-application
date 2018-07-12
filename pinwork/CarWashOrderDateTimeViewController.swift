//
//  OrderDateTimeViewController.swift
//  pinwork
//
//  Created by Pouyan on 6/14/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit

class CarWashOrderDateTimeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var PriceConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateTimePickingButton: UIButton!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    var OrderTillNow :Dictionary<String,Any> = [:]
    var timeInterval = 0.0
    var nextLevelButton : UIButton?
    var currentPrice : String?
    let myLocale = Locale(identifier: "fa_IR")
    var calendar = Calendar(identifier: .persian)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
    }
    
    
    @IBAction func dateTimePickerButonClicked(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let popUpDateTime = storyBoard.instantiateViewController(withIdentifier: "datepickerpopup") as! PopUpDatePickerViewController
        popUpDateTime.validDates = getValidDatesForType()
        popUpDateTime.validTimes = getValidTimesForType()
        popUpDateTime.limit = Int(Double(getValidTimesForType().count) - 2 * self.timeInterval)
        print(popUpDateTime.limit)
        
        
        
        popUpDateTime.modalTransitionStyle = .crossDissolve
        popUpDateTime.isModalInPopover = true
        popUpDateTime.modalPresentationStyle = .overCurrentContext
        self.present(popUpDateTime, animated: true)
        popUpDateTime.onDoneBlock = { date , time in
            let _startTime = self.getValidTimesForType()[time]
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            formatter.dateFormat = "yyyy-MM-dd"
            let stringTime = formatter.string(from: date)
            self.OrderTillNow["default_start_date"] = (stringTime + " " + _startTime.convertToEnglish() + ":00")
            self.dateTimePickingButton.setTitle(self.getProperDate(date: date) + " ساعت " + _startTime, for: .normal)
            print(self.OrderTillNow)
            
            
            
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
    func getValidTimesForType()->[String]{
        return ["۹:۰۰","۹:۳۰","۱۰:۰۰","۱۰:۳۰","۱۱:۰۰","۱۱:۳۰","۱۲:۰۰","۱۲:۳۰","۱۳:۰۰","۱۳:۳۰","۱۴:۰۰","۱۴:۳۰","۱۵:۰۰","۱۵:۳۰","۱۶:۰۰","۱۶:۳۰","۱۷:۰۰","۱۷:۳۰","۱۸:۰۰","۱۸:۳۰","۱۹:۰۰","۱۹:۳۰"]
    }
    
    
    
    func setting(){
        descriptionTextView.delegate = self
        dateTimePickingButton.layer.borderWidth = 1
        dateTimePickingButton.layer.borderColor = getPinworkColors(color: 1).cgColor
        dateTimePickingButton.layer.cornerRadius = 8
        priceLabel.clipsToBounds = true
        priceLabel.layer.cornerRadius = 8
        priceLabel.text! = currentPrice!
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 8
        descriptionTextView.layer.borderColor = getPinworkColors(color: 1).cgColor
        descriptionTextView.keyboardAppearance = .light
        descriptionTextView.text = "توضیحات خود را اینجا وارد نمایید..."
        descriptionTextView.textColor = UIColor.lightGray
        nextLevelButton = getUIBarButtonItemForNextLevel(title: "مرحله بعدی", image: "move-to-next")
        var items = [UIBarButtonItem]()
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        items.append( UIBarButtonItem(customView: nextLevelButton!))
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        nextLevelButton!.addTarget(self, action: #selector(self.nextLevelClicked), for: .touchUpInside)
        self.toolbarItems = items
        
        
        calendar.locale = myLocale

        
    }
    
    @objc func nextLevelClicked(){
        self.performSegue(withIdentifier: "MapViewSegue", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MapViewController {
            if descriptionTextView.text != "" && descriptionTextView.text != "توضیحات خود را اینجا وارد نمایید..." {
                OrderTillNow["description"] = descriptionTextView.text
                
            }
            destination.OrderTillNow = OrderTillNow
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "توضیحات خود را اینجا وارد نمایید..."
            textView.textColor = UIColor.lightGray
        }
    }
    

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count // for Swift use count(newText)
        return numberOfChars < 599
    }


    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    

    

}
