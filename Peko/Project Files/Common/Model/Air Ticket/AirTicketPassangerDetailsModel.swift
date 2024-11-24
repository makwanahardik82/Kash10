//
//  AirTicketPassangerDetailsModel.swift
//  Peko
//
//  Created by Hardik Makwana on 16/06/23.
//

import UIKit


struct AirTicketPassangerDetailsModel: Codable {
 
    var honor:String = "Mr"
    var first_name:String = ""
    var last_name:String = ""
   
    var dateOfBirth:Date?
  
    var passportNumber:String = ""
    var passportIssueDate:Date? // = ""
    var passportExpiryDate:Date? // = ""
    var passportIssueCountry:String = ""
    
    var nationality = ""
    
    var isChild:Bool = false
    
    var passangerKey = "".randomString(length: 9)
    
//
//    var age:Int{
//        let birthdate = self.birthdateString.toDate(format: "yyyy-MM-dd")
//        return Calendar.current.numberOfYearsBetween(birthdate, and: Date())
//    }
}
