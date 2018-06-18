//
//  APIClient.swift
//  pinwork
//
//  Created by Pouyan on 6/1/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import Foundation
import Alamofire
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
    
    
}
