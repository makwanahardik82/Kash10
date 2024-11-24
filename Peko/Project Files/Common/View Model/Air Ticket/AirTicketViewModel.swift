//
//  AirTicketViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 13/06/23.
//

import UIKit

struct JSON {
    static let encoder = JSONEncoder()
}
extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}

struct AirTicketViewModel {
    
    // MARK: - Search Ticket
    func searchTicket(response: @escaping (ResponseModel<AirTicketSearchModel>?, _ error: Error?) -> Void) {
        
        var flightSegmentsArray = [Dictionary<String,Any>]()
        
        let dic1 = [
            "departureAirportCode":objAirTicketManager?.request.origin?.iata_code ?? "",
            "departureDate": objAirTicketManager?.request.departure_date?.formate(format: "yyy-MM-dd") ?? "", // "2023-06-20"
            "departureTimeFrom": "00:05",
            "departureTimeTo": "23:59",
            "arrivalTimeFrom": "00:45",
            "arrivalTimeTo": "23:00",
            "arrivalAirportCode": objAirTicketManager?.request.destination?.iata_code ?? "",
            "cabinPreferences": [5]
        ] as [String : Any]
        
        flightSegmentsArray.append(dic1)
        
        if objAirTicketManager?.airTicketWayType == .RoundTrip {
            let dic = [
                "departureAirportCode":objAirTicketManager?.request.destination?.iata_code ?? "",
                "departureDate": objAirTicketManager?.request.return_date?.formate(format: "yyy-MM-dd") ?? "", // "2023-06-20"
                "departureTimeFrom": "00:05",
                "departureTimeTo": "23:59",
                "arrivalTimeFrom": "00:45",
                "arrivalTimeTo": "23:00",
                "arrivalAirportCode": objAirTicketManager?.request.origin?.iata_code ?? "",
                "cabinPreferences": [5]
            ] as [String : Any]
            
            flightSegmentsArray.append(dic)
        }else if objAirTicketManager?.airTicketWayType == .MultiCity {
            let dic = [
                "departureAirportCode":objAirTicketManager?.request.multi_origin?.iata_code ?? "",
                "departureDate": objAirTicketManager?.request.return_date?.formate(format: "yyy-MM-dd") ?? "", // "2023-06-20"
                "departureTimeFrom": "00:05",
                "departureTimeTo": "23:59",
                "arrivalTimeFrom": "00:45",
                "arrivalTimeTo": "23:00",
                "arrivalAirportCode": objAirTicketManager?.request.multi_destination?.iata_code ?? "",
                "cabinPreferences": [5]
            ] as [String : Any]
            
            flightSegmentsArray.append(dic)
        }
        
        
        let total_adult = objAirTicketManager?.request.travellerDictionary!["adult"] ?? 0
        let total_child = objAirTicketManager?.request.travellerDictionary!["child"] ?? 0
        let infants = objAirTicketManager?.request.travellerDictionary!["infants"] ?? 0
        
        let passengerData = [
            "adultCount": total_adult,
            "childCount": total_child,
            "infantCount": infants
        ]
        
        let parameter: [String : Any] = [
            "flightSegments":flightSegmentsArray,
            "passengerData":passengerData
        ]
        print(parameter.toJSON())
        
        
        WSManager.postRequest(url: ApiEnd().AIR_TICKET_SEARCH_TICKET_URL, param: parameter, resultType:ResponseModel<AirTicketSearchModel>.self) { result, error  in
            // print(result)
            response(result, error)
        }
        
        /*
         WSManager.postRequestJSON(urlString: ApiEnd.AIR_TICKET_SEARCH_TICKET_URL, withParameter: parameter) { success, result in
         if success
         {
         print(result)
         
         }else{
         DispatchQueue.main.async {
         // self.showAlert(title: "", message: "The OTP entered is invalid or expired")
         //   KRProgressHUD.dismiss()
         }
         }
         }
         */
        //
        //        WSManager.postRequest(url: ApiEnd.AIR_TICKET_SEARCH_TICKET_URL, param: parameter, resultType:[String:Any]) { result, error  in
        //            print(result)
        //            response(result!, error)
        //        }
    }
    // MARK: -
    func getFareRules(response: @escaping (ResponseModel<AirTicketFareRulesResponseModel>?, _ error: Error?) -> Void) {
        let parameter = [
            //  "offerId":objAirTicketManager?.selectedAirlinesName?.offerId ?? "",
            "conversationId":objAirTicketManager?.conversationId ?? "",
        ] as [String : Any]
        
        WSManager.postRequest(url: ApiEnd.AIR_TICKET_FARE_RULE_URL, param: parameter, resultType:ResponseModel<AirTicketFareRulesResponseModel>.self) { result, error  in
            // print(result)
            response(result, error)
        }
    }
    
