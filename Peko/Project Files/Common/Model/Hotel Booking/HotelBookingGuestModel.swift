//
//  HotelBookingGuestModel.swift
//  Peko
//
//  Created by Hardik Makwana on 14/03/24.
//

import UIKit

class HotelBookingGuestModel: NSObject {

    var honor:String = "Mr"
    var first_name:String = ""
    var last_name:String = ""
   
    var email:String = ""
    var phone_number:String = ""
    
    var country:String = ""
    
    var isChild:Bool?
}

/*
 
 struct AirTicketPassangerDetailsModel: Codable {
  
     
     var day:String = ""
     var month:String = ""
     var year:String = ""
  
     var email:String = ""
     var phone_number:String = ""
     var voucher_id:String = ""
     
     var pan_card:String = "12345678"
     var passenger_key = ""
     
     var birthdateString:String {
         return "\(self.year)-\(self.month)-\(self.day)"
     }
     var age:Int{
         let birthdate = self.birthdateString.toDate(format: "yyyy-MM-dd")
         return Calendar.current.numberOfYearsBetween(birthdate, and: Date())
     }
 }

 */
