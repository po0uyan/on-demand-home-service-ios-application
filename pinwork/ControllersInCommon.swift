//
//  ControllersInCommon.swift
//  pinwork
//
//  Created by Pouyan on 6/7/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import Foundation
import UIKit
import BRYXBanner
import CoreData
import Lottie
import SwiftyJSON
extension UIView
{
    func copyView<T: UIView>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
}
extension String {
    func convertEngNumToPersianNum()->String{
        let format = NumberFormatter()
        format.locale = Locale(identifier: "fa_IR")
        let number =   format.number(from: self)
        
        let faNumber = format.string(from: number!)
        return faNumber!
        
    }
    func convertToEngNumToSend()->String{
        let Formatter = NumberFormatter()
        Formatter.numberStyle = .none
        Formatter.minimumIntegerDigits = self.count
        Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
        return (Formatter.number(from: self)?.stringValue)!
    }
    func convertToPersian()-> String {
        let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
        var str : String = self
        
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        
        return str
    }
    func convertToEnglish()-> String {
        let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
        var str : String = self
        
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: value, with: key)
        }
        
        return str
    }
    
    func isEmptyOrWhitespace() -> Bool {
        
        if(self.isEmpty) {
            return true
        }
        
        return (self.trimmingCharacters(in: .whitespaces).isEmpty)
    }
}

extension UIViewController {
    
    
   
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func check(_ value: JSON?) -> String {
        if let result = value?.string {
            return result
        }
        else {
            return ""
        }
    }
    func tokenHasExpired(_ respond: Int)->Bool{
        return respond == 4040
    }
    
    func showNetworkRetryPopUp()->RetryViewController{
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let retryPopUpController = storyBoard.instantiateViewController(withIdentifier: "RetryViewController") as! RetryViewController
        retryPopUpController.modalTransitionStyle = .crossDissolve
        retryPopUpController.isModalInPopover = true
        retryPopUpController.modalPresentationStyle = .overCurrentContext
        self.present(retryPopUpController, animated: true)
        return retryPopUpController
    }
    func showTokenExpiredPopUp(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tokenExpiredPopUpController = storyBoard.instantiateViewController(withIdentifier: "tokenExpired") as! TokenExpiredViewController
        tokenExpiredPopUpController.modalTransitionStyle = .crossDissolve
        tokenExpiredPopUpController.isModalInPopover = true
        tokenExpiredPopUpController.modalPresentationStyle = .overCurrentContext
        self.present(tokenExpiredPopUpController, animated: true)
    }
    
