//
//  MainNavigationViewController.swift
//  pinwork
//
//  Created by Pouyan on 6/7/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.backgroundColor = UIColor.white
        self.navigationBar.barTintColor = UIColor(red:0.02, green:0.29, blue:0.36, alpha:1.0)
        self.toolbar.barTintColor = getPinworkColors(color: 0)
        self.toolbar.isTranslucent = false
        self.navigationBar.isTranslucent = false
        self.navigationBar.clipsToBounds = false
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationBar.titleTextAttributes = textAttributes
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
