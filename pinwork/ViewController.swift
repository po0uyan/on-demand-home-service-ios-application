//
//  ViewController.swift
//  pinwork
//
//  Created by Pouyan on 5/27/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import UIKit
import Alamofire
import Lottie
import CoreData
import Reachability
class ViewController: UIViewController {
    
    let animationView = LOTAnimationView(name: "load2")
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        //APIReachability.shared.startMonitoring()
           NotificationCenter.default.addObserver(self, selector: #selector(self.popUpOnNetFail), name: Notification.Name.reachabilityChanged, object: nil)
      
        animationView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
        animationView.contentMode = .scaleAspectFit
        self.view.addSubview(animationView)
        animationView.loopAnimation = true
        animationView.play()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: nil)
        
    }
    
 @objc  func popUpOnNetFail(_ notification : Notification){
    let reachability = notification.object as! Reachability
    switch reachability.connection{
    case .none:
        showNetworkError()
        debugPrint("Network became unreachable")
    case .wifi:
        debugPrint("Network became reachable wifi")
        
    case .cellular:
        debugPrint("Network became reachable cellular")
        
    }
    
    }
    func showNetworkRetry(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let retryPopUpController = storyBoard.instantiateViewController(withIdentifier: "RetryViewController") as! RetryViewController
        retryPopUpController.modalTransitionStyle = .crossDissolve
        retryPopUpController.isModalInPopover = true
        retryPopUpController.modalPresentationStyle = .overCurrentContext
        retryPopUpController.onDoneBlock = { result in
            // Do something
        self.dologic()
        }
        self.present(retryPopUpController, animated: true)
    }
    func showNetworkError(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let noInternetPopUpController = storyBoard.instantiateViewController(withIdentifier: "NoInternetPopUpViewController") as! NoInternetPopUpViewController
        noInternetPopUpController.modalTransitionStyle = .crossDissolve
        noInternetPopUpController.isModalInPopover = true
        noInternetPopUpController.modalPresentationStyle = .overCurrentContext
        noInternetPopUpController.onDoneBlock = { result in
            // Do something
            self.dologic()
        }
        self.present(noInternetPopUpController, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dologic()
       
        
        
    }
    
    func checkAppVersionStatus(){
        APIClient.checkAppVersion { (respond, error) in
            if respond != nil{
                switch (respond!["data"] as! NSDictionary)["status"] as! String {
                case "normal":
                    self.showNormalUpdateDialog()
                case "critical":
                    self.showCriticalUpdateDialog()
                default :
                    self.navigateToLoginPage()
                    
                }

            }else{
                print(String(describing:error))
                self.showNetworkRetry()
            }
            
            self.animationView.stop()
            
        }
    }

    func dologic(){
        if !self.animationView.isAnimationPlaying{
            self.animationView.play()
        }
        if isFirstTime(){
            APIClient.rememberTokenRequest { (respond, error) in
                if respond != nil{
                    let tempRememberToken = (respond!["data"] as! NSDictionary)["remember_token"] as! String
                    self.writeFirstToken(key: "tempRememberToken", value: tempRememberToken)
                    self.checkAppVersionStatus()
                }
                
                
            }
        }else{
            self.checkAppVersionStatus()
        }
    }
    func showNormalUpdateDialog(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let updateController = storyBoard.instantiateViewController(withIdentifier: "updatepopup") as! UpdatePopUpViewController
        updateController.isCritical = false
        updateController.isLoggedIn = isLoggedIn()
        updateController.modalTransitionStyle = .crossDissolve
        updateController.isModalInPopover = true
        updateController.modalPresentationStyle = .overCurrentContext
        self.present(updateController, animated: true)
        updateController.onDoneBlock = { result in
            // Do something
            self.navigateToLoginPage()
        }
        
    }
    
    func showCriticalUpdateDialog(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let updateController = storyBoard.instantiateViewController(withIdentifier: "updatepopup") as! UpdatePopUpViewController
        updateController.isCritical = true
        updateController.isLoggedIn = isLoggedIn()
        updateController.modalTransitionStyle = .crossDissolve
        updateController.isModalInPopover = true
        updateController.modalPresentationStyle = .overCurrentContext
        self.present(updateController, animated: true)
        updateController.onDoneBlock = { result in
            // Do something
            self.navigateToLoginPage()
        }
    }
    
    func navigateToLoginPage(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let loginPageView = storyBoard.instantiateViewController(withIdentifier: "LoginPageViewController") as! LoginPageViewController
        
        loginPageView.modalTransitionStyle = .flipHorizontal
        self.present(loginPageView, animated: true, completion: nil)
    }
    
    func isFirstTime()->Bool{
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

