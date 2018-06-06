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
    
    func navigateToMain(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainNavigationController = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        mainNavigationController.modalTransitionStyle = .coverVertical
        self.present(mainNavigationController, animated: true, completion: nil)
        
        
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
