//
//  OrderViewController.swift
//  pinwork
//
//  Created by Pouyan on 6/13/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
     enum action{
        case officeCleaning
        case homeCleaning
        case garageCleaning
        case carWash
    }
    var orderType = action.officeCleaning

    override func viewDidLoad() {
        super.viewDidLoad()
        switch orderType{
        case .officeCleaning:
            print("office")
        case .homeCleaning:
            print("home")
        case .garageCleaning:
            print("garage")
        case .carWash:
            print("carwash")
        }
        self.navigationItem.title = "ثبت سفارش"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
