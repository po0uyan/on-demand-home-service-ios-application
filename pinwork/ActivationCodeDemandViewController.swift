//
//  ActivationCodeDemandViewController.swift
//  pinwork
//
//  Created by Pouyan on 5/30/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit
import Lottie
import CoreData
import BRYXBanner
class ActivationCodeDemandViewController: UIViewController, UITextFieldDelegate{
    var onDoneBlock : ((Bool) -> Void)?
    let animationView = LOTAnimationView(name: "loading2")

    @IBOutlet weak var resendUIButton: UIButton!
    
    @IBOutlet weak var popUpUIView: UIView!
    @IBOutlet weak var submitUIButton: UIButton!
    @IBOutlet weak var cancelUIButton: UIButton!
    @IBOutlet weak var titleUILabel: UILabel!
    @IBOutlet weak var descriptionUILabel: UILabel!
    @IBOutlet weak var phoneCodeDemandUITextfield: UITextField!
    var count = 60
    var timer = Timer()
 
    var isPhoneNumber = true
    var isRegisterring: Bool!
    var phoneNumber: String!
    @IBAction func resendClicked(_ sender: UIButton) {
        //sth i have to do
        animationView.play()
        animationView.isHidden = false
        popUpUIView.isHidden = true
        phoneCodeDemandUITextfield.endEditing(true)
        requestForAuthCode(action: isRegisterring ? "register" : "login",phoneNumber: self.phoneNumber)

        descriptionUILabel.isHidden = false
        count = 60
        descriptionUILabel.text = "\(count) ثانیه تا فعال شدن ارسال مجدد کد"
        timer.fire()
        resendUIButton.isHidden = true

    }
    @IBAction func cancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitClicked(_ sender: UIButton) {
     

        if isPhoneNumber{
        if phoneCodeDemandUITextfield.text?.count != 0  {
            if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: phoneCodeDemandUITextfield.text!)) {
                if phoneCodeDemandUITextfield.text?.count == 11{
                    self.phoneNumber = "0" + phoneCodeDemandUITextfield.text!.convertToEngNumToSend()
                    popUpUIView.isHidden = true
                    animationView.play()
                    animationView.isHidden = false
                    
                    requestForAuthCode(action: isRegisterring ? "register" : "login",phoneNumber: self.phoneNumber)
                    phoneCodeDemandUITextfield.endEditing(true)
                    
                }
                else{
                    showToast( message: "لطفا تعداد ارقام وارد شده را کنترل نمایید")
                }
            }else{
                showToast(message : "لطفا عدد وارد نمایید")

            }

        }
        else{
            showToast(message : "لطفا شماره تلفن خود را وارد نمایید")

        }
    }
        else{
            if phoneCodeDemandUITextfield.text?.count != 0  {
                if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: phoneCodeDemandUITextfield.text!)) {
                    if phoneCodeDemandUITextfield.text?.count == 5{
                        popUpUIView.isHidden = true
                        self.view.addSubview(animationView)
                        codeCheckRequestLoginRegister(code: phoneCodeDemandUITextfield.text!.convertToEngNumToSend())
                        phoneCodeDemandUITextfield.endEditing(true)
                        titleUILabel.font = UIFont(name: "IRAN SansMobile(NoEn)", size: 14.0)
                        
                        animationView.play()
                    }
                    else{
                        showToast( message: "لطفا تعداد ارقام وارد شده را کنترل نمایید")
                    }
                }else{
                    showToast(message : "لطفا عدد وارد نمایید")
                    
                }
                
            }
            else{
                showToast(message : "لطفا کد فعال سازی خود را وارد نمایید")
                
            }
            
            
        }
        
        
    }
    func requestForAuthCode(action: String,phoneNumber:String){
     
        APIClient.codeRequestForLoginOrRegister(phoneNumber: self.phoneNumber, action:action,rememberToken: getData(key: "tempRememberToken") as! String){
            responseObject, error in
            if responseObject != nil && !(responseObject!["respond"] is NSNull){
                debugPrint(responseObject)
                if (self.checkRespondStatus(respond: responseObject!["respond"] as! Int)){
                    self.isPhoneNumber = !self.isPhoneNumber
                    self.animationView.stop()
                    self.animationView.isHidden = true
                    self.titleUILabel.font = UIFont(name: "IRAN SansMobile(NoEn)", size: 14.0)

                    self.showDialoge()
                }else{
                    self.animationView.stop()
                    self.animationView.isHidden = true
                    self.popUpUIView.isHidden = false
                    self.phoneCodeDemandUITextfield.text = ""
                    self.phoneCodeDemandUITextfield.becomeFirstResponder()
                    
                }
                
            }
            else{
                print(error)
                self.dismiss(animated: true, completion: nil)
                self.showToast(message: "در انجام عملیات خطایی رخ داده، مجددا تلاش نمایید")
                self.animationView.stop()
            }
            
        }
  
    }

    
    func codeCheckRequestLoginRegister(code: String){
        self.animationView.play()
        self.animationView.isHidden = false
        if isRegisterring{
        APIClient.checkCodeForRegister(phoneNumber:phoneNumber, code:code,rememberToken: getData(key: "tempRememberToken") as! String){
            responseObject, error in
            if responseObject != nil{
                debugPrint(responseObject)
                if (self.checkRespondStatus(respond: responseObject!["respond"] as! Int)){

            let rememberToken = ((responseObject!["data"] as! NSDictionary)["remember_token"]) as! String
            self.updataData(key: "rememberToken", value: rememberToken)
            self.updataData(key: "isLoggedIn", value: true)
            self.updateFcmToken(rememberToken)
            self.animationView.stop()
            self.animationView.isHidden = true
            self.dismiss(animated: true, completion: nil)
            self.onDoneBlock!(true)
                }
                else{
                    
                    self.popUpUIView.isHidden = false
                    self.phoneCodeDemandUITextfield.text = ""
                    self.phoneCodeDemandUITextfield.becomeFirstResponder()
                    
                }
                
            }
            else{
                debugPrint(error!)
                self.showToast(message: "در انجام عملیات خطایی رخ داده، مجددا تلاش نمایید")
            }
            self.animationView.stop()
            self.animationView.isHidden = true
        }
            
        }else{
            APIClient.requestForUserLogin(phoneNumber: phoneNumber, code: code, rememberToken: getData(key: "tempRememberToken") as! String) { (response, error) in
                if response != nil{
                    if (self.checkRespondStatus(respond: response!["respond"] as! Int)){
                        let rememberToken = ((response!["data"]! as! NSDictionary)["account"]! as! NSDictionary)["remember_token"] as! String
                        self.updataData(key: "rememberToken", value: rememberToken)
                        self.updataData(key: "isLoggedIn", value: true)
                        self.updateFcmToken(rememberToken)
                        self.animationView.stop()
                        self.animationView.isHidden = true
                        self.dismiss(animated: true, completion: nil)
                        self.onDoneBlock!(false)
                    }
                    else{
                        self.animationView.isHidden = true
                        self.popUpUIView.isHidden = false
                        self.phoneCodeDemandUITextfield.text = ""
                        self.phoneCodeDemandUITextfield.becomeFirstResponder()
                        self.animationView.stop()

                        
                    }
                    
                }
                else{
                    debugPrint(error!)
                    self.showToast(message: "در انجام عملیات خطایی رخ داده، مجددا تلاش نمایید")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        
    }
    
    func showDialoge(){
        popUpUIView.isHidden = false
        phoneCodeDemandUITextfield.becomeFirstResponder()
        if (phoneCodeDemandUITextfield != nil) {
            titleUILabel.text="کد فعال‌ سازی ارسال ‌شده به شماره \(self.phoneNumber!) را وارد نمایید"
            descriptionUILabel.text = "\(count) ثانیه تا فعال شدن ارسال مجدد کد"
            phoneCodeDemandUITextfield.placeholder = "کد فعال ‌سازی"
            phoneCodeDemandUITextfield.text = ""
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:(#selector(updateUI)), userInfo: nil, repeats: true)
        }
        else{
            //error
        }
    
    
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.frame = CGRect(x: (self.view.bounds.midX - self.view.frame.width/4/2*3), y: (self.view.bounds.midY - self.view.frame.height/4/2*3), width: self.view.frame.width/4*3, height: self.view.frame.height/4*3)
        animationView.contentMode = .scaleAspectFit
        animationView.loopAnimation = true
        self.view.addSubview(animationView)
        animationView.isHidden = true
        phoneCodeDemandUITextfield.delegate = self
        phoneCodeDemandUITextfield.becomeFirstResponder()
        submitUIButton.layer.cornerRadius = 5
        cancelUIButton.layer.cornerRadius = 5
        cancelUIButton.layer.borderWidth = 1
        popUpUIView.layer.cornerRadius = 3
        phoneCodeDemandUITextfield.layer.borderWidth = 1
        phoneCodeDemandUITextfield.layer.borderColor = cancelUIButton.currentTitleColor.cgColor
        submitUIButton.layer.borderColor = submitUIButton.currentTitleColor.cgColor
        cancelUIButton.layer.borderColor = cancelUIButton.currentTitleColor.cgColor
        resendUIButton.isHidden = true
    }


    @objc func updateUI() {
        if(count > 1) {
            count-=1
   descriptionUILabel.text = "\(count) ثانیه تا فعال شدن ارسال مجدد کد"        }
        else{
            
            timer.invalidate()
            //timer = Timer()
            descriptionUILabel.isHidden = true
            resendUIButton.isHidden = false

        }
        
    }
    func updateFcmToken(_ rememberToken:String){
        let token = getData(key: "fCMToken") as! String
        if token != "none"{
        APIClient.postNotificationToken(rememberToken: rememberToken, requestParams: ["device_type":"ios", "remember_token_notification":"\(token)"], completionHandler: { (response, error) in
            if response != nil {
                debugPrint(response as Any)
            }else{
                self.updateFcmToken(token)
            }
        })
        }}
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = 11
        if !isPhoneNumber{
            maxLength = 5
        }
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
