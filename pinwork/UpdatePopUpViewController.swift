//
//  UpdatePopUpViewController.swift
//  pinwork
//
//  Created by Pouyan on 6/3/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit

class UpdatePopUpViewController: UIViewController {
    var onDoneBlock : ((Bool) -> Void)?
    @IBOutlet weak var UpdatePopUpUIView: UIView!
    @IBOutlet weak var updateUIButton: UIButton!
    @IBOutlet weak var cancelUIButton: UIButton!
    @IBAction func upDateClicked(_ sender: UIButton) {
        let myUrl = "https://new.sibapp.com/applications/pinwork"
        if let url = URL(string: "\(myUrl)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true)
        onDoneBlock!(true)
    }
    var isCritical : Bool?
    var isLoggedIn : Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        cancelUIButton.layer.borderWidth = 1
        cancelUIButton.layer.cornerRadius = 5
        updateUIButton.layer.cornerRadius = 5
        UpdatePopUpUIView.layer.cornerRadius = 5
        cancelUIButton.layer.borderColor = cancelUIButton.currentTitleColor.cgColor
        
        if isCritical!{
            cancelUIButton.isHidden = true
        }
    }
  
  
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
