//
//  RetryViewController.swift
//  pinwork
//
//  Created by Pouyan on 6/6/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit

class RetryViewController: UIViewController {
    var onDoneBlock : ((Bool) -> Void)?

    @IBOutlet weak var retryUIButton: UIButton!
    @IBOutlet weak var exitUIButton: UIButton!
    @IBAction func retryButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
        onDoneBlock!(true)
    }
    
    @IBAction func exitButtonClicked(_ sender: UIButton) {
        exit(EXIT_SUCCESS)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        exitUIButton.layer.borderWidth = 1
        exitUIButton.layer.cornerRadius = 5
         exitUIButton.layer.borderColor = exitUIButton.currentTitleColor.cgColor
        retryUIButton.layer.cornerRadius = 5
        retryUIButton.layer.cornerRadius = 5
       
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
