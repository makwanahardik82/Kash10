//
//  AirTicketManager.swift
//  Peko
//
//  Created by Hardik Makwana on 15/06/23.
//

import UIKit

enum AirTicketWayType: Int {
    case OneWay = 0
    case RoundTrip
    case MultiCity
}


var objAirTicketManager:AirTicketManager?

class AirTicketManager: NSObject {

    static let sharedInstance = AirTicketManager()
   
    var request = AirTicketSearchRequestModel()
    var airTicketWayType:AirTicketWayType = .OneWay
    var passangerArray = [AirTicketPassangerDetailsModel]()

    var selectedAirlinesDataModel:AirportSearchDataModel?
    var selectedAirlinesName:String?
    var selectedReturnAirlinesName:String?
    
    var conversationId:String?
    var fullName:String?
    var phoneNumber:String?
    var email:String?
   
    
    var provisionConversationId:String?
   // var provisionAirlinesDataModel:AirportSearchDataModel?
    
    var addOnsAmount = 0.0
    var ancillaryArray = [Dictionary<String, String>]()
    
    
    var bookResponseModel:AirTicketBookResponseModel?
    
    
    var airlinesArray:[AirlinesModel] {
        if let url = Bundle.main.url(forResource: "Airlines_list", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let array = try decoder.decode([AirlinesModel].self, from: data)
               return array
            } catch {
                print("error:\(error)")
            }
        }
        return [AirlinesModel]()
    }
    
   
    
    //var airportSearchDataModel:AirportSearchDataModel?
    
//    var dapiPaymentResponse:[String:Any]?
//    var dapiAmount:String = "0"
}
