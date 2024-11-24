//
//  AirTicketSearchRequestModel.swift
//  Peko
//
//  Created by Hardik Makwana on 14/06/23.
//

import UIKit

struct AirTicketSearchRequestModel {
    var passengersCount, travel_class: String?
    var origin, destination, multi_origin, multi_destination:AirportModel?
    var departure_date, return_date:Date?
    
    var travellerDictionary:[String:Int]?
}
