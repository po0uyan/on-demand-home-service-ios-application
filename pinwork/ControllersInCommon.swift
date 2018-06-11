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
extension UIViewController {
    
    func showToast(message : String) {
        
        let banner = Banner(title: nil, subtitle: message, backgroundColor: UIColor(red:0.02, green:0.29, blue:0.36, alpha:1.0))
        banner.dismissesOnTap = true
        banner.detailLabel.font = UIFont(name: "IRAN SansMobile(NoEn)", size: 18.0)
        banner.detailLabel.textColor = UIColor.white
        banner.detailLabel.textAlignment = .center
        banner.titleLabel.textAlignment = .center
        banner.show(duration: 5.0)
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
        let mainViewController = navigationController.viewControllers.first as? MainViewController
        if isCommingFromRegister{
        mainViewController?.isCommingFromRegister = true
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
            print("Error with request: \(error)")
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
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
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
            print("error in getData")
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
            print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
        }
        catch {
            print("Saving Core Data Failed: \(error)")
        }
    }
    
    
    
}
