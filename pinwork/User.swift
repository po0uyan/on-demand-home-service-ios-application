//
//  User.swift
//  pinwork
//
//  Created by Pouyan on 7/13/18.
//  Copyright © 2018 Pouyan. All rights reserved.
//

import Foundation

class User{
    enum genderType : String{
        case  male = "male",
     female = "female"
    }
    var name : String!
    var lastName:String
    var picture:String
    var birthDay:String
    var email:String
    var phone_place:String
    var cellPhone:String
    var orders_count:Int
    var orders_duration:Int
    var gender:genderType
    var money:Int
    var invite_hash:String
    var notification_unseen_count:Int
    var messages_unseen_count:Int
    init(name:String,lastName:String,picture:String,birthDay:String,email:String,phone_place:String,cellPhone:String,orders_count:Int,orders_duration:Int,gender:genderType,money:Int,invite_hash:String,notification_unseen_count:Int,messages_unseen_count:Int) {
        self.name = name
        self.lastName = lastName
        self.picture = picture
        self.birthDay = birthDay
        self.email = email
        self.phone_place = phone_place
        self.cellPhone = cellPhone
        self.orders_count = orders_count
        self.orders_duration = orders_duration
        self.gender = gender
        self.money = money
        self.invite_hash = invite_hash
        self.notification_unseen_count = notification_unseen_count
        self.messages_unseen_count = messages_unseen_count
        
        
        
        
        
    }
    
    
    
}
