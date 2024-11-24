//
//  AirportSearchModel.swift
//  Peko
//
//  Created by Hardik Makwana on 14/06/23.
//

import UIKit

struct AirTicketSearchModel: Codable {
 
    let conversationId:String?
//    let meta:String?
//    let commonData:String?
    let data:[AirportSearchDataModel]?
    
//    version
    
}

struct AirportSearchDataModel: Codable {
 
    let offerId:String?
    let journey:[AirportJourneyModel]?
    let fare:AirportFareModel?
    let detail:AirportSearchDatadetailModel?
   
    let oldFare:CustomDouble?
    let newFare:CustomDouble?

    // let bookingReferenceId:String?
    
   
}
struct AirportSearchDatadetailModel: Codable {
    
    let ancillaryDetailsAvailable:Bool?
    let lcc:Bool?
    let apis:Bool?
    let ndc:Bool?
    let onHoldSupported:Bool?
    let moreFaresAvailable:Bool?
    let reissueSupported:Bool?
    let fareRuleMandatory:Bool?
    
}
struct AirportJourneyModel: Codable {
 
    let flight:AirportFlightModel?
    let flightSegments:[AirportFlightSegmentsModel]?
    
    var duration:String {
        let string = (self.flight?.flightInfo?.duration ?? "").replacingOccurrences(of: "H", with: "H ")
        return string
    }
    var numberOfStop:String {
        let count = (self.flight?.stopQuantity ?? 0)//  - 1
        
        if count == 0 {
            return "Non stop"
        }else{
            return "\(count) stop"
        }
    }
}

struct FlightInfoModel: Codable {
    let duration:String?
}
struct SegmentReferenceModel: Codable {
    let onPoint:String?
    let offPoint:String?
}
struct AirportFlightModel: Codable {
 
    let flightKey:String?
    let stopQuantity:Int?
    let flightInfo:FlightInfoModel?
    let segmentReference:SegmentReferenceModel?
    
   //  let flightSegments:[AirportFlightSegmentsModel]?
    /*
     
     "flightKey": "50318357-be53-4c65-a589-e62e6b1c18ec",
                                 "flightInfo": {
                                     "duration": "3H40M"
                                 },
                                 "segmentReference": {
                                     "onPoint": "DXB",
                                     "offPoint": "DEL"
                                 },
                                 "stopQuantity": 0
     
     */
}

struct AirportFlightSegmentsModel: Codable {
 
    let segmentKey:String?
    let departureAirportCode:String?
    let departureDateTime:String?
    let departureTerminal:String?
    let arrivalAirportCode:String?
    let arrivalDateTime:String?
    let arrivalTerminal:String?
    let duration:String?
    let flightNumber:String?
    let resBookDesigCode:String?
    let numberInParty:Int?
    let operatingAirline:String?
    let marketingAirline:String?
    let seatsAvailable:String?
    let fareBasis:String?
    let equipmentType:String?
    let cabinClass:String?
    let baggageAllowance:AirportBaggageAllowanceModel?
    
    var departureDate:Date {
        get {
            return self.departureDateTime!.toDate()
        }
    }
    var arrivalDate:Date {
        get {
            return self.arrivalDateTime!.toDate()
        }
    }
    
//    var durationInMinutes:Int {
//        let array = self.duration?.uppercased().components(separatedBy: "H")
//        if array?.count == 1, let hrs = array?.first, let mins = array?.last {
//            let totalHrs = (Int(hrs) ?? 0) * 60
//            let totalMin = mins.replacingOccurrences(of: "M", with: "")
//
//            return totalHrs + (Int(totalMin) ?? 0)
//        }
//        return 0
//    }
    /*
    let :String?
    let :String?
    let :String?
   
    
    
    {
        "": "8e0370dc-da72-443c-bea2-563371e76ff5",
        "": "DXB",
        "": "2023-06-20T03:55:00",
        "": "3",
        "": "DEL",
        "": "2023-06-20T09:05:00",
        "": "3",
        "": "3H40M",
        "": "0510",
        "": "T",
        "": 1,
        "": "EK",
        "": "EK",
        "": "9",
        "": "TLEOPAE1",
        "": "77W",
        "baggageAllowance": {
            "carryOnBaggage": [
                {
                    "paxType": "ADT",
                    "value": "1",
                    "unit": "PIECE",
                    "description": "EACH PIECE UP TO 15 POUNDS/7 KILOGRAMS AND UP TO 45 LINEAR INCHES/115 LINEAR CENTIMETERS"
                }
            ],
            "checkedInBaggage": [
                {
                    "paxType": "ADT",
                    "value": "25",
                    "unit": "kg"
                }
            ]
        },
        "": "Economy"
    }
     */
}
struct AirportBaggageAllowanceModel: Codable {
    let carryOnBaggage:[AirportBaggageModel]?
    let checkedInBaggage:[AirportBaggageModel]?
}
struct AirportBaggageModel: Codable {
 
