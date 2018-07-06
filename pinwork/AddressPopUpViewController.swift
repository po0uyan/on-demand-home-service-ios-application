//
//  AddressPopUpViewController.swift
//  pinwork
//
//  Created by Pouyan on 7/5/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit

class AddressPopUpViewController: UIViewController,UITextViewDelegate ,UITextFieldDelegate{

    @IBOutlet weak var addressTextView: UITextView!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var insideView: UIView!
    var onDoneBlock : ((Bool) -> Void)?
    var addressText = "آدرس انتخابی"
    @IBAction func cancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
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
        addressTextView.text = addressText
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
