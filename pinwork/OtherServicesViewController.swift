//
//  OtherServicesViewController.swift
//  pinwork
//
//  Created by Pouyan on 7/8/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit

class OtherServicesViewController: UIViewController {

    var order = Order()
    
    @IBOutlet var servicesViews: [UIView]!
    
    
    
    @IBAction func gardenningClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "otherServicesInfoSegue", sender: sender)
    }
    
    
    @IBAction func sprayingClicked(_ sender: UIButton) {
          performSegue(withIdentifier: "otherServicesInfoSegue", sender: sender)
    }
    
    @IBAction func repaireClicked(_ sender: UIButton) {
          performSegue(withIdentifier: "otherServicesInfoSegue", sender: sender)
    }
    
    @IBAction func airConditioningRepaireClicked(_ sender: UIButton) {
          performSegue(withIdentifier: "otherServicesInfoSegue", sender: sender)
    }
    
    
    @IBAction func windowClicked(_ sender: UIButton) {
          performSegue(withIdentifier: "otherServicesInfoSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (sender as! UIButton).restorationIdentifier {
        case "0":
            order.orderTillNow["type"] = "gardening"
        case "1":
            order.orderTillNow["type"] = "spraying"
        case "2":
            order.orderTillNow["type"] = "domestic_repair"
        case "3":
            order.orderTillNow["type"] = "air_conditioner"
        case "4":
            order.orderTillNow["type"] = "window"
        default:
            break
        }
        
        if let otherServiceInfo = segue.destination as? OtherServicesOrderViewController{
            otherServiceInfo.order = self.order
        }
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        order.orderType = .otherServices
        configureSetting()
        
        // Do any additional setup after loading the view.
   
    
    
    
    }

    
    func configureSetting(){
        for item in servicesViews{
            item.clipsToBounds = true
            item.layer.cornerRadius = 3
        }
       
    }
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

   

}
