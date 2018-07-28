//
//  TokenExpiredViewController.swift
//  pinwork
//
//  Created by Pouyan on 7/28/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit

class TokenExpiredViewController: UIViewController {
    @IBOutlet weak var TokenExpiredUIView: UIView!
    @IBOutlet weak var loginAgain: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    @IBAction func loginAgainClicked(_ sender: UIButton) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    @IBAction func exitClicked(_ sender: Any) {
        exit(EXIT_SUCCESS)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        exitButton.layer.borderWidth = 1
        exitButton.layer.cornerRadius = 5
        loginAgain.layer.cornerRadius = 5
        TokenExpiredUIView.layer.cornerRadius = 5
        exitButton.layer.borderColor = exitButton.currentTitleColor.cgColor
    }
    override func viewDidAppear(_ animated: Bool) {
        self.updataData(key: "isLoggedIn", value: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
