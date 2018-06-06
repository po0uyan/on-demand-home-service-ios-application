//
//  MainViewController.swift
//  pinwork
//
//  Created by Pouyan on 6/7/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var isMenuShowing = false
    @IBOutlet weak var navigateMenuConstraint: NSLayoutConstraint!
    @IBAction func hamButtonClicked(_ sender: UIButton) {
        if isMenuShowing{
        navigateMenuConstraint.constant = 0
        UIView.animate(withDuration: 0.6,animations: {
            self.view.layoutIfNeeded()
        })
        }else{
            navigateMenuConstraint.constant = 200
            UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
        }
        isMenuShowing = !isMenuShowing
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
