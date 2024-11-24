//
//  AirTicketHistoryListModel.swift
//  Peko
//
//  Created by Hardik Makwana on 20/03/24.
//

import UIKit
import CodableFirebase

struct AirTicketHistoryListModel: Codable {
    
    let page:Int?
    let limit:Int?
    let count:Int?
   
    let bookings:[AirTicketHistoryModel]?
    
}
struct AirTicketHistoryModel: Codable {
    
    let id:Int?
    
    let corporateTxnId:String?
    let operatorId:String?
    let providerId:String?
    
    let transactionDate:String?
    let accountNo:String?
    
    let amountInAed:String?
   
    let baseAmount:String?
    let paymentMode:String?
    let paymentModeResponse:String?
    let surcharge:String?
    let baseCurrency:String?
    let exchangeRate:String?
    
    let status:String?
    let message:String?
    let ecomOrderStatus:String?
    let workspaceOrderStatus:String?
  //  let shipmentStatus:PekoStoreShipmentStatusModel?
    let createdAt:String?
    let updatedAt:String?
   
    let serviceOperatorId:Int?
    let credentialId:Int?
    
    let orderResponse:String?
 
    
    var orderResponseDictionary:[String:Any] {
        get {
            if let array = self.orderResponse?.toJSON() as? [String:Any] {
                return array
            }
            return [String:Any]()
        }
    }
    
    var orderResponseModel:AirTicketHistoryResponseModel? {
        if let array = orderResponseDictionary["data"] as? [[String:Any]], let data = array.first {
            
            do {
                let model = try FirebaseDecoder().decode(AirTicketHistoryResponseModel.self, from: data)
                return model
            } catch let error {
                print(error)
            }
        }
        return nil
    }
}

struct AirTicketHistoryResponseModel: Codable {
    
    let bookingStatus:String?
    let priceChanged:Bool?
    
    let bookingReferenceId:String?
    let supplierLocator:String?
   
    let journey:[AirportJourneyModel]?
    
    let fare:AirportFareModel?
    
 //   let passengers:[AirTicketHistoryPassengersModel]?
    let ticketDocument:[AirTicketHistoryTicketDocumentModel]?
  
}
// MARK: -
struct AirTicketHistoryPassengersModel: Codable {
    
}
// MARK: -
struct AirTicketHistoryTicketDocumentModel: Codable {
    
    let ticketDocNbr:String?
    let passengerKey:String?
    
    let fareBreakdownKey:String?
    let airline:String?
    
    let status:String?
    let dateOfIssue:String?
}