    let paxType:String?
    let value:String?
    let unit:String?
    let description:String?
}

struct AirportFareModel: Codable {
    let currencyCode:String?
    let fareKey:String?
    let platingAirlineCode:String?
    let baseFare:CustomDouble?
    let totalTax:CustomDouble?
    let totalFare:CustomDouble?
    let fareType:FareTypeModel?
    let customerAdditionalFareInfo:CustomerAdditionalFareInfoModel?
    let fareBreakdown:[FareBreakdownModel]?
    
}

struct FareBreakdownModel: Codable {
 
    let fareBreakdownKey:String?
    let paxType:String?
    let passengerKeys:[String]?
    let fareReference:[FareReferenceModel]?
    let paxRate:PaxRateModel?
    let taxes:[FareBreakdownTaxesModel]?
    
    // HARDIK
//    let preferenceContext:String?
//    let oid:String?
//    let refundable:Bool?

}
struct FareBreakdownTaxesModel: Codable {
    
    let amount:CustomInt?
    let taxCode:String?
    
}
struct PaxRateModel: Codable {
    
    let baseFare:CustomDouble?
    let totalTax:CustomDouble?
    let totalFare:CustomDouble?
    let customerAdditionalFareInfo:CustomerAdditionalFareInfoModel?
}

struct FareReferenceModel: Codable {
    
    let fareBasis:String?
    let segmentKey:String?
}
struct FareTypeModel: Codable {
 
    let fareCode:String?
    let farePreference:String?
    let preferenceContext:String?
    let oid:String?
    let refundable:Bool?

}

struct CustomerAdditionalFareInfoModel: Codable {
 
    let transactionFeeEarned:CustomDouble?
    let commissionEarned:CustomDouble?
    let markupEarned:CustomDouble?
    let discount:CustomDouble?
    let plbearned:CustomDouble?
    let incentiveEarned:CustomDouble?
    let tdsOnIncentive:CustomDouble?
}

// MARK: - Fare Fules

struct AirTicketFareRulesResponseModel: Codable {
 
    let conversationId:String?
    let data:[AirportFareRulesDataModel]?

}
struct AirportFareRulesDataModel: Codable {
    let bookingRules:AirporBookingRulesModel?
    let fareRules:[AirporFareRulesModel]?
   // let miniFareRules:CustomDouble?
}

struct AirporBookingRulesModel: Codable {
    let isGSTMandatory:Bool?
    let isLeadEmailAddressMandatory:Bool?
    let isLeadPhoneNumberMandatory:Bool?
    let onHoldSupported:Bool?
}
struct AirporFareRulesModel: Codable {
    let fareBasis:String?
    let subSection:[AirporFareRulesSubSectionModel]?
}
struct AirporFareRulesSubSectionModel: Codable {
    let subSectionNumber:String?
    let subCode:String?
    let subTitle:String?
    let paragraph:String?
}


//    :    a632b1a5-b94c-470a-bf94-8ad521812abb
//            {5}
//            {2}
//            [27]
//   :    1.0.0


