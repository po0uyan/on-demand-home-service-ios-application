//
//  CarWashViewController.swift
//  pinwork
//
//  Created by Pouyan on 6/13/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit
import Lottie

class CarWashViewController: UIViewController {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceConstraint: NSLayoutConstraint!
    @IBOutlet weak var chooseCarTypeButton: UIButton!
    @IBOutlet weak var chooseWashTypeButton: UIButton!
    
    let animationView = LOTAnimationView(name: "trail_loading")
    var OrderTillNow:Dictionary<String,Any> = [:]
    var nextLevelButton : UIButton?
    let mapWashType = [0:"water",1:"nano",2:"steam"]
    let mapCarType = [0:"h_back",1:"3don",2:"cross",3:"suv"]

    @IBAction func carTypeChooseClicked(_ sender: UIButton) {
        let attributes = ["هاچ‌بک","سدان","کراس‌اُور","شاسی‌بلند"]
        let title = "انتخاب نوع خودرو"
        let pickerController = getPickerViewOneComponent(attributes: attributes, title: title)
        pickerController.limit = attributes.count
        self.present(pickerController, animated: true)
        pickerController.onDoneBlock = { result in
            self.chooseCarTypeButton.setTitle(attributes[result],for: .normal)
            self.OrderTillNow ["car_type"] = self.mapCarType[result]
            self.goForEstimate()

        }
    }
    
    @IBAction func washTypeChooseClicked(_ sender: UIButton) {

        let attributes = ["شتسشو با آب","شستشو با نانو","شستشو با بخار"]
        let title = "انتخاب نوع شستشو"
        let pickerController = getPickerViewOneComponent(attributes: attributes, title: title)
        pickerController.limit = attributes.count
        self.present(pickerController, animated: true)
        pickerController.onDoneBlock = { result in
            self.chooseWashTypeButton.setTitle(attributes[result],for: .normal)
            self.OrderTillNow["material"] = self.mapWashType[result]
            self.goForEstimate()
        
        }
    }
    func goForEstimate(){
        if self.isFullyFilled(){
            self.showProgress()
            self.priceConstraint.constant = -30
            UIView.animate(withDuration: 0.6,animations: {
                self.view.layoutIfNeeded()
            })
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let someDateTime = formatter.date(from: "2018-03-10 17:00:00")
            //let token = self.getData(key: "rememberToken") as! String
            let token2 = "fced86ff2ba6060a396d18639974900ff425352f"
            APIClient.estimateCarWashPrice(defaultDate: formatter.string(from: someDateTime!), carType: self.OrderTillNow["car_type"] as! String, material: self.OrderTillNow["material"] as! String, rememberToken: token2, completionHandler: { (response, error) in
                self.animationView.stop()
                self.animationView.isHidden = true
                if response != nil{
                    self.priceLabel.text! = "برآورد قیمت : " +
                        String((response!["data"] as! NSDictionary)["price"] as! Int).convertToPersian() + " تومان "
                    self.priceConstraint.constant = 10
                    UIView.animate(withDuration: 0.9,animations: {
                        self.view.layoutIfNeeded()
                    })
                }else{
                    //retry
                    print(error as Any)
                }
            })
            
            
        }
        
        
    }
    func isFullyFilled()->Bool{
        if chooseCarTypeButton.currentTitle == "انتخاب کنید" || chooseWashTypeButton.currentTitle == "انتخاب کنید"{
            return false
        }
        return true
    }
    func showProgress(){
    
        animationView.isHidden = false
        animationView.play()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        // Do any additional setup after loading the view.
    }
    func setting(){
        self.navigationItem.title = "ثبت سفارش"
chooseCarTypeButton.layer.borderWidth = 1
        chooseCarTypeButton.layer.borderColor = getPinworkColors(color: 1).cgColor
        chooseCarTypeButton.layer.cornerRadius = 8
        chooseWashTypeButton.layer.borderWidth = 1
        chooseWashTypeButton.layer.borderColor = getPinworkColors(color: 1).cgColor
        chooseWashTypeButton.layer.cornerRadius = 8
        priceLabel.layer.cornerRadius = 8
      
        nextLevelButton = getUIBarButtonItem(title: "مرحله بعدی", image: "move-to-next")
        var items = [UIBarButtonItem]()
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        items.append( UIBarButtonItem(customView: nextLevelButton!))
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        nextLevelButton!.addTarget(self, action: #selector(self.nextLevelClicked), for: .touchUpInside)
        self.toolbarItems = items
   
    }
    @objc func nextLevelClicked(){
        if isFullyFilled(){
        self.performSegue(withIdentifier: "segueToDateTimeOrder", sender: self)
        }
        else{
            showToast(message: "لطفا تمامی موراد خواسته شده را تکمیل نمایید.")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CarWashOrderDateTimeViewController {
            destination.currentPrice = priceLabel.text! 
            destination.OrderTillNow = OrderTillNow
            // destination.nomb = arrayNombers[(sender as! UIButton).tag] // Using button Tag
        }



    }
    override func viewDidAppear(_ animated: Bool) {
        animationView.frame = CGRect(x: (self.view.bounds.midX - self.view.frame.width/4/4*3), y: (self.view.bounds.height - self.view.frame.height/4/4*3 - (self.navigationController?.toolbar.frame.height)!), width: self.view.frame.width/4*3/2, height: self.view.frame.height/4*3/2)
        animationView.contentMode = .scaleAspectFit
        animationView.loopAnimation = true
        animationView.isHidden = true
        self.view.addSubview(animationView)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
