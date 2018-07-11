//
//  WorkerPickerViewController.swift
//  pinwork
//
//  Created by Pouyan on 6/23/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit

class WorkerPickerViewController: UIViewController , UITextViewDelegate {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceLabelConstraint: NSLayoutConstraint!
  
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var thirdView: UIView!
    
    @IBOutlet weak var addWorkerView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    var OrderTillNow :Dictionary<String,Any> = [:]
    var nextLevelButton : UIButton?
    var currentPrice : String?
    var workerCount = 1
    var isFailed = false
    @IBAction func addWorkerClicked(_ sender: UIButton) {
        if workerCount == 1{
            UIView.animate(withDuration: 0.8, animations: {
                self.secondView.isHidden = false

                })
        }
        else if workerCount == 2{
            UIView.animate(withDuration: 0.8 , animations:{
                self.thirdView.isHidden = false
                self.addWorkerButton.isHidden = true
                self.addWorkerView.isHidden = true
            })
            
        }
        workerCount+=1
        goForEstimate()
        
    }
    
    @IBAction func removeClicked(_ sender: UIButton) {
        if workerCount == 3{
            UIView.animate(withDuration: 0.8,animations: {
                self.thirdView.isHidden = !self.thirdView.isHidden
                self.addWorkerView.isHidden = !self.addWorkerView.isHidden
                self.addWorkerButton.isHidden = !self.addWorkerButton.isHidden

                self.view.layoutIfNeeded()
            })
            
        }
        else if workerCount == 2{
            UIView.animate(withDuration: 0.8 , animations:{
                self.secondView.isHidden = !self.secondView.isHidden
                self.view.layoutIfNeeded()

            })
        }
    workerCount -= 1
    goForEstimate()
    }
    
    @IBAction func firstRowClicked(_ sender: UIButton) {
        switch sender.restorationIdentifier {
        case "0":
            for i in selecTedRow[0].indices{
                selecTedRow[0][i] = false
            }
            selecTedRow[0][0] = true
        case "1":
            for i in selecTedRow[0].indices{
                selecTedRow[0][i] = false
            }
            selecTedRow[0][1] = true
        case "2":
            for i in selecTedRow[0].indices{
                selecTedRow[0][i] = false
            }
            selecTedRow[0][2] = true
            
        default:
            break
        }
        updateMyButtons()

    }
    
    @IBAction func secondRowClicked(_ sender: UIButton) {
        switch sender.restorationIdentifier {
        case "3":
            for i in selecTedRow[1].indices{
                selecTedRow[1][i] = false
            }
            selecTedRow[1][0] = true
        case "4":
            for i in selecTedRow[1].indices{
                selecTedRow[1][i] = false
            }
            selecTedRow[1][1] = true
        case "5":
            for i in selecTedRow[1].indices{
                selecTedRow[1][i] = false
            }
            selecTedRow[1][2] = true
            
        default:
            break
        }
        updateMyButtons()

    }
    
    
    @IBAction func thirdRowClicked(_ sender: UIButton) {
        switch sender.restorationIdentifier {
        case "6":
            for i in selecTedRow[2].indices{
                selecTedRow[2][i] = false
            }
            selecTedRow[2][0] = true
        case "7":
            for i in selecTedRow[2].indices{
                selecTedRow[2][i] = false
            }
            selecTedRow[2][1] = true
        case "8":
            for i in selecTedRow[2].indices{
                selecTedRow[2][i] = false
            }
            selecTedRow[2][2] = true
            
        default:
            break
        }
        updateMyButtons()
    }
    
    
    
    @IBOutlet var WMLabels: [UILabel]!
    @IBOutlet var MLabels: [UILabel]!
    @IBOutlet var NOLabels: [UILabel]!
    var allLabels = [[UILabel]]()

    @IBOutlet var WMButton: [UIButton]!
    @IBOutlet var MButtons: [UIButton]!
    @IBOutlet var NOButtons: [UIButton]!

