//
//  APIReachability.swift
//  pinwork
//
//  Created by Pouyan on 6/5/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import Foundation
import Alamofire
class APIReachability{
    static let shared = APIReachability()
    let manager = NetworkReachabilityManager(host: "api.pinwork.co")
   
    
    func startMonitoring(){
        manager!.listener = { status in
            NotificationCenter.default.post(name: Notification.Name("APIreachability"), object: nil, userInfo: ["status":(self.manager!.isReachable)])
            
            print("Network Status Changed: \(status)")
            print("network reachable \(self.manager!.isReachable)")
        }
        manager!.startListening()
    }
    func stopMonitoring(){
        
        self.manager!.stopListening()
        
    }
 
    
    
    
}
