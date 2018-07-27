//
//  Order.swift
//  pinwork
//
//  Created by Pouyan on 7/12/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreData
class Order{
    enum action{
        case officeCleaning
        case homeCleaning
        case garageCleaning
        case carWash
        case otherServices
        
    }
    var orderTillNow :Dictionary<String,Any> = [:]
    var orderType = action.officeCleaning
    func getCleaningType()->String{
        switch orderType {
        case .homeCleaning:
            return "house"
        case .officeCleaning:
            return "work"
        case .carWash:
            return "carWash"
            
        default:
            break
        }
        return "none"
    }
    func registerOrder(completionHandler: @escaping (JSON?, Error?) -> ()){
        var url = ""
        
        self.orderTillNow["device_type"] = "ios"
        switch orderType {
            
        case .homeCleaning:
            url = "postServiceCleaningRequest"
            self.orderTillNow["cleaning_type"] = "house"
        case .officeCleaning:
            url = "postServiceCleaningRequest"
            self.orderTillNow["cleaning_type"] = "work"

        case .carWash:
            url = "postServiceCarwashRequest"
        case .garageCleaning:
            url = "postServiceJointsRequest"
        case .otherServices :
            url = "postExtraService"
      
        }
        
            let requestHeaders = ["User-Agent": "iphone"]
            orderTillNow["remember_token"] = getData(key: "rememberToken") as! String
        APIClient.APIManager.sharedManager.request(APIClient.baseUrl+url, method:.post, parameters:self.orderTillNow ,encoding: JSONEncoding.default, headers: requestHeaders).responseJSON{ response in
                switch response.result {
                case .success(let value):
                    completionHandler(JSON(value), nil)
                case .failure(let error):
                    completionHandler(nil, error)
                }
                
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
}
