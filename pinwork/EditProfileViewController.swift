//
//  EditProfileViewController.swift
//  pinwork
//
//  Created by Pouyan on 7/18/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    var user :User?
    var animationView : UIView!
    @IBOutlet var profileSectionsViews: [UIView]!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var fullNameTextField: UITextField!
    
    @IBOutlet weak var cellPhoneNumberTextField: UITextField!
    
    @IBOutlet weak var primaryPhoneNumberTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for item in profileSectionsViews{
        item.clipsToBounds = true
        item.layer.borderWidth = 1
        item.layer.borderColor = getPinworkColors(color: 1).cgColor
        item.layer.cornerRadius = 5
        submitButton.clipsToBounds = true
        submitButton.layer.cornerRadius = 5
        primaryPhoneNumberTextField.keyboardType = .numberPad
        self.fetchProfileValues()
            
        // Do any additional setup after loading the view.
        
    }
    }
    
    
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        var elementsForUpdate : [String:String] = [:]
        if !(emailTextField.text?.isEmptyOrWhitespace())!{
            if isValidEmail(testStr: emailTextField.text!){
                elementsForUpdate["email"] = emailTextField.text!
            }
            else{
                showToast(message: "لطفا ایمیل خود را به شکل صحیح وارد نمایید")
            return
            }
        }
        if (fullNameTextField.text?.isEmptyOrWhitespace())!{
            showToast(message: "لطفا نام و نام خانوادگی خود را وارد نمایید")
        }else{
           let nameParts = fullNameTextField.text!.components(separatedBy:" ")
            if nameParts.count > 1 {
                if !nameParts[1...].joined(separator: " ").isEmptyOrWhitespace(){
                elementsForUpdate["name"] = nameParts[0]
                elementsForUpdate["lastname"] = nameParts[1...].joined(separator: " ")
                }
                else{
                    showToast(message: "لطفا نام خانوادگی را به درستی وارد نمایید")
                return
                }
            }
            else{
                showToast(message: "لطفا نام خانوادگی خود را با فاصله از نام کوچک خود وارد نمایید")
                return
            }
        }
        if (primaryPhoneNumberTextField.text?.isEmptyOrWhitespace())!{
            showToast(message: "لطفا شماره تلفن ثابت خود را وارد نمایید")
            return
        }else{
            if !(primaryPhoneNumberTextField.text!.count == 8) {
                showToast(message: "شماره تلفن خود را بدون کد شهر و در ۸ رقم وارد نمایید")
                return
            }
            else{
                elementsForUpdate["phone_place"] = "021" + primaryPhoneNumberTextField.text!.convertToEngNumToSend()
            }
        }
        updateProfile(elementsForUpdate)
        
    }
    func updateProfile(_ requestParams:[String:String]){
      animationView = self.displaySpinner(onView: self.view)
        APIClient.requestForProfileUpdate(rememberToken: getData(key: "rememberToken") as! String,requestParams: requestParams) { (response, error) in
            if response != nil{
                if self.tokenHasExpired(response!["respond"].intValue){
                    self.showTokenExpiredPopUp()
                }
                else{
                let data = response!["data"]["profile"]
                self.user?.name = data["name"].string!
                self.user?.lastName = data["lastname"].string!
                self.user?.orders_count = data["orders_count"].intValue
                self.user?.money = data["money"].intValue
                
            }}else{
                let retry = self.showNetworkRetryPopUp()
                retry.onDoneBlock = { result in
                    self.updateProfile(requestParams)
                }
            }
            self.removeSpinner(spinner: self.animationView)
            self.showInfoToast(message: "تغییرات با موفقیت اعمال شد")
        }
    }
    func fetchProfileValues(){
      
        
        self.fullNameTextField.text = (user?.name!)! + " " + (user?.lastName)!
                self.cellPhoneNumberTextField.text = ""
                self.primaryPhoneNumberTextField.text = user?.phone_place.convertToPersian()
                self.emailTextField.text = user?.email
                self.cellPhoneNumberTextField.text = user?.cellPhone.convertToPersian()
                
             
        
            
        }
        
    override func willMove(toParentViewController parent: UIViewController?) {
        let parntView = parent as? MenuViewController
        parntView?.user = self.user
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