    // MARK: -
    func provisionalBookTicket(response: @escaping (ResponseModel<AirTicketSearchModel>?, _ error: Error?) -> Void) {
        /*
        var passengers_array = [[String:Any]]()
        
        var areaCode = ""
        
        if objShareManager.getAppTarget() == .PekoUAE {
            areaCode = "971"
        }else{
            areaCode = "91"
        }
        var p_index = 1
        for passenger in objAirTicketManager?.passangerArray ?? [AirTicketPassangerDetailsModel]() {
            
            let ptc = (passenger.isChild) ? "CHD" : "ADT"
            let age = passenger.dateOfBirth!.diffInYears()
            // ADT => Adult , CHD => Child
            let gender = passenger.honor.uppercased() == "MR" ? "M":"F"
            
            let dic = [
                "passengerKey": "1",
                "ptc": ptc,
                "age": age,
                "contact": [
                    "postalAddress": [
                        "label": "AddressAtDestination",
                        "street": [
                            "Beeches Apartment",
                            "200 Lampton Road"
                        ],
                        "postalCode": "243434",
                        "cityName": "DXB",
                        "countryCode": "AE"
                    ],
                    "contactsProvided": [
                        [
                            "phone": [
                                [
                                    "label": "Origin",
                                    "areaCode": areaCode,
                                    "phoneNumber": objAirTicketManager?.phoneNumber ?? ""
                                ]
                            ],
                            "emailAddress": [
                                objAirTicketManager?.email ?? ""
                            ]
                        ]
                    ]
                ],
                "passengerInfo": [
                    "surname": "Noor",
                    "gender": "M",
                    "birthDate": passenger.dateOfBirth?.formate(format: "yyyy-mm-dd"),
                    "nameTitle": passenger.honor,
                    "givenName": passenger.last_name
                ],
                "identityDocuments": [
                    [
                        "idDocumentNumber": "56745789",
                        "idType": "PT",
                        "issuingCountryCode": "AE",
                        "residenceCountryCode": "AE",
                        "expiryDate": passenger.passportExpiryDate?.formate(format: "yyyy-mm-dd")
                    ]
                ]
            ] as [String : Any]
            passengers_array.append(dic)
        }
   
        let details = objAirTicketManager?.selectedAirlinesDataModel?.detail?.dictionary
        
        var journeyArray = [[String:Any]]()
        for j in objAirTicketManager?.selectedAirlinesDataModel?.journey ?? [AirportJourneyModel]() {
            journeyArray.append(j.dictionary)
        }
        
        let parameter = [
            "offerId":objAirTicketManager?.selectedAirlinesDataModel?.offerId ?? "",
            "conversationId":objAirTicketManager?.conversationId ?? "",
            "customerInfo":[
                "emailAddress":objAirTicketManager!.email ?? ""
            ],
            "passengers":passengers_array,
            "details":details ?? [String:Any](),
            "journey":journeyArray,
        ] as [String : Any]
        
       */
        
        var areaCode = ""
        
        if objShareManager.getAppTarget() == .PekoUAE {
            areaCode = "971"
        }else{
            areaCode = "91"
        }
        
        var email_address = ""
        var passemger_array = [[String:Any]]()
        
        for passenger in objAirTicketManager?.passangerArray ?? [AirTicketPassangerDetailsModel]() {
            
            
            //            let birthdateString = "\(passenger.year)-\(passenger.month)-\(passenger.day)"
            //            let birthdate = birthdateString.toDate(format: "yyyy-MM-dd")
            //            let age = Calendar.current.numberOfYearsBetween(birthdate, and: Date())
            //
            if email_address.count == 0 {
                email_address = objAirTicketManager?.email ?? ""
            }
            
            let ptc = (passenger.isChild) ? "CHD" : "ADT"
            let age = passenger.dateOfBirth!.diffInYears()
            // ADT => Adult , CHD => Child
            let gender = passenger.honor.uppercased() == "MR" ? "M":"F"
            
            let dic = [
                "passengerKey": "".randomString(length: 9),
                "ptc": ptc,
                "age": age,
                "contact": [
//                    "postalAddress": [
//                        "label": "AddressAtDestination",
//                        "street": [
//                            "Beeches Apartment",
//                            "200 Lampton Road"
//                        ],
//                        "postalCode": "243434",
//                        "cityName": "DXB",
//                        "countryCode": "AE"
//                    ],
                    "contactsProvided": [
                        [
                            "phone": [
                                [
                                    "label": "Origin",
                                    "areaCode": areaCode,
                                    "phoneNumber": objAirTicketManager?.phoneNumber ?? ""
                                ]
                            ],
                            "emailAddress": [
                                objAirTicketManager?.email ?? ""
                            ]
                        ]
                    ]
                ],
                "passengerInfo": [
                    "surname": passenger.last_name,
                    "gender": gender,
                    "birthDate": passenger.dateOfBirth?.formate(format: "yyyy-MM-dd") ?? "",
                    "nameTitle": passenger.honor ,
                    "givenName": passenger.first_name
                ],
                "identityDocuments": [
                    [
                        "idDocumentNumber": passenger.passportNumber,
                        "idType": "PT",
                        "issuingCountryCode": passenger.passportIssueCountry,
                        "residenceCountryCode": passenger.nationality,
                        "expiryDate": passenger.passportExpiryDate?.formate(format: "yyyy-MM-dd")
                    ]
                ]
            ] as [String : Any]
            passemger_array.append(dic)
        }
        
        let details = objAirTicketManager?.selectedAirlinesDataModel?.detail?.dictionary
        
        var journeyArray = [[String:Any]]()
        for j in objAirTicketManager?.selectedAirlinesDataModel?.journey ?? [AirportJourneyModel]() {
            journeyArray.append(j.dictionary)
        }
        
        let parameter = [
            "offerId":objAirTicketManager?.selectedAirlinesDataModel?.offerId ?? "",
            "conversationId":objAirTicketManager?.conversationId ?? "",
            "customerInfo":[
                "emailAddress":email_address
            ],
            "passengers":passemger_array,
            "details":details ?? [String:Any](),
            "journey":journeyArray,
        ] as [String : Any]
        
        print(parameter)

        print(parameter.toJSON())
        
        WSManager.postRequest(url: ApiEnd().AIR_TICKET_PROVISIONAL_BOOK_URL, param: parameter, resultType:ResponseModel<AirTicketSearchModel>.self) { result, error  in
            // print(result)
            response(result, error)
        }
        
    }
    // MARK: -
    func bookTicket(finalAmount:Double, response: @escaping (ResponseModel<AirTicketBookResponseModel>?, _ error: Error?) -> Void) {
        
        let parameter = self.getParametersForCreateNIOrder(amount: finalAmount)
        print(parameter.toJSON())
        
        WSManager.postRequest(url: ApiEnd().AIR_TICKET_BOOK_TICKET_URL, param: parameter, resultType:ResponseModel<AirTicketBookResponseModel>.self) { result, error  in
            // print(result)
            response(result, error)
        }
    }
    // MARK: - Get Parameter
    func getParametersForCreateNIOrder(amount:Double) -> [String:Any] {
        var areaCode = ""
        
        if objShareManager.getAppTarget() == .PekoUAE {
            areaCode = "971"
        }else{
            areaCode = "91"
        }
        
        var email_address = ""
        var passemger_array = [[String:Any]]()
        
        for passenger in objAirTicketManager?.passangerArray ?? [AirTicketPassangerDetailsModel]() {
            
            if email_address.count == 0 {
                email_address = objAirTicketManager?.email ?? ""
            }
            
            let ptc = (passenger.isChild) ? "CHD" : "ADT"
            let age = passenger.dateOfBirth!.diffInYears()
            // ADT => Adult , CHD => Child
            let gender = passenger.honor.uppercased() == "MR" ? "M":"F"
            
            let dic = [
                "passengerKey": "".randomString(length: 9),
                "ptc": ptc,
                "age": age,
                "contact": [
                    //                    "postalAddress": [
                    //                        "label": "AddressAtDestination",
                    //                        "street": [
                    //                            "Beeches Apartment",
                    //                            "200 Lampton Road"
                    //                        ],
                    //                        "postalCode": "243434",
                    //                        "cityName": "DXB",
                    //                        "countryCode": "AE"
                    //                    ],
                    "contactsProvided": [
                        [
                            "phone": [
                                [
                                    "label": "Origin",
                                    "areaCode": areaCode,
                                    "phoneNumber": objAirTicketManager?.phoneNumber ?? ""
                                ]
                            ],
                            "emailAddress": [
                                objAirTicketManager?.email ?? ""
                            ]
                        ]
                    ]
                ],
                "passengerInfo": [
                    "surname": passenger.last_name,
                    "gender": gender,
                    "birthDate": passenger.dateOfBirth?.formate(format: "yyyy-MM-dd") ?? "",
                    "nameTitle": passenger.honor ,
                    "givenName": passenger.first_name
                ],
                "identityDocuments": [
                    [
                        "idDocumentNumber": passenger.passportNumber,
                        "idType": "PT",
                        "issuingCountryCode": passenger.passportIssueCountry,
                        "residenceCountryCode": passenger.nationality,
                        "expiryDate": passenger.passportExpiryDate?.formate(format: "yyyy-MM-dd")
                    ]
                ]
            ] as [String : Any]
            passemger_array.append(dic)
        }
    
    // objAirTicketManager?.selectedAirlinesDataModel
        var parameter = [
            "offerId":objAirTicketManager?.selectedAirlinesDataModel?.offerId ?? "",
            "conversationId":objAirTicketManager?.provisionConversationId ?? "",
            "fare":amount,
            "amount":amount,
            "customerInfo":[
                "emailAddress":objAirTicketManager!.email ?? ""
            ],
            "passengers":passemger_array,
            "currencyCode": objAirTicketManager?.selectedAirlinesDataModel?.fare?.currencyCode ?? "",
            "accessKey": "travelApi_airline"
        ] as [String : Any]
        
        if objAirTicketManager?.selectedAirlinesDataModel?.detail?.lcc == true && objAirTicketManager?.ancillaryArray.count != 0 {
            parameter["isLcc"] = false
            parameter["totalAncillaryPrice"] = objAirTicketManager?.addOnsAmount ?? 0.0
            parameter["ancillaryDetails"] =  objAirTicketManager?.ancillaryArray
        }else{
            parameter["isLcc"] = false
            parameter["totalAncillaryPrice"] = 0
            parameter["ancillaryDetails"] = []
        }
        
        return parameter
    }
    
    
    // MARK: - History
    
