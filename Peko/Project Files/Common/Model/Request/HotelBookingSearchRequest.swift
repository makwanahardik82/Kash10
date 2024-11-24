//
//  HotelBookingSearchRequest.swift
//  Peko
//
//  Created by Hardik Makwana on 10/01/24.
//

import UIKit

struct HotelBookingSearchRequest {
    
   
    var city:String?
    var checkInDate:Date?
    var checkOutDate:Date?
    var noOfRooms:String?
    var noOfTravellers:String?
    var travellersArray:[Dictionary<String, Any>]?
    
}
