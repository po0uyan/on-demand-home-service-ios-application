//
//  ServiceDetailesViewController.swift
//  pinwork
//
//  Created by Pouyan on 7/22/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit
class ServiceDetailesViewController: UIViewController {
    
    @IBOutlet weak var rateButton: UIButton!
    
    @IBOutlet weak var workersStackView: UIStackView!
    
    @IBOutlet weak var secondWorkerView: UIView!
    
    
    @IBOutlet weak var thirdWorkerView: UIView!
    
    @IBOutlet weak var callForSupportButton: UIButton!
    
    @IBOutlet weak var showInvoiceButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
//       secondWorkerView.isHidden = true
//       thirdWorkerView.isHidden = true
        rateButton.isHidden = true
        
        callForSupportButton.layer.cornerRadius = 8
        showInvoiceButton.layer.borderWidth = 1
        showInvoiceButton.layer.borderColor = getPinworkColors(color: 1).cgColor
        showInvoiceButton.layer.cornerRadius = 8
     
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
