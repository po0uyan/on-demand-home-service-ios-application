//
//  PopUpPickerViewController.swift
//  pinwork
//
//  Created by Pouyan on 6/13/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit

class PopUpPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var submitUIButton: UIButton!
    
    @IBOutlet weak var pickerTitle: UILabel!
    @IBOutlet weak var cancelUIButton: UIButton!
    
    @IBOutlet weak var pickerView: UIPickerView!
    var titleString = ""
    var attribites = [String]()
    var onDoneBlock : ((Int) -> Void)?

    @IBAction func submitClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        onDoneBlock!(pickerView.selectedRow(inComponent: 0))
    }
    @IBAction func cancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()

    }
    func setting(){
        submitUIButton.layer.cornerRadius = 5
        cancelUIButton.layer.cornerRadius = 5
        cancelUIButton.layer.borderWidth = 1
        submitUIButton.layer.borderColor = submitUIButton.currentTitleColor.cgColor
        cancelUIButton.layer.borderColor = cancelUIButton.currentTitleColor.cgColor
        innerView.layer.cornerRadius = 5
        pickerView.showsSelectionIndicator = true
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerTitle.text = titleString
        pickerView.selectRow(1, inComponent: 0, animated: true)
    }
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return attribites.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return attribites[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // use the row to get the selected row from the picker view
        // using the row extract the value from your datasource (array[row])
    }
 
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view {
            label = v as! UILabel
        }
        label.font = UIFont(name: "IRAN SansMobile(NoEn)", size: 17.0)
        label.text =  attribites[row]
        label.textAlignment = .center
        return label
        
    }
    func pickerView(_ pickerView: UIPickerView,
                    rowHeightForComponent component: Int) -> CGFloat{
        return CGFloat(35)
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
