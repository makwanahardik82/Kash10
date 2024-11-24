//
//  AirTicketAncSearchResponseModel.swift
//  Peko
//
//  Created by Hardik Makwana on 20/03/24.
//

import UIKit



struct AirTicketAncSearchResponseModel: Codable {
    
    let conversationId:String?
    //    let meta:String?
    //    let commonData:String?
    let data:[AirTicketAncSearchModel]?
    
    //    version
    
}
struct AirTicketAncSearchModel: Codable {
    
    let flightSegments:[AirTicketAncFlightSegmentsModel]?
    let ancillaryRules:[AirTicketAncRulesModel]?
    let seatMap:[AirTicketAncSeatMapModel]?
    let meals:[AirTicketAncMealModel]?
    let baggages:[AirTicketAncBaggagesModel]?
}

// MARK: -
struct AirTicketAncFlightSegmentsModel: Codable {
    
    let segmentKey:String?
    let departureAirportCode:String?
    let departureDateTime:String?
    
    let arrivalAirportCode:String?
    let arrivalDateTime:String?
    
    let flightNumber:String?
    let operatingAirline:String?
    
}

// MARK: -
struct AirTicketAncRulesModel: Codable {
    
    let ancillaryType:String?
    let ancillaryQuantity:[AirTicketAncRulesQuantityModel]?
    
}
struct AirTicketAncRulesQuantityModel: Codable {
    
    let min:Int?
    let max:Int?
    
    let chargeType:String?
    let applicableType:String?
}

// MARK: -
struct AirTicketAncMealModel: Codable {
    
    let ancillary:AirTicketAncMealAncillaryModel?
    let fare:[AirTicketAncMealFareModel]?
    let segmentPassengerMapping:AirTicketAncMealSegmentPassengerMappingModel?
}
struct AirTicketAncMealAncillaryModel: Codable {
    
    let ancillaryOfferId:String?
    let ancillaryCode:String?
    let quantity:Int?
    
    let ancillaryDescription:String?
    let type:String?
//    let isAncillaryTripWise:CustomString?
    
}
struct AirTicketAncMealFareModel: Codable {
    
    let buyingCurrency:String?
    let buyingAmount:CustomDouble?
    
    let sellingCurrency:String?
    let sellingAmount:CustomDouble?
    
}
//
struct AirTicketAncMealSegmentPassengerMappingModel: Codable {
    
    let segmentKeys:[String]?
    let passengerKeys:[String]?
    
}

// MARK: -

// MARK: - SEAT MAP
struct AirTicketAncSeatMapModel: Codable {
    
    let cabin:[AirTicketAncSeatMapCabinModel]?
    
}

struct AirTicketAncSeatMapCabinModel: Codable {
    
    let deck:[AirTicketAncSeatMapCabinDeckModel]?
    let segmentPassengerMapping:AirTicketAncMealSegmentPassengerMappingModel?
    
}
struct AirTicketAncSeatMapCabinDeckModel: Codable {
    
    let airRow:[AirTicketAncSeatMapCabinDeckAirRowModel]?
    let type:String?
    
}
struct AirTicketAncSeatMapCabinDeckAirRowModel: Codable {
    
    let airSeats:[AirTicketAncSeatMapCabinDeckAirRowAirSeatsModel]?
    let rowNumber:CustomInt?
    
}
struct AirTicketAncSeatMapCabinDeckAirRowAirSeatsModel: Codable {
    
    let seatCode:String?
    let ancillaryOfferId:String?
    let availability:String?
    let seatType:String?
    let seatNumber:String?
    let cabinClass:String?
    let exitRow:Bool?
    let noSeat:Bool?
    let chargeable:Bool?
    let childAllowed:Bool?
    let restrictedGeneral:Bool?
    let infantAllowed:Bool?
    let fare:[AirTicketAncSeatMapCabinDeckAirRowAirFareModel]?
    
}
struct AirTicketAncSeatMapCabinDeckAirRowAirFareModel: Codable {
    
    let buyingCurrency:String?
    let buyingAmount:CustomDouble?
    let sellingCurrency:String?
    let sellingAmount:CustomDouble?
    
}


// MAEK: -
// MARK: -
struct AirTicketAncBaggagesModel: Codable {
    
    let ancillary:AirTicketAncMealAncillaryModel?
    let fare:[AirTicketAncMealFareModel]?
    let segmentPassengerMapping:AirTicketAncMealSegmentPassengerMappingModel?
}
