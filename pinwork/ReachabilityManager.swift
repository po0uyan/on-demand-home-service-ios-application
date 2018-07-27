//
//  Connectivity.swift
//  pinwork
//
//  Created by Pouyan on 6/4/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import Foundation
import Reachability
class ReachabilityManager : NSObject {
    
    static let shared = ReachabilityManager()
    
    var reachabilityStatus: Reachability.Connection = .none
    var isNetworkAvailable: Bool{
        return reachabilityStatus != .none
    }
    let reachability = Reachability()!
 
    func startMonitoring(){
        do{
            try reachability.startNotifier()
        }catch{
            //debugPrint("Could not start reachability notifier")
        }
        
    }
    
    func stopMonitoring(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged,
                                                  object: reachability)
    }
   
}
