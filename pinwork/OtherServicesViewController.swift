//
//  OtherServicesViewController.swift
//  pinwork
//
//  Created by Pouyan on 7/8/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit

class OtherServicesViewController: UIViewController {

    
    @IBOutlet var servicesViews: [UIView]!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
