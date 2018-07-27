import UIKit

class OtherServicesOrderViewController: UIViewController,UITextViewDelegate {

    
    var order : Order!
    var reservedOrderButton : UIButton!
    var calendar = Calendar(identifier: .persian)
    let  startTime = ["۹:۰۰","۹:۳۰","۱۰:۰۰","۱۰:۳۰","۱۱:۰۰","۱۱:۳۰","۱۲:۰۰","۱۲:۳۰","۱۳:۰۰","۱۳:۳۰","۱۴:۰۰","۱۴:۳۰","۱۵:۰۰","۱۵:۳۰","۱۶:۰۰","۱۶:۳۰","۱۷:۰۰","۱۷:۳۰","۱۸:۰۰","۱۸:۳۰","۱۹:۰۰"]
    var loadingView : UIView!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var startDateTimeButton: UIButton!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBAction func startDateTimeClicked(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let popUpDateTime = storyBoard.instantiateViewController(withIdentifier: "datepickerpopup") as! PopUpDatePickerViewController
        popUpDateTime.validDates = getValidDatesForType()
        popUpDateTime.validTimes = startTime
        popUpDateTime.limit = startTime.count
        popUpDateTime.modalTransitionStyle = .crossDissolve
        popUpDateTime.isModalInPopover = true
        popUpDateTime.modalPresentationStyle = .overCurrentContext
        self.present(popUpDateTime, animated: true)
        popUpDateTime.onDoneBlock = { date , time in
            let _startTime = self.startTime[time]
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            formatter.dateFormat = "yyyy-MM-dd"
            let stringTime = formatter.string(from: date)
            self.order.orderTillNow["default_start_date"] = (stringTime + " " + _startTime.convertToEnglish() + ":00")
            self.startDateTimeButton.setTitle(self.getProperDate(date: date) + " ساعت " + _startTime, for: .normal)
             }}
    
    
    @IBAction func addressInfoButtonClicked(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "MapViewSegue", sender: self)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mapView = segue.destination as? MapViewController{
            mapView.order = self.order
        }
    }
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if  MainViewController.isCommingFromRegister{
            self.navigationController?.setToolbarHidden(false, animated: false)
        }
        reservedOrderButton = getUIBarButtonItemForNextLevel(title: " ثبت نهایی سفارش ", image: "check")
        var items = [UIBarButtonItem]()
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        items.append( UIBarButtonItem(customView: reservedOrderButton!))
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        reservedOrderButton!.addTarget(self, action: #selector(self.registerOrderClicked), for: .touchUpInside)
        self.toolbarItems = items
        startDateTimeButton.layer.borderWidth = 1
        addressButton.layer.borderWidth = 1
        startDateTimeButton.layer.cornerRadius = 8
        addressButton.layer.cornerRadius = 8
        startDateTimeButton.layer.borderColor = getPinworkColors(color: 1).cgColor
        addressButton.layer.borderColor = getPinworkColors(color: 1).cgColor
     descriptionTextView.clipsToBounds = true
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = getPinworkColors(color: 1).cgColor
        descriptionTextView.layer.cornerRadius = 8
        descriptionTextView.delegate = self
        descriptionTextView.text = "توضیحات خود را اینجا وارد نمایید..."
        descriptionTextView.textColor = UIColor.lightGray
        
        //addressButton.tit
    }
    
    
    @objc func registerOrderClicked(){
        if everyThingIsOK(){

            registerOrder()
        }
        
        
    }
    func registerOrder(){
        self.order.orderTillNow["content"] = descriptionTextView.text!
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
                    self.registerOrder()
                    
                }
            }
        }
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
            self.navigationController?.popToRootViewController(animated: true)

            
        }
        
        
    }
    
    func getValidDatesForType()->[Date]{
        var date = Date()
        var dateComponent = DateComponents()
        var tempDateArray = [Date]()
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        dateComponent.day = 1
        if hour == 20 && minutes >= 59{
            date = Calendar.current.date(byAdding: dateComponent, to: date)!
            
        }
        else if hour >= 21{
            date = Calendar.current.date(byAdding: dateComponent, to: date)!
            
        }
        
        for _ in 1...14{
            date = Calendar.current.date(byAdding: dateComponent, to: date)!
            tempDateArray.append(date)
            
        }
        return tempDateArray
    }
    func everyThingIsOK()->Bool{
        if (addressButton.currentTitle == "انتخاب کنید") {
            showToast(message: "لطفا تاریخ و ساعت شروع کار را انتخاب نمایید")
            
            
        }else if startDateTimeButton.currentTitle == "انتخاب کنید"{
            showToast(message: "لطفا آدرس و شماره تلفن را انتخاب نمایید")

   
        }else if (descriptionTextView.text.isEmptyOrWhitespace() || descriptionTextView.text == "توضیحات خود را اینجا وارد نمایید..."){
            showToast(message: "لطفا توضیح مختصری در رابطه با سفارش خود بنویسید")
            
        }else if MainViewController.isCommingFromRegister{
            showCompleteRegisterView()
            
        }else{
            return true

        }
    
    return false
        
    }
    func showCompleteRegisterView(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let completeRegisterView = storyBoard.instantiateViewController(withIdentifier: "compeleteRegister") as! CompeleteRegisterFormViewController
        completeRegisterView.modalTransitionStyle = .crossDissolve
        completeRegisterView.isModalInPopover = true
        completeRegisterView.modalPresentationStyle = .overCurrentContext
        self.present(completeRegisterView, animated: true)
        completeRegisterView.onDoneBlock = {result in
            if result == 0 {
                self.registerOrder()
            }
            
        }
        
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
        return numberOfChars < 250
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
