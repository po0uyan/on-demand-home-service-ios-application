//
//  RegisterringDoneViewController.swift
//  pinwork
//
//  Created by Pouyan on 7/25/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit
import Lottie
class RegisterringDoneViewController: UIViewController {
    let animationView = LOTAnimationView(name: "done")
    var serviceCode = ""
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dissmissButton: UIButton!
    @IBOutlet weak var doneAnimationView: UIView!
    
    @IBOutlet weak var serviceCodeLabel: UILabel!
    var onDoneBlock : ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        serviceCodeLabel.text = serviceCodeLabel.text! + " " + serviceCode

        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 8
        dissmissButton.clipsToBounds = true
        dissmissButton.layer.cornerRadius = 8
       
        // Do any additional setup after loading the view.
    }

    
    @IBAction func dissmissClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
        onDoneBlock!(true)

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        animationView.frame = CGRect(x: self.doneAnimationView.frame.origin.x, y: self.doneAnimationView.frame.origin.y, width: self.doneAnimationView.frame.width, height: self.doneAnimationView.frame.height)
        animationView.center = self.doneAnimationView.center
        animationView.contentMode = .scaleAspectFit
        
        self.doneAnimationView.addSubview(animationView)
        
        animationView.play()
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
