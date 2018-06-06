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
class ActivationCodeDemandViewController: UIViewController{
    var onDoneBlock : ((Bool) -> Void)?
    let animationView = LOTAnimationView(name: "trail_loading")

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
        requestForAuthCode(action: "register",phoneNumber:  self.phoneNumber)
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
                    self.phoneNumber = phoneCodeDemandUITextfield.text!
                    popUpUIView.isHidden = true
                    animationView.play()
                    animationView.isHidden = false
                    requestForAuthCode(action: "register",phoneNumber: self.phoneNumber)
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
                        codeCheckRequest(code: phoneCodeDemandUITextfield.text!)
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
        APIClient.codeRequestForLoginOrRegister(phoneNumber:self.phoneNumber, action:action,rememberToken: getData(key: "tempRememberToken") as! String){
            responseObject, error in
            if responseObject != nil{
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
                self.dismiss(animated: true, completion: nil)
                self.showToast(message: "در انجام عملیات خطایی رخ داده، مجددا تلاش نمایید")
                self.animationView.stop()
            }
            
        }
  
    }
    func checkRespondStatus(respond: Int)->Bool{
        let error: Dictionary<Int,String> = [403 : "کاربر اجازه ورود ندارد، لطفا با پشتیبانی تماس بگیرید"
            ,404: "درخواست مورد نظر پیدا نشد "
            ,4041:"این شماره قبلا ثبت نام شده‌است"
            ,4042:"این شماره قبلا ثبت نام نشده است "
            ,500:"سرور دچار مشکل شده‌است"
            ,5002:"خطا در ایجاد پیامک"
            ,5005:"کد وارد شده معتبر نمی‌باشد"
            ,5007:"تاریخ استفاده از کد تخفیف به پایان رسیده‌است"
            ,5008:"تعداد سقف کد تخیف به اتمام رسیده‌است"
            ,5009:"سرویس‌دهنده یافت نشد"
            ,50010:"سرویس دهنده یافت نشد"
            ,50011:"سرویس دهنده قبلا محبوب شده‌است"
            ,50014:"سرویس یافت نشد"
            ,50016:"تیکت یافت نشد"
            ,50017:"موضوع تیکت یافت نشد"
            ,50018:"سرویس یافت نشد"
            ,50019:"کد تخفیف یافت نشد"
            ,50020: "این کد تخفیف قبلا استفاده شده‌است"
            ,2001:"مبلغ خرید برای استفاده از کد تخفیف کمتر از حداقل مجاز است، کد اعمال نخواهد شد"
            ,2002:"مبلغ خرید از سقف مجاز برای تخفیف بالاتر است، سقف تخفیف برای شما در نظر گرفته خواهد شد."
            ,500160:"این مکالمه به پایان رسید‌ه‌است، درصورت نیاز پشتیبانی جدید ایجاد نمایید"
            ,50021:"این سرویس قبلا به اتمام رسیده‌است"
            ,50022:"زمان پایان غیر مجاز"
            ,50023:"زمان شروع غیر مجاز"
            ,50024:"زمان پایان جلوتر از ساعت فعلی"
            ,50025:"زمان درخواست سفارش غیر مجاز"
            ,50026:"زمان درخواست سفارش غیر مجاز"
    ,50050:"کد اعتبارسنجی منقضی شده‌است"]
        if let message = error[respond]{
                showToast(message: message)
            
        }else{
            if respond != 200{
            showToast(message: "خطا، لطفا با پشتیبانی تماس بگیرید")
                
            }
            else{
                return true
            }
        }
    return false
    }
    
    func codeCheckRequest(code: String){
        APIClient.codeCheckForRegister(phoneNumber:phoneNumber, code:code,rememberToken: getData(key: "tempRememberToken") as! String){
            responseObject, error in
            if responseObject != nil{
            let rememberToken = (responseObject!["data"] as! NSDictionary)["remember_token"]
            self.updataData(key: "rememberToken", value: rememberToken!)
            self.updataData(key: "isLoggedIn", value: true)
            self.animationView.stop()
            self.animationView.isHidden = true
            self.dismiss(animated: true, completion: nil)
            self.onDoneBlock!(true)
            }
            else{
                debugPrint(error!)
                self.showToast(message: "در انجام عملیات خطایی رخ داده، مجددا تلاش نمایید")
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