     func displaySpinner(onView : UIView) -> UIView {
        let ai = LOTAnimationView(name: "loading2")
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        ai.frame = CGRect(x: (onView.bounds.midX - onView.frame.width/4/2*3), y: (onView.bounds.midY - onView.frame.height/4/2*3), width: onView.frame.width/4*3, height: onView.frame.height/4*3)
        ai.contentMode = .scaleAspectFit
//        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
//        ai.startAnimating()
        ai.play()
        ai.loopAnimation = true
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
     func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
            
        }
    }
    
    
    
    
    
    
    func getProgressStuff()->[UIBarButtonItem]{
        var items = [UIBarButtonItem]()

        let uiBusy = UIActivityIndicatorView()
        uiBusy.color = self.getPinworkColors(color: 1)
        uiBusy.sizeToFit()
        
        uiBusy.hidesWhenStopped = true
        uiBusy.startAnimating()
        let bb = UIBarButtonItem(customView: uiBusy)
        let lbl = UILabel(frame: CGRect(x: 10, y: 50, width: 230, height: 25))
        lbl.textAlignment = .center //For center alignment
        lbl.text = " در حال برآورد هزینه... "
        lbl.textColor = .white
        //              lbl.backgroundColor = .lightGray
        lbl.font = UIFont(name: "IRAN SansMobile(NoEn)", size: 16.0)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.sizeToFit()
        items.append( UIBarButtonItem(customView: lbl))
        items.append(bb)
        return items
    
       
        
        
    }
    
    
    func showCostEstimateProgress(){
        self.toolbarItems?.remove(at: 1)
        self.toolbarItems?.insert(contentsOf: self.getProgressStuff(), at: 1)
    }
    func hideCostEstimateProgress(){
        self.toolbarItems?.removeSubrange(1...2)
        }
    
    func getProperDate(date:Date)->String{
        var calendar = Calendar(identifier: .persian)
        let myLocale = Locale(identifier: "fa_IR")
        calendar.locale = myLocale
        var datecmpts = calendar.dateComponents([.day, .month, .weekday], from: date)
        
        
        return "\(calendar.weekdaySymbols[datecmpts.weekday! - 1]) \(datecmpts.day!) \(calendar.monthSymbols[datecmpts.month! - 1])".convertToPersian()
        
    }
    func getProperDate(inputStringDate:String)->String{
            let format = "yyyy-MM-dd HH:mm:ss"
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
            dateFormatter.locale = Locale(identifier: "fa-IR")
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.dateFormat = format
            let date = dateFormatter.date(from: inputStringDate)
            var calendar = Calendar(identifier: .persian )
            let myLocale = Locale(identifier: "fa_IR")
            calendar.locale = myLocale
            var datecmpts = calendar.dateComponents([.day, .month, .weekday, .year], from: date!)
        return "\(calendar.weekdaySymbols[datecmpts.weekday! - 1]) \(datecmpts.day!) \(calendar.monthSymbols[datecmpts.month! - 1]) \(datecmpts.year!)".convertToPersian()
        
    }
    
    func showToast(message : String) {
        
        let banner = Banner(title: nil, subtitle: message, backgroundColor: UIColor(red:1.0, green:0.437, blue:0.597, alpha:1.0))
        banner.dismissesOnTap = true
        banner.detailLabel.font = UIFont(name: "IRAN SansMobile(NoEn)", size: 17.0)
        banner.detailLabel.textColor = UIColor.white
        banner.detailLabel.textAlignment = .center
        banner.titleLabel.textAlignment = .center
        banner.show(duration: 4.0)
    }
    func showInfoToast(message : String) {
        
        let banner = Banner(title: nil, subtitle: message, backgroundColor: getPinworkColors(color: 1))
        banner.dismissesOnTap = true
        banner.detailLabel.font = UIFont(name: "IRAN SansMobile(NoEn)", size: 17.0)
        banner.detailLabel.textColor = UIColor.white
        banner.detailLabel.textAlignment = .center
        banner.titleLabel.textAlignment = .center
        banner.show(duration: 4.0)
    }
    func getPickerViewOneComponent(attributes:Array<String> , title:String)->PopUpPickerViewController{
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let pickerController = storyBoard.instantiateViewController(withIdentifier: "pickerpopup") as! PopUpPickerViewController
        pickerController.attribites = attributes
        pickerController.titleString = title
        pickerController.modalTransitionStyle = .crossDissolve
        pickerController.isModalInPopover = true
        pickerController.modalPresentationStyle = .overCurrentContext
        return pickerController
    }
    func getUIBarButtonItemForNextLevel(title:String , image:String)->UIButton{
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: image)?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle(title, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.titleLabel?.font = UIFont(name: "IRAN SansMobile(NoEn)", size: 16.0)
        button.setTitleColor(UIColor.white, for: .normal)
        button.imageView?.tintColor = UIColor.white
        //button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.sizeToFit()
        return button
    }
    func getUIBarButtonItemForRetry(title:String , image:String)->UIButton{
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: image)?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle(title, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.titleLabel?.font = UIFont(name: "IRAN SansMobile(NoEn)", size: 16.0)
        button.setTitleColor(UIColor.white, for: .normal)
        button.imageView?.tintColor = UIColor.white
        button.sizeToFit()
        return button
    }
    
    func getPinworkColors(color numofColor: Int)->UIColor{
        switch numofColor {
        case 0:
            return UIColor(red:0.02, green:0.29, blue:0.36, alpha:1.0)
                  default:
        return UIColor(red:55/255, green:216/255, blue:250/255, alpha:1.0)
            
        }
    
    }
    
    func navigateToMain(isCommingFromRegister:Bool){
        //mainViewController.delegate = self

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyBoard.instantiateViewController(withIdentifier: "navigationController") as! MainNavigationViewController
        //let mainViewController = navigationController.viewControllers.first as? MainViewController
        if isCommingFromRegister{
        MainViewController.isCommingFromRegister = true
        }
        
        self.present(navigationController, animated: true, completion: nil)
        
        
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
            ,4043:"فاصله زمانی مجاز بین دریافت دو کد فعال‌سازی، رعایت نشده، لطفا بعد از یک دقیقه مجددا تلاش نمایید."
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
    
    func isFirstTime()->Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<UserData> = UserData.fetchRequest()
        do {
            let searchResults = try managedContext.fetch(fetchRequest)
            if searchResults.count > 0{
                return false
            }
            
        }
        catch {
            //print("Error with request: \(error)")
        }
        return true
    }
    func isLoggedIn()->Bool{
        return getData(key: "isLoggedIn") as! Bool
    }
    func writeFirstToken(key: String , value : String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity =  NSEntityDescription.entity(forEntityName: "UserData", in: managedContext)
        let transc = NSManagedObject(entity: entity!, insertInto: managedContext)
        transc.setValue(value, forKey: key)
        
        
        do {
            try managedContext.save()
            //print("saved!")
        } catch _ as NSError  {
            //print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
    }
    func getData(key:String)->Any{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<UserData> = UserData.fetchRequest()
        do {
            let searchResults = try managedContext.fetch(fetchRequest)
            for trans in searchResults as [NSManagedObject] {
                if let res = trans.value(forKey: key){
                    return res
                }
            }
        }catch{
            //print("error in getData")
        }
        return "Non"
    }
    func updataData(key:String , value:Any){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                results![0].setValue(value , forKey: key)
            }
        } catch {
            //print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
        }
        catch {
           // print("Saving Core Data Failed: \(error)")
        }
    }
    
    
    
}
