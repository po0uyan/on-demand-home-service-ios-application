//
//  CompeleteRegisterFormViewController.swift
//  pinwork
//
//  Created by Pouyan on 7/25/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit
import SwiftyJSON
class CompeleteRegisterFormViewController: UIViewController ,UITextFieldDelegate{
    var loadingView : UIView!
    var requestParams : [String:Any] = [:]
     var onDoneBlock : ((Int) -> Void)?
    @IBOutlet weak var releafeButton: UIBarButtonItem!
    
    @IBOutlet weak var registerNavBar: UINavigationBar!
    
    
    @IBOutlet var registerViews: [UIView]!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var lastnameTextField: UITextField!
    
    @IBOutlet weak var primaryPhoneTextField: UITextField!
    
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !MainViewController.isCommingFromRegister{
            releafeButton.isEnabled = false
            releafeButton.tintColor = UIColor.clear
        }
        nameTextField.delegate = self
        lastnameTextField.delegate = self
        primaryPhoneTextField.delegate = self
        primaryPhoneTextField.keyboardType = .numberPad
        primaryPhoneTextField.keyboardAppearance = .dark
        releafeButton.target = self
        releafeButton.action = #selector(action)
        
       
        nameTextField.text = "نام"
        nameTextField.textColor = UIColor.lightGray
        
        lastnameTextField.text = "نام خانوادگی"
        lastnameTextField.textColor = UIColor.lightGray
        
        primaryPhoneTextField.text = "تلفن ثابت"
        primaryPhoneTextField.textColor = UIColor.lightGray
        
        
        for item in registerViews{
            item.clipsToBounds = true
            item.layer.borderWidth = 1
            item.layer.cornerRadius = 8
            item.layer.borderColor = getPinworkColors(color: 1).cgColor
        }
        submitButton.clipsToBounds = true
        submitButton.layer.cornerRadius = 8
        self.registerNavBar.tintColor = UIColor.white
        self.registerNavBar.backgroundColor = UIColor.white
        self.registerNavBar.barTintColor = UIColor(red:0.02, green:0.29, blue:0.36, alpha:1.0)
        self.registerNavBar.isTranslucent = false
        self.registerNavBar.clipsToBounds = false
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font: UIFont(name: "IRAN SansMobile(NoEn)", size: 20.0)!]
        self.registerNavBar.titleTextAttributes = textAttributes
        requestParams["gender"] = "female"

      
    }
    
    @objc func action (sender:UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func submitClicked(_ sender: UIButton) {
        if isFullyField(){
            compeleteRegister()
            
        }
    }
    func isFullyField()->Bool{
        if (nameTextField.text?.isEmptyOrWhitespace())! || nameTextField.text == "نام"{
            showToast(message: "لطفا نام خود را وارد نمایید")
            return false
        }else if (lastnameTextField.text?.isEmptyOrWhitespace())! || lastnameTextField.text == "نام خانوادگی"{
            showToast(message: "لطفا نام خانوادگی خود را وارد نمایید")
            return false
        }else if (primaryPhoneTextField.text?.isEmptyOrWhitespace())! || primaryPhoneTextField.text == "تلفن ثابت"{
            showToast(message: "لطفا شماره تلفن ثابت خود را وارد نمایید")
            return false
        }else if primaryPhoneTextField.text?.count != 8 {
            showToast(message: "لطفا شماره تلفن ثابت خود را بدون کد شهر و در ۸ رقم وارد نمایید")
            return false
        }
        
        
        
        
        return true
    }
    func compeleteRegister(){
        loadingView = displaySpinner(onView: self.view)
        requestParams["name"] = nameTextField.text!
        requestParams["lastname"] = lastnameTextField.text!
        requestParams["phone_place"] = "021" +  primaryPhoneTextField.text!.convertToEngNumToSend()
        APIClient.requestForCompeleteRegister(rememberToken: getData(key: "rememberToken") as! String, requestParams: requestParams as! [String : String]) { (response, error) in
           self.removeSpinner(spinner: self.loadingView)
            if response != nil{
                if self.tokenHasExpired(response!["respond"].intValue){
                    self.showTokenExpiredPopUp()
                }
                else{
                if response!["respond"].intValue == 200{
                    MainViewController.isCommingFromRegister = false
                    self.dismiss(animated: true)
                    self.onDoneBlock!(0)
                }else{
                    self.showToast(message: "خطا، لطفا با پشتیبانی تماس بگیرید.")
                }
            }}
            else{
                print(error)
                let retry = self.showNetworkRetryPopUp()
                retry.onDoneBlock = { result in
                    self.compeleteRegister()
                }
            }
            
        }
        
    }
    
    @IBAction func genderChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            requestParams["gender"] = "female"

        default:
            requestParams["gender"] = "male"

        }
    }
    
    
    
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
     
        if textField.textColor == UIColor.lightGray {
            textField.text = ""
            textField.textColor = UIColor.black
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.isEmpty)! {
        switch textField.restorationIdentifier {
        case "name":
            textField.text = "نام"
            textField.textColor = UIColor.lightGray
        case "lastName":
            textField.text = "نام خانوادگی"
            textField.textColor = UIColor.lightGray
        case "primaryPhone":
            textField.text = "تلفن ثابت"
            textField.textColor = UIColor.lightGray
        default:
            break
        }
        
           
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.restorationIdentifier == "primaryPhone"{
        let maxLength = 11
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        }
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
