//
//  AddressPopUpViewController.swift
//  pinwork
//
//  Created by Pouyan on 7/5/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit
import SwiftyJSON
class AddressPopUpViewController: UIViewController,UITextViewDelegate ,UITextFieldDelegate{
    var order : Order!
    var loadingView : UIView!
    @IBOutlet weak var addressTextView: UITextView!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var insideView: UIView!
    var onDoneBlock : ((Int) -> Void)?
    
    
    @IBAction func favoritesWorkerChanged(_ sender: UISwitch) {
        if sender.isOn {
            self.order.orderTillNow["only_favorites"] = 1

        }
        else{
            self.order.orderTillNow["only_favorites"] = 0

        }
    }
    
    
    
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
        onDoneBlock!(0)
    }
    
    @IBAction func submitButtonClikcked(_ sender: UIButton) {
        if order.orderType == .otherServices {
            if everyThingIsOK(){
                self.order.orderTillNow["phone"] = ("021" + (phoneNumberTextField.text)!).convertToEnglish()
                
                self.order.orderTillNow["address"] = addressTextView.text!
            
            
            self.dismiss(animated: true)
            onDoneBlock!(2)
                return
                
            }
        }
     goForRegisteringOrder()
        
        
        
    }
    
    func goForRegisteringOrder(){
        
        if everyThingIsOK(){
            self.order.orderTillNow["service_number"] = ("021" + (phoneNumberTextField.text)!).convertToEnglish()
            
            self.order.orderTillNow["address"] = addressTextView.text!
            loadingView = displaySpinner(onView: self.view)
            self.order.registerOrder { (response, error) in
                self.removeSpinner(spinner: self.loadingView)
                if response != nil {
                    if response!["respond"] == 200{
                        self.showDoneProgressAndGoBack(response!["data"]["service_code"].stringValue)
                    }
                    else{
                        self.showToast(message: "خطا، لطفا با پشتیبانی تماس بگیرید")
                    }
                }
                else{
                    let retry = self.showNetworkRetryPopUp()
                    retry.onDoneBlock = { result in
                        self.goForRegisteringOrder()
                        
                    }
                }
            }
            
        }}
    func everyThingIsOK()->Bool{
        if addressTextView.text.isEmptyOrWhitespace() || addressTextView.text == "آدرس دقیق خود را وارد نمایید"{
            showToast(message: "لطفا آدرس خود را وارد نمایید.")
        }
        else if (phoneNumberTextField.text?.isEmptyOrWhitespace())! || phoneNumberTextField.text == "تلفن ثابت" || phoneNumberTextField.text?.count != 8
        {
            showToast(message: " لطفا شماره تلفن ثابت محل مورد نظر را به درستی وارد نمایید")
        }else{
            if MainViewController.isCommingFromRegister && order.orderType != .otherServices{
                performSegue(withIdentifier: "compeleteSignUpSegue", sender:self)
                
            }
            else{
                return true
            }
        }
        return false

    }
    
    func showDoneProgressAndGoBack(_ serviceCode: String){
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let doneAlertView = storyBoard.instantiateViewController(withIdentifier: "RegisterringDone") as! RegisterringDoneViewController
        doneAlertView.serviceCode = serviceCode
        doneAlertView.modalTransitionStyle = .crossDissolve
        doneAlertView.isModalInPopover = true
        doneAlertView.modalPresentationStyle = .overCurrentContext
        self.present(doneAlertView, animated: true)
        doneAlertView.onDoneBlock = { result in
            self.dismiss(animated: false, completion: { self.onDoneBlock!(1)})
           
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let completRegister = segue.destination as? CompeleteRegisterFormViewController{
            completRegister.onDoneBlock={result in
                if result == 0 {
                    self.goForRegisteringOrder()
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSetting()
    }

    func configureSetting(){
        addressTextView.delegate = self
        phoneNumberTextField.delegate = self
        addressTextView.layer.borderWidth = 1
        addressTextView.layer.cornerRadius = 8
        addressTextView.layer.borderColor = getPinworkColors(color: 1).cgColor
        
        phoneNumberTextField.layer.borderWidth = 1
        phoneNumberTextField.layer.cornerRadius = 8
        phoneNumberTextField.layer.borderColor = getPinworkColors(color: 1).cgColor
        submitButton.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.borderWidth = 1
        submitButton.layer.borderColor = getPinworkColors(color: 1).cgColor
        cancelButton.layer.borderColor = getPinworkColors(color: 1).cgColor
        insideView.layer.cornerRadius = 8
        addressTextView.text = self.order.orderTillNow["address"] as! String
        self.order.orderTillNow["only_favorites"] = 0
        phoneNumberTextField.keyboardType = .numberPad
        phoneNumberTextField.text = "تلفن ثابت"
        phoneNumberTextField.textColor = UIColor.lightGray
    }
    
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "آدرس دقیق خود را وارد نمایید"
            textView.textColor = UIColor.lightGray
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
                textField.text = "تلفن ثابت"
                textField.textColor = UIColor.lightGray
            }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            let numberOfChars = newText.count // for Swift use count(newText)
            return numberOfChars < 300
        
      
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 8
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
