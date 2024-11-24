//
//  HotelBookingHistoryModel.swift
//  Peko
//
//  Created by Hardik Makwana on 17/01/24.
//

import UIKit

struct HotelBookingHistoryReponseDataModel:Codable {
  
    let bookings:[HotelBookingHistoryModel]?
   
    let page:Int?
    let limit:Int?
    let count:Int?
   
}
    
struct HotelBookingHistoryModel:Codable {
    
    let id:Int?
    let serviceOperatorId:Int?
    let credentialId:Int?
   
    
    let corporateTxnId:String?
    let operatorId:String?
    let transactionDate:String?
   
    
    let amountInAed:String?
    let baseAmount:String?
    let paymentMode:String?
    let surcharge:String?
  
    let baseCurrency:String?
    let exchangeRate:String?
    let status:String?
    let message:String?
    let ecomOrderStatus:String?
    let workspaceOrderStatus:String?
    let createdAt:String?
    let updatedAt:String?

    let providerId:String?
    let accountNo:CustomString?

    let orderResponse:String?
    let paymentModeResponse:String?

    //let shipmentStatus:String?
  
    // let conversationId:String?

    var orderResponseModel: HotelBookingOrderResponseModel? {
        if self.orderResponse != nil && self.orderResponse?.count != 0{
            let jsonData = Data(self.orderResponse!.utf8)
            let decoder = JSONDecoder()
            
            do {
                let people = try decoder.decode(HotelBookingOrderResponseModel.self, from: jsonData)
                print(people)
                return people
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
// HotelBookingHistoryModel
struct HotelBookingOrderResponseModel:Codable {
    
    //let conversationId:String?
    
    let meta:HotelBookingSearchMetaModel?
    let commonData:HotelBookingSearchCommonDataModel?
    let data:[HotelBookingOrderResponseDataModel]?
    let hotelContact:HotelBookingHotelConatcResponseModel?
    let version:String?

    let orderId:Int?
    let corporateTxnId:CustomInt?
   
}
struct HotelBookingHotelConatcResponseModel:Codable {
    
    let email:String?
    let phoneNumber:String?
    let checkInTime:String?
    let checkOutTime:String?
    let image:String?
    let address:String?
    let city:String?
    let country:String?

}
struct HotelBookingOrderResponseDataModel:Codable {
    
    let bookingReferenceId:String?
    let supplierReferenceId:String?
    let clientReference:String?
    let bookingStatus:String?
    let transactionDate:String?
    let hotel:HotelBookingSearchResponseDataModel?
    let passengers:[HotelBookingPassengersModel]?
    
}
struct HotelBookingPassengersModel:Codable {
    
    let passengerKey:CustomString?
    let isLead:Bool?
    let ptc:String?
    let roomIndex:CustomString?
    let roomKey:String?
}
    

struct HotelBookingDownloadResponseDataModel:Codable {
    
    let pdfFile:HotelBookingPdfFileModel?
    
}
struct HotelBookingPdfFileModel:Codable {
    let type:String
    let data:[UInt8]
}
