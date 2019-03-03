//
//  AssuranceViewController.swift
//  pinwork
//
//  Created by pouyan shalbafan on 2/21/19.
//  Copyright © 2019 Pouyan. All rights reserved.
//

import UIKit

class AssuranceViewController: UIViewController {
        var onDoneBlock : ((Bool) -> Void)?
    var message : String = "آیا از انجام این عملیات اطمینان دارید؟"
    
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var assuranceMessageLabel: UILabel!
    @IBOutlet weak var yesUIButton: UIButton!
        @IBOutlet weak var noUIButton: UIButton!
        @IBAction func yesButtonClicked(_ sender: UIButton) {
            self.dismiss(animated: true)
            onDoneBlock!(true)
        }
        
        @IBAction func noButtonClicked(_ sender: UIButton) {
            self.dismiss(animated: true)
            onDoneBlock!(false)        }
        override func viewDidLoad() {
            super.viewDidLoad()
            containerView.layer.cornerRadius = 5
            noUIButton.layer.borderWidth = 1
            noUIButton.layer.cornerRadius = 5
            
            noUIButton.layer.borderColor = noUIButton.currentTitleColor.cgColor
            yesUIButton.layer.cornerRadius = 5
            yesUIButton.layer.cornerRadius = 5
            noUIButton.layer.shadowColor = UIColor(red:0.02, green:0.29, blue:0.36, alpha:1.0).cgColor
            noUIButton.layer.shadowOffset = CGSize(width: 2, height: 2)
            noUIButton.layer.shadowRadius = 2
            noUIButton.layer.shadowOpacity = 0.5
            yesUIButton.layer.shadowColor = UIColor(red:0.02, green:0.29, blue:0.36, alpha:1.0).cgColor
            yesUIButton.layer.shadowOffset = CGSize(width: 2, height: 2)
            yesUIButton.layer.shadowRadius = 2
            yesUIButton.layer.shadowOpacity = 0.5
            assuranceMessageLabel.text = self.message
            // Do any additional setup after loading the view.
        }
        

}