/*
 
 {
                 "offerId": "AIR03034321-1",
                 "detail": {
                     "ancillaryDetailsAvailable": true,
                     "lcc": false,
                     "apis": true,
                     "ndc": false,
                     "onHoldSupported": true,
                     "moreFaresAvailable": false,
                     "reissueSupported": false,
                     "fareRuleMandatory": false
                 },
                 "journey": [
                     {
                         "flight": {
                             "flightKey": "50318357-be53-4c65-a589-e62e6b1c18ec",
                             "flightInfo": {
                                 "duration": "3H40M"
                             },
                             "segmentReference": {
                                 "onPoint": "DXB",
                                 "offPoint": "DEL"
                             },
                             "stopQuantity": 0
                         },
                         "flightSegments": [
                             {
                                 "segmentKey": "8e0370dc-da72-443c-bea2-563371e76ff5",
                                 "departureAirportCode": "DXB",
                                 "departureDateTime": "2023-06-20T03:55:00",
                                 "departureTerminal": "3",
                                 "arrivalAirportCode": "DEL",
                                 "arrivalDateTime": "2023-06-20T09:05:00",
                                 "arrivalTerminal": "3",
                                 "duration": "3H40M",
                                 "flightNumber": "0510",
                                 "resBookDesigCode": "T",
                                 "numberInParty": 1,
                                 "operatingAirline": "EK",
                                 "marketingAirline": "EK",
                                 "seatsAvailable": "9",
                                 "fareBasis": "TLEOPAE1",
                                 "equipmentType": "77W",
                                 "baggageAllowance": {
                                     "carryOnBaggage": [
                                         {
                                             "paxType": "ADT",
                                             "value": "1",
                                             "unit": "PIECE",
                                             "description": "EACH PIECE UP TO 15 POUNDS/7 KILOGRAMS AND UP TO 45 LINEAR INCHES/115 LINEAR CENTIMETERS"
                                         }
                                     ],
                                     "checkedInBaggage": [
                                         {
                                             "paxType": "ADT",
                                             "value": "25",
                                             "unit": "kg"
                                         }
                                     ]
                                 },
                                 "cabinClass": "Economy"
                             }
                         ]
                     }
                 ],
                 "financialInfo": {
                     "tmc": "",
                     "supplier": "Sabre",
                     "subSupplierCode": "BOOKING"
                 },
                 "fare": {
                     "fareKey": "b953331c-6613-41e9-a987-0057b90ee8ee",
                     "currencyCode": "AED",
                     "fareType": {
                         "fareCode": "",
                         "farePreference": "70J",
                         "preferenceContext": "",
                         "oid": "B5AH",
                         "refundable": true
                     },
                     "baseFare": 280,
                     "totalTax": 310,
                     "totalFare": 612.4,
                     "platingAirlineCode": "EK",
                     "customerAdditionalFareInfo": {
                         "transactionFeeEarned": 28,
                         "commissionEarned": 0,
                         "markupEarned": 0,
                         "discount": 5.6,
                         "plbearned": 0,
                         "incentiveEarned": 0,
                         "tdsOnIncentive": 0
                     },
                     "fareBreakdown": [
                         {
                             "fareBreakdownKey": "529c6446-2be4-47b2-9b00-e2b97bfe9171",
                             "passengerKeys": [
                                 "1"
                             ],
                             "fareReference": [
                                 {
                                     "fareBasis": "TLEOPAE1",
                                     "segmentKey": "8e0370dc-da72-443c-bea2-563371e76ff5"
                                 }
                             ],
                             "paxType": "ADT",
                             "paxRate": {
                                 "baseFare": 280,
                                 "totalTax": 310,
                                 "totalFare": 612.4,
                                 "taxes": [
                                     {
                                         "amount": 75,
                                         "taxCode": "AE"
                                     },
                                     {
                                         "amount": 35,
                                         "taxCode": "F6"
                                     },
                                     {
                                         "amount": 5,
                                         "taxCode": "TP"
                                     },
                                     {
                                         "amount": 5,
                                         "taxCode": "ZR"
                                     },
                                     {
                                         "amount": 190,
                                         "taxCode": "YQ"
                                     }
                                 ],
                                 "customerAdditionalFareInfo": {
                                     "transactionFeeEarned": 28,
                                     "commissionEarned": 0,
                                     "markupEarned": 0,
                                     "discount": 5.6,
                                     "plbearned": 0,
                                     "incentiveEarned": 0,
                                     "tdsOnIncentive": 0
                                 }
                             }
                         }
                     ]
                 }
             }
 
 
 */
