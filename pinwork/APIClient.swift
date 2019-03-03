//
//  APIClient.swift
//  pinwork
//
//  Created by Pouyan on 6/1/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIClient{
    static let baseUrl = "https://api.pinwork.co/api/"
 

    struct APIManager {
        static let sharedManager: SessionManager = {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForResource = 10
            configuration.timeoutIntervalForRequest = 10
            return Alamofire.SessionManager(configuration: configuration)
        }()
    }
   
    static func checkAppVersion(completionHandler: @escaping (NSDictionary? , Error?)->()){
        let requestHeaders = ["User-Agent": "iphone"]
        var requestParameters = ["app_version":"0",
                                 "client_type" : "user"]
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            requestParameters["app_version"]=version
        }
        APIManager.sharedManager.request(baseUrl+"postCheckAppVersion", method: .post, parameters:requestParameters, encoding: JSONEncoding.default, headers: requestHeaders).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                completionHandler(value as? NSDictionary , nil)
            case .failure(let error):
                completionHandler(nil, error)   //only need status
            }
            
        }
        
    }
    
    
    static func rememberTokenRequest(completionHandler: @escaping (NSDictionary?, Error?) -> ()){
        let requestHeaders = ["User-Agent": "ios"]
        let requestParameters = ["app_version":1]
        APIManager.sharedManager.request(baseUrl+"postFreeUserGenerateToken", method:.post, parameters:requestParameters ,encoding: JSONEncoding.default, headers: requestHeaders).responseJSON{ response in
            switch response.result {
            case .success(let value):
                completionHandler(value as? NSDictionary, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
            
        }
        
        
       }
    
    
    
    static func  codeRequestForLoginOrRegister(phoneNumber: String , action: String,rememberToken: String, completionHandler: @escaping (NSDictionary?, Error?) -> ()){
        let requestHeaders = ["User-Agent": "ios"]
        let requestParameters = ["phone":phoneNumber,"action":action,"remember_token":rememberToken]
       
        APIManager.sharedManager.request(baseUrl+"postUserLogin", method:.post, parameters:requestParameters ,encoding: JSONEncoding.default, headers: requestHeaders).responseJSON{ response in
            switch response.result {
            case .success(let value):
                completionHandler(value as? NSDictionary, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
            
        }
        
        
        }
    
    static func  checkCodeForRegister(phoneNumber: String , code: String,rememberToken: String, completionHandler: @escaping (NSDictionary?, Error?) -> ()){
        let requestHeaders = ["User-Agent": "iphone"]
        let requestParameters = ["phone":phoneNumber,"code":code,"remember_token":rememberToken]
  
        APIManager.sharedManager.request(baseUrl+"postRegister", method:.post, parameters:requestParameters ,encoding: JSONEncoding.default, headers: requestHeaders).responseJSON{ response in
            switch response.result {
            case .success(let value):
                completionHandler(value as? NSDictionary, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
            
        }
        
        
      }
    
    
    static func  requestForUserLogin(phoneNumber: String , code: String,rememberToken: String, completionHandler: @escaping (NSDictionary?, Error?) -> ()){
        let requestHeaders = ["User-Agent": "iphone"]
        let requestParameters = ["phone":phoneNumber,"code":code,"remember_token":rememberToken]
        
        APIManager.sharedManager.request(baseUrl+"postUserLoginCodeCheck", method:.post, parameters:requestParameters ,encoding: JSONEncoding.default, headers: requestHeaders).responseJSON{ response in
            switch response.result {
            case .success(let value):
                completionHandler(value as? NSDictionary, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
            
        }
        
        
    }
    
    static func  estimateCarWashPrice(defaultDate: String , carType: String, material: String ,rememberToken: String, completionHandler: @escaping (NSDictionary?, Error?) -> ()){
        let requestHeaders = ["User-Agent": "iphone"]
        let requestParameters = ["remember_token":rememberToken, "default_start_date":defaultDate, "car_type":carType, "material":material] as [String : Any]
        
        APIManager.sharedManager.request(baseUrl+"postEstimatePriceCarwash", method:.post, parameters:requestParameters ,encoding: JSONEncoding.default, headers: requestHeaders).responseJSON{ response in
            switch response.result {
            case .success(let value):
                completionHandler(value as? NSDictionary, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
            
        }
        
        
    }
    
    static func  estimateHomeOrOfficeCleaningPrice(requestArray:[String:Any], completionHandler: @escaping (NSDictionary?, Error?) -> ()){
        let requestHeaders = ["User-Agent": "iphone"]
        let requestParameters = requestArray
        
        APIManager.sharedManager.request(baseUrl+"postEstimatePriceCleaning", method:.post, parameters:requestParameters ,encoding: JSONEncoding.default, headers: requestHeaders).responseJSON{ response in
            switch response.result {
            case .success(let value):
                completionHandler(value as? NSDictionary, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
            
        }
        
        
    }
    
    
    static func  estimateJointsPrice(requestArray:[String:Any], completionHandler: @escaping (NSDictionary?, Error?) -> ()){
        let requestHeaders = ["User-Agent": "iphone"]
        let requestParameters = requestArray
        
        APIManager.sharedManager.request(baseUrl+"postEstimatePriceJoints", method:.post, parameters:requestParameters ,encoding: JSONEncoding.default, headers: requestHeaders).responseJSON{ response in
            switch response.result {
            case .success(let value):
                completionHandler(value as? NSDictionary, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
            
        }
        
        
    }
    
    
    
    static func  reverseAddressService(requestArray:[String:Any], completionHandler: @escaping (NSDictionary?, Error?) -> ()){
        let requestHeaders = ["User-Agent": "iphone"]
        let requestParameters = requestArray
        
        APIManager.sharedManager.request(baseUrl+"postLatLong", method:.post, parameters:requestParameters ,encoding: JSONEncoding.default, headers: requestHeaders).responseJSON{ response in
            switch response.result {
            case .success(let value):
                completionHandler(value as? NSDictionary, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
            
        }
        
        
    }
    
    
    static func  requestForUserProfile(rememberToken: String, completionHandler: @escaping (JSON?, Error?) -> ()){
        let requestHeaders = ["User-Agent": "iphone"]
        let requestParameters = ["remember_token":rememberToken]
        APIManager.sharedManager.request(baseUrl+"postSyncRequest", method:.post, parameters:requestParameters ,encoding: JSONEncoding.default, headers: requestHeaders).responseJSON{ response in
            switch response.result {
            case .success(let value):
                completionHandler(JSON(value), nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
            
        }
        
        
    }
    static func  requestForUserLogOut(rememberToken: String, completionHandler: @escaping (JSON?, Error?) -> ()){
        let requestHeaders = ["User-Agent": "iphone"]
        let requestParameters = ["remember_token":rememberToken]
        APIManager.sharedManager.request(baseUrl+"postLogout", method:.post, parameters:requestParameters ,encoding: JSONEncoding.default, headers: requestHeaders).responseJSON{ response in
            switch response.result {
            case .success(let value):
                completionHandler(JSON(value), nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
            
        }
        
        
    }
    
    static func  requestForDoneServices(rememberToken: String, completionHandler: @escaping (JSON?, Error?) -> ()){
        let requestHeaders = ["User-Agent": "iphone"]
        let requestParameters = ["remember_token":rememberToken]
        APIManager.sharedManager.request(baseUrl+"getServices", method:.post, parameters:requestParameters ,encoding: JSONEncoding.default, headers: requestHeaders).responseJSON{ response in
            switch response.result {
            case .success(let value):
                completionHandler(JSON(value), nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
            
        }
        
        
    }
    
    
    static func  requestForProfileUpdate(rememberToken: String, requestParams:[String:String], completionHandler: @escaping (JSON?, Error?) -> ()){
        let requestHeaders = ["User-Agent": "iphone"]
        var requestParameters = requestParams
        requestParameters["remember_token"] = rememberToken
        APIManager.sharedManager.request(baseUrl+"postUpdateProfile", method:.post, parameters:requestParameters ,encoding: JSONEncoding.default, headers: requestHeaders).responseJSON{ response in
            switch response.result {
            case .success(let value):
                completionHandler(JSON(value), nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
            
        }
        
        
    }
    
    
    static func  requestForCompeleteRegister(rememberToken: String, requestParams:[String:String], completionHandler: @escaping (JSON?, Error?) -> ()){
        let requestHeaders = ["User-Agent": "iphone"]
        var requestParameters = requestParams
        requestParameters["remember_token"] = rememberToken
        APIManager.sharedManager.request(baseUrl+"postCompleteRegister", method:.post, parameters:requestParameters ,encoding: JSONEncoding.default, headers: requestHeaders).responseJSON{ response in
            switch response.result {
            case .success(let value):
                completionHandler(JSON(value), nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
            
        }
        
        
    }
    
    static func  postNotificationTokenForTemp(rememberToken: String, requestParams:[String:String], completionHandler: @escaping (JSON?, Error?) -> ()){
        let requestHeaders = ["User-Agent": "iphone"]
        var requestParameters = requestParams
        requestParameters["remember_token"] = rememberToken
        APIManager.sharedManager.request(baseUrl+"postFreeUserRememberTokenNotification", method:.post, parameters:requestParameters ,encoding: JSONEncoding.default, headers: requestHeaders).responseJSON{ response in
            switch response.result {
            case .success(let value):
                completionHandler(JSON(value), nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
            
        }
        
        
    }
    
    static func  postNotificationToken(rememberToken: String, requestParams:[String:String], completionHandler: @escaping (JSON?, Error?) -> ()){
        let requestHeaders = ["User-Agent": "iphone"]
        var requestParameters = requestParams
        requestParameters["remember_token"] = rememberToken
        APIManager.sharedManager.request(baseUrl+"postUserRememberTokenNotification", method:.post, parameters:requestParameters ,encoding: JSONEncoding.default, headers: requestHeaders).responseJSON{ response in
            switch response.result {
            case .success(let value):
                completionHandler(JSON(value), nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
            
        }
        
        
    }
    

    static func  requestForNotifications(rememberToken: String, completionHandler: @escaping (JSON?, Error?) -> ()){
        let requestHeaders = ["User-Agent": "iphone"]
        let requestParameters = ["remember_token":rememberToken]
        APIManager.sharedManager.request(baseUrl+"getNotifications", method:.post, parameters:requestParameters ,encoding: JSONEncoding.default, headers: requestHeaders).responseJSON{ response in
            switch response.result {
            case .success(let value):
                completionHandler(JSON(value), nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
            
        }
        
        
    }
    
    static func  serviceDatailes(rememberToken: String, requestParams:[String:String], completionHandler: @escaping (JSON?, Error?) -> ()){
        let requestHeaders = ["User-Agent": "iphone"]
        var requestParameters = requestParams
        requestParameters["remember_token"] = rememberToken
        debugPrint(requestParams)
        APIManager.sharedManager.request(baseUrl+"getDetailService", method:.post, parameters:requestParameters ,encoding: JSONEncoding.default, headers: requestHeaders).responseJSON{ response in
            switch response.result {
            case .success(let value):
                completionHandler(JSON(value), nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
            
        }
        
        
    }

    static func  cancelService(rememberToken: String, requestParams:[String:String], completionHandler: @escaping (JSON?, Error?) -> ()){
        let requestHeaders = ["User-Agent": "iphone"]
        var requestParameters = requestParams
        requestParameters["remember_token"] = rememberToken
        debugPrint(requestParams)
        APIManager.sharedManager.request(baseUrl+"postCancelServiceRequest", method:.post, parameters:requestParameters ,encoding: JSONEncoding.default, headers: requestHeaders).responseJSON{ response in
            switch response.result {
            case .success(let value):
                completionHandler(JSON(value), nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
            
        }
        
        
    }


}