    func getHisoryList(offset:Int, limit:Int = 10, response: @escaping (ResponseModel<AirTicketHistoryListModel>?, _ error: Error?) -> Void) {
        
        let url = ApiEnd().AIR_TICKET_HISTORY_BOOK_URL + "?page=\(offset)&limit=\(limit)"
       
        WSManager.getRequest(url: url, resultType: ResponseModel<AirTicketHistoryListModel>.self) { result, error in
            response(result, error)
        }
    }
    
    // MARK: - Get Download
    func getDownloadTicket(o_id:Int, response: @escaping (ResponseModel<HotelBookingDownloadResponseDataModel>?, _ error: Error?) -> Void) {
        let url = ApiEnd().AIR_TICKET_DOWNLOAD_TICKET_URL  + "?orderId=\(o_id)"
       
        WSManager.postRequest(url: url, param: [:], resultType: ResponseModel<HotelBookingDownloadResponseDataModel>.self) { result, error  in
            response(result!, error)
        }
    }
    
    func getAncSearch(response: @escaping (ResponseModel<AirTicketAncSearchResponseModel>?, _ error: Error?) -> Void) {
        let url = ApiEnd().AIR_TICKET_ANC_SEARCH_URL //  + "?orderId=\(o_id)"
       
        let parameter = [
            "offerId": objAirTicketManager?.selectedAirlinesDataModel?.offerId ?? "",
            "conversationId": objAirTicketManager?.provisionConversationId ?? "",
                "supplierLocator": "",
                "isLcc": true
        ] as [String : Any]
        
        print(parameter.toJSON())
        WSManager.postRequest(url: url, param: parameter, resultType: ResponseModel<AirTicketAncSearchResponseModel>.self) { result, error  in
            response(result!, error)
        }
    }
    
    func provisionalAncSearchAncillary(ancillaryArray:[Dictionary<String, String>],response: @escaping (ResponseModel<AncillariesResponseModel>?, _ error: Error?) -> Void) {
        let url = ApiEnd().AIR_TICKET_ANC_PRO_BOOK_URL //  + "?orderId=\(o_id)"
       
        let parameter = [
            
                "selectedAncillaries": ancillaryArray,
                "conversationId": objAirTicketManager?.provisionConversationId ?? "",
                "isLcc": true,
                "offerId": objAirTicketManager?.selectedAirlinesDataModel?.offerId ?? ""
            
        ] as [String : Any]
        print(parameter.toJSON())
      
        WSManager.postRequest(url: url, param: parameter, resultType: ResponseModel<AncillariesResponseModel>.self) { result, error  in
            response(result!, error)
        }
    }
    
}
