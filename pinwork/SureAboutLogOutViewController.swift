//
//  SureAboutLogOutViewController.swift
//  pinwork
//
//  Created by Pouyan on 7/25/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit

class SureAboutLogOutViewController: UIViewController {
    var onDoneBlock : ((Bool) -> Void)?

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 8 
yesButton.layer.cornerRadius = 8
        noButton.layer.borderWidth = 1
        noButton.layer.borderColor = getPinworkColors(color: 1).cgColor
        noButton.layer.cornerRadius = 8
    }

    @IBAction func noButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
        onDoneBlock!(false)
    }
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
        onDoneBlock!(true)
    }
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    



}
