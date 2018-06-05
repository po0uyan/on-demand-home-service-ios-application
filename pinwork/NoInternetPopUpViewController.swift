//
//  NoInternetPopUpViewController.swift
//  pinwork
//
//  Created by Pouyan on 6/5/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit
import Reachability
class NoInternetPopUpViewController: UIViewController {
    var onDoneBlock : ((Bool) -> Void)?

    @IBAction func exitClikced(_ sender: UIButton) {
        self.dismiss(animated: true)
        exit(EXIT_SUCCESS)
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.popUpOnNetFail), name: Notification.Name.reachabilityChanged, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: nil)
    }
        @objc  func popUpOnNetFail(_ notification : Notification){
            let reachability = notification.object as! Reachability
            switch reachability.connection{
            case .none:
                debugPrint("Network became unreachable")
                break
            case .cellular :
                self.dismiss(animated: true)
                onDoneBlock!(true)
            case .wifi:
                self.dismiss(animated: true)
                onDoneBlock!(true)
            }
            
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