    @IBOutlet weak var addWorkerButton: UIButton!
    var allButtons = [[UIButton]]()
    var selecTedRow = [[false,false,true],[false,false,true],[false,false,true]]
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        secondView.isHidden = true
        thirdView.isHidden = true

    }

    func setting(){
        priceLabel.clipsToBounds = true
        priceLabel.layer.cornerRadius = 8
        priceLabel.text! = currentPrice!
        addWorkerButton.layer.borderWidth = 1
        addWorkerButton.layer.cornerRadius = 8
        addWorkerButton.layer.borderColor = priceLabel.backgroundColor?.cgColor
        addWorkerButton.setTitleColor(priceLabel.backgroundColor, for: .normal)
        prepareButtons()
        descriptionTextView.delegate = self
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 8
        descriptionTextView.layer.borderColor = getPinworkColors(color: 1).cgColor
        descriptionTextView.keyboardAppearance = .light
        descriptionTextView.text = "توضیحات خود را اینجا وارد نمایید..."
        descriptionTextView.textColor = UIColor.lightGray
        nextLevelButton = getUIBarButtonItem(title: "مرحله بعدی", image: "move-to-next")
        var items = [UIBarButtonItem]()
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        items.append( UIBarButtonItem(customView: nextLevelButton!))
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        nextLevelButton!.addTarget(self, action: #selector(self.nextLevelClicked), for: .touchUpInside)
        self.toolbarItems = items
    
    
    
    }
    @objc func nextLevelClicked(){
        if isFailed{
            goForEstimate()
        }
        else{

        performSegue(withIdentifier: "MapViewSegue", sender: self)

        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MapViewController {
            if descriptionTextView.text != "" && descriptionTextView.text != "توضیحات خود را اینجا وارد نمایید..." {
            OrderTillNow["description"] = descriptionTextView.text
                
            }
            destination.OrderTillNow = OrderTillNow
        }
        
    }
    
    
    func prepareButtons(){
        allButtons.append (WMButton)
        allButtons.append(MButtons)
        allButtons.append(NOButtons)
        allLabels.append(WMLabels)
        allLabels.append(MLabels)
        allLabels.append(NOLabels)
        var origImage = UIImage(named: "female")
        var tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        for (index ,item) in allButtons.enumerated(){
            switch index{
            case 0:
                origImage = UIImage(named: "female")
                tintedImage = origImage?.withRenderingMode(.alwaysTemplate)

            case 1:
                origImage = UIImage(named: "male")
                tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            case 2:
                origImage = UIImage(named: "femaleAndMale")
                tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            default:
                break
            }
            for (_index , button)in item.enumerated(){
                button.setImage(tintedImage, for: .normal)
                if selecTedRow[_index][index]{
                    
                    button.tintColor = getPinworkColors(color: 1).withAlphaComponent(0.5)
                    allLabels[index][Int(button.restorationIdentifier!)!/3].textColor =  getPinworkColors(color: 1).withAlphaComponent(0.5)
                }
                else{
                    button.tintColor = UIColor.gray.withAlphaComponent(0.3)
                    
                }
            }
            
            
        }
        
    }
        
        func updateMyButtons(){
            for (index ,item) in allButtons.enumerated(){
                for  button in item {
                    if selecTedRow[Int(button.restorationIdentifier!)!/3][index]{
                        
                        UIView.animate(withDuration: 0.8,animations: {
                            button.tintColor = self.getPinworkColors(color: 1).withAlphaComponent(0.5)
                            self.allLabels[index][Int(button.restorationIdentifier!)!/3].textColor =  self.getPinworkColors(color: 1).withAlphaComponent(0.5)
                            self.view.layoutIfNeeded()
                        })
                    }
                    else{
                        UIView.animate(withDuration: 0.8,animations: {
                            button.tintColor = UIColor.gray.withAlphaComponent(0.3)
                            self.allLabels[index][Int(button.restorationIdentifier!)!/3].textColor =  UIColor.gray.withAlphaComponent(0.3)
                            self.view.layoutIfNeeded()
                        })
                    }
                }
               
                
                
            }
            goForEstimate()
            
        }
    func goForEstimate(){
            self.showCostEstimateProgress()
            self.priceLabelConstraint.constant = -30
            UIView.animate(withDuration: 0.6,animations: {
                self.view.layoutIfNeeded()
            })
            
            prepareRequest()
            APIClient.estimateHomeOrOfficeCleaningPrice(requestArray: OrderTillNow, completionHandler: { (response, error) in
                self.hideCostEstimateProgress()
                self.nextLevelButton!.setTitle("مرحله بعدی", for: .normal)
                self.nextLevelButton!.setImage(UIImage(named: "move-to-next")?.withRenderingMode(.alwaysOriginal), for: .normal)
                self.toolbarItems?.insert(UIBarButtonItem(customView: self.nextLevelButton!), at: 1)
                
                if response != nil{
                    self.priceLabel.text! = "برآورد قیمت : " +
                        String((response!["data"] as! NSDictionary)["price"] as! Int).convertToPersian() + " تومان "
                    self.priceLabelConstraint.constant = 10
                    UIView.animate(withDuration: 0.9,animations: {
                        self.view.layoutIfNeeded()
                    })
                }else{
                    //retry
                    self.showToast(message: "خطا در ارتباط، لطفا جهت محاسبه قیمت، از پایین صفحه تلاش مجدد را انتخاب نمایید.")
                    self.isFailed = true
                    self.nextLevelButton!.setTitle(" تلاش مجدد  ", for: .normal)
                    self.nextLevelButton!.setImage(UIImage(named: "refresh")?.withRenderingMode(.alwaysOriginal), for: .normal)                }
            })
            
            
        
        
        
    }
    func prepareRequest(){
      
        OrderTillNow["worker_count_request"] = workerCount
        OrderTillNow["man_count_request"] = getManCount()
        OrderTillNow["woman_count_request"] = getWomanCount()
        //let token = self.getData(key: "rememberToken") as! String
        let token2 = "fced86ff2ba6060a396d18639974900ff425352f"
        OrderTillNow["remember_token"] = token2
    }
    func getManCount()->Int{
        var tmp = 0
    for i in 0..<workerCount{
        if selecTedRow[i][1]{
            tmp+=1
        }
    }
        return tmp
    
    }
    func getWomanCount()->Int{
        var tmp = 0
        for i in 0..<workerCount{
            if selecTedRow[i][0]{
                tmp+=1
            }
        }
        return tmp
    }
       
    func updatePrice(){
        
        
        
        
    }
    
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "توضیحات خود را اینجا وارد نمایید..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count // for Swift use count(newText)
        return numberOfChars < 599
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
