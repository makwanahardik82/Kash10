//
//  HotelBookingResponseModel.swift
//  Peko
//
//  Created by Hardik Makwana on 05/01/24.
//

import UIKit

//class HotelBookingResponseModel: NSObject {
//
//}
// MARK: - Hotel Booking Search
struct HotelBookingSearchResponseModel:Codable {
    
    let conversationId:String?
    
    let meta:HotelBookingSearchMetaModel?
    
    let commonData:HotelBookingSearchCommonDataModel?
    
    let data:[HotelBookingSearchResponseDataModel]?
    let version:String?

}
struct HotelBookingSearchMetaModel:Codable {
    
    let success:Bool?
    let statusCode:Int?
    let statusMessage:String?
    let actionType:String?
    let conversationId:String?
    
}
struct HotelBookingSearchCommonDataModel:Codable {
    
    let searchKey:String?
    let culture:String?
    //let /*productCode*/:String?
    
}


struct HotelBookingSearchResponseDataModel:Codable {
    
    let hotelKey:String?
    let propertyInfo:HotelBookingSearchPropertyInfoModel?
    
    let rooms:[HotelBookingSearchRoomModel]?
    
    // MARK: -
    let name:String?
    let description:String?
   
    let starRating:String?
   
    let address:String?
    let postalCode:String?
    let city:String?
    let country:String?
    let email:String?
   
    let location:String?
    let latitude:String?
    let longitude:String?
    let locationDesc:String?
    
    
    let website:String?
    
    let map:String?
    let checkInTime:String?
    let checkOutTime:String?
    
    let childPolicy:String?
    let userRating:String?
    let phoneNumber:String?
    let currency:String?
   
    let images:[HotelBookingHotelImageModel]?
    
    let roomKey:String?
   
    let isCombinePolicy:Bool?
    let cancellationDeadlineDate:String?
    let roomCombId:String?
  
    let checkInDate:String?
    let checkOutDate:String?
    let totalNet:CustomDouble?
    let bookingKey:String?
    
    
}

struct HotelBookingSearchPropertyInfoModel:Codable {
    let hotelName:String?
    let address:String?
    let phoneNumber:String?
    
    let location:String?
    let latitude:String?
    let longitude:String?
    
    let imageUrl:String?
  //  let facilities:String?
    let propertyType:String?
    let starRating:String?
}

struct HotelBookingSearchRoomModel:Codable {
    let roomIndex:Int?
    let roomKey:String?
    let roomId:String?
    
    let ruleInfo:CustomString?
    let roomTypeDesc:String?
    let maxOccupancy:Int?
    let rateNotes:String?
    
    let ratePlan:HotelBookingSearchRoomRatePlanModel?
    let roomRate:HotelBookingSearchRoomRatesModel?
    
    let financialInfo:HotelBookingSearchFinancialInfoModel?
    
}


struct HotelBookingSearchRoomRatePlanModel:Codable {
    let supplierCode:String?
    let meal:String?
    let availableStatus:String?
    let cancelPolicyIndicator:String?
    let code:String?
    
    
    let isPackage:Bool?
    let fixedCombo:Bool?
    let gstAssured:Bool?
    let combinePolicy:Bool?
    let lastCancellationDate:String?
  
}

struct HotelBookingSearchRoomRatesModel:Codable {
    let currency:String?
    let netAmount:Double?
    
    let rates:[HotelBookingRatesModel]?
    
}

struct HotelBookingRatesModel:Codable {
    let name:String?
    let amount:Double?
    
    let from:String?
    let rateIndex:String?
    let to:String?
}

struct HotelBookingSearchFinancialInfoModel:Codable {
    let supplier:String?
    let payment:HotelBookingSearchFinancialInfoPaymentModel?
}
struct HotelBookingSearchFinancialInfoPaymentModel:Codable {
    let paymentTypes:[String]?
}


// MARK: - Hotel Booking - Hotel Details
struct HotelBookingHotelDetailsResponseModel:Codable {
    
    let conversationId:String?
    let hotelDetails:HotelBookingHotelDetailsResultsModel?
    let moreRooms:HotelBookingHotelDetailsResultsModel?
}
struct HotelBookingHotelDetailsResultsModel:Codable {
    
    let meta:HotelBookingSearchMetaModel?
    let commonData:HotelBookingSearchCommonDataModel?
    let data:[HotelBookingSearchResponseDataModel]?
    let version:String?
    
}

struct HotelBookingHotelImageModel:Codable {
    
    let order:Int?
    let type:String?
    let description:String?
    let path:String?
    
}


// MARK: -
struct CancellationPolicyResponseModel:Codable {
    
    let success: Bool?
    let message:String?
    let error:String?
    var details: HotelBookingSearchResponseModel
//    enum CodingKeys: String, CodingKey {
//        case status = "success"
//        case message
//        case data
//        case error
//    }
//    init() {
////        self.status = false
////        self.message = "error_generic" //.localized
////        self.data = nil
////        self.error = ""
////    }
}





struct HotelBookingPreBookResponseModel:Codable {
    
    let conversationId:String?
    
    let meta:HotelBookingSearchMetaModel?
    
    let data:[HotelBookingPreBookDataResponseModel]?
      
}
struct HotelBookingPreBookDataResponseModel:Codable {
    let hotel:HotelBookingSearchResponseDataModel?
}
