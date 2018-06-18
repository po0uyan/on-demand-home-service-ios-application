//
//  OrderDateTimeViewController.swift
//  pinwork
//
//  Created by Pouyan on 6/16/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit

class OrderDateTimeViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var priceLabelConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var timeIntervalPickerButton: UIButton!
    
    @IBOutlet weak var dateTimePickerButton: UIButton!
    
    var nextLevelButton : UIButton?
    enum action{
        case officeCleaning
        case homeCleaning
        case garageCleaning
    }
    var orderType = action.homeCleaning

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch orderType{
        case .officeCleaning:
            print("office")
            prepareSetting(orderType: orderType)
        case .homeCleaning:
            print("home")
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
        
        nextLevelButton = getUIBarButtonItem(title: "مرحله بعدی", image: "move-to-next")
        var items = [UIBarButtonItem]()
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        items.append( UIBarButtonItem(customView: nextLevelButton!))
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        nextLevelButton!.addTarget(self, action: #selector(self.nextLevelClicked), for: .touchUpInside)
        self.toolbarItems = items
        
    }
    func prepareSetting(orderType : action){
        
    }
    @objc func nextLevelClicked(){
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
        
    }
    

   

}
