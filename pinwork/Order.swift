//
//  Order.swift
//  pinwork
//
//  Created by Pouyan on 7/12/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import Foundation
struct Order{
    enum action{
        case officeCleaning
        case homeCleaning
        case garageCleaning
    }
    var orderTillNow :Dictionary<String,Any> = [:]
    var orderType = action.officeCleaning
    func getCleaningType()->String{
        switch orderType {
        case .homeCleaning:
            return "house"
        case .officeCleaning:
            return "work"
        default:
            break
        }
        return "none"
    }
    
}
