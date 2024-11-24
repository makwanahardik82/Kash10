//
//  HotelBookingViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 05/01/24.
//

import UIKit


struct HotelBookingViewModel {
    
    // MARK: - Saved Address
    func searchHotel(searchRequest:HotelBookingSearchRequest, response: @escaping (ResponseModel<HotelBookingSearchResponseModel>?, _ error: Error?) -> Void) {
        
        let country = objShareManager.appTarget == .PekoUAE ? "United Arab Emirates":"India"
        let countryCode = objShareManager.appTarget == .PekoUAE ? "UAE":"IN"
        let checkInDate = searchRequest.checkInDate!.formate(format: "yyyy-MM-dd")
        let checkOutDate = searchRequest.checkOutDate!.formate(format: "yyyy-MM-dd")
        
        var array = [Dictionary<String, Any>]()
        
        for (index, item) in searchRequest.travellersArray!.enumerated() {
            var d = item
            d["roomIndex"] = index + 1
            array.append(d)
        }
       
        let param = [
                "country": country,
                "city": searchRequest.city ?? "",
                "checkIn": checkInDate,
                "checkOut": checkOutDate,
                "rooms": array,//searchRequest.travellersArray ?? [Dictionary<String, Any>](),
                "originCountry": "\(country),\(countryCode)".uppercased()
        ] as [String : Any]
        
        print(param.toJSON())
        WSManager.postRequest(url: ApiEnd().HOTEL_BOOKING_SEARCH_HOTELS, param: param, resultType: ResponseModel<HotelBookingSearchResponseModel>.self) { result, error in
         //   print(result)
            response(result, error)
        }
    }
    // MARK: - Get Hotel Details
    // MARK: - Saved Address
    func getHotelDetails(response: @escaping (ResponseModel<HotelBookingHotelDetailsResponseModel>?, _ error: Error?) -> Void) {
        
        let param = [
            "hotelKey": objHotelBookingManager!.hotelKey,
            "searchKey": objHotelBookingManager!.searchKey,
            "conversationId": objHotelBookingManager!.conversationId 
        ]
        
        print(param.toJSON())
        
        WSManager.postRequest(url: ApiEnd().HOTEL_BOOKING_HOTEL_ROOMS_DETAILS, param: param, resultType: ResponseModel<HotelBookingHotelDetailsResponseModel>.self) { result, error in
         //   print(result)
            response(result, error)
        }
        
    }
    func getCancellationPolicy(response: @escaping (CancellationPolicyResponseModel?, _ error: Error?) -> Void) {
        
        let param = [
    //        "rooms": objHotelBookingManager!.roomKeyArray(),
            "hotelKey": objHotelBookingManager!.hotelKey ,
            "searchKey": objHotelBookingManager!.searchKey,
            "conversationId": objHotelBookingManager!.conversationId
        ] as [String : Any]
       
        print(param.toJSON())
       
        WSManager.postRequest(url: ApiEnd.HOTEL_BOOKING_HOTEL_CANCELLATION_POLICY, param: param, resultType: CancellationPolicyResponseModel.self) { result, error in
         //   print(result)
            response(result, error)
        }
    }
    // MARK: -
    func preBook(response: @escaping (ResponseModel<HotelBookingPreBookResponseModel>?, _ error: Error?) -> Void) {
        
        
       var rooms = [Dictionary<String, Any>]()
        
        for room in objHotelBookingManager!.selectedRooms {
            let dic = [
                "roomIndex": room.roomIndex ?? 0,
                "roomKey": room.roomKey ?? ""
            ] as [String : Any]
            rooms.append(dic)
        }
        
        let param = [
            "rooms": rooms,
            "hotelKey": objHotelBookingManager!.hotelKey ,
            "searchKey": objHotelBookingManager!.searchKey,
            "conversationId": objHotelBookingManager!.conversationId
        ] as [String : Any]
    
        print(param.toJSON())
        
        WSManager.postRequest(url: ApiEnd().HOTEL_BOOKING_HOTEL_PRE_BOOK, param: param, resultType: ResponseModel<HotelBookingPreBookResponseModel>.self) { result, error in
            print(result)
            response(result, error)
        }
    }
    // MARK: - Book Hotel
    func bookHotel(amount:Double, response: @escaping (ResponseModel<HotelBookingOrderResponseModel>?, _ error: Error?) -> Void) {
       
        let param = self.getParametersForCreateNIOrder(amount: amount)
    
        print(param.toJSON())
        
        WSManager.postRequest(url: ApiEnd().HOTEL_BOOKING_HOTEL_BOOK, param: param, resultType: ResponseModel<HotelBookingOrderResponseModel>.self) { result, error in
            print(result)
            response(result, error)
        }
        
    }
    // MARK: -
    func getParametersForCreateNIOrder(amount:Double) -> [String:Any] {
        let clientReference = Int(Date().timeIntervalSince1970)
        let country = objShareManager.appTarget == .PekoUAE ? "United Arab Emirates":"India"
        let countryCode = objShareManager.appTarget == .PekoUAE ? "UAE":"IN"
        let checkInDate = objHotelBookingManager!.searchRequest?.checkInDate!.formate(format: "yyyy-MM-dd")
        let checkOutDate = objHotelBookingManager!.searchRequest?.checkOutDate!.formate(format: "yyyy-MM-dd")
       
        let imageURL = objHotelBookingManager?.hotelListData?.propertyInfo?.imageUrl ?? ""
    
        
        var roomArray = [Dictionary<String, Any>]()
    
        var adultArray = objHotelBookingManager!.guestArray.filter({ $0.isChild == false })
        var childArray = objHotelBookingManager!.guestArray.filter({ $0.isChild == true })
  
        let rooms = objHotelBookingManager!.hotelPreBookResponse!.hotel!.rooms!
      
        var index = 0
        for room in rooms {
           // let guestModel = objHotelBookingManager?.guestArray[index]
            
            
            var array = [Dictionary<String, Any>]()
            
            let travellersDictionary = objHotelBookingManager?.searchRequest?.travellersArray![index]
            
            let total_adult = (travellersDictionary!["adult"] as? Int) ?? 0
            let total_child = (travellersDictionary!["child"] as? Int) ?? 0
            
            let a_arr = adultArray.prefix(total_adult)
            adultArray.removeFirst(total_adult)
            
            for guestModel in a_arr {
                let passengers = self.getGuestDetails(guestModel: guestModel, isLead: true)
                array.append(passengers)
            }
            
            let c_arr = childArray.prefix(total_child)
            childArray.removeFirst(total_child)
           
            for guestModel in c_arr {
                let passengers = self.getGuestDetails(guestModel: guestModel, isLead: true)
                array.append(passengers)
            }
            
            let room = [
                "roomIndex": room.roomIndex ?? 0,
                "roomKey": room.roomKey ?? "",
                "passengers":array
            ] as [String : Any]
            
            roomArray.append(room)
            index += 1
          
        }
        print(roomArray)
        // MARK: -
        let stayDateRange = [
            "checkIn": checkInDate,
            "checkOut": checkOutDate
        ]
        
        // EMAIL MUST not allow empty email phone, address
        let hotelContact = [
            "email": objHotelBookingManager?.hotelListData?.email ?? "",
            "phoneNumber": objHotelBookingManager?.hotelListData?.phoneNumber ?? "",
            "checkInTime": "00:00",
            "checkOutTime": "12:00",
            "image": imageURL,
            "address": objHotelBookingManager?.hotelListData?.address ?? "",
            "city": objHotelBookingManager?.searchRequest?.city ?? "",
            "country": country
        ]
        
        let taxDetails = [
            "taxName": "gst",
            "registerNumber": objUserSession.profileDetail?.mobileNo ?? "", // NOT ALLOWE EMPTY
            "companyName": objUserSession.profileDetail?.companyName ?? "",
            "emailAddress": objUserSession.profileDetail?.email ?? "",
            "phoneNumber": objUserSession.profileDetail?.mobileNo ?? "",
            "address": objUserSession.profileDetail?.city
            //                "address": objUserSession.profileDetail?.city ?? ""
        ]
        let paymentDetails = [
            "paymentMode": "CR",
            "cardInfo": "",
            "address": [
                "label": "Billing",
                "street": [
                    "Beeches Apartment",
                    "200 Lampton Road"
                ],
                "postalCode": "TW345RT",
                "cityName": objHotelBookingManager?.searchRequest?.city ?? "",
                "countryCode": countryCode
            ]
        ] as [String : Any]
        
        let param = [
            "hotelKey": objHotelBookingManager?.hotelKey ?? "",
            "searchKey": objHotelBookingManager?.searchKey ?? "",
            "conversationId": objHotelBookingManager?.conversationId ?? "",
            "clientReference": "\(clientReference)",
            "bookingKey": objHotelBookingManager?.hotelPreBookResponse?.hotel?.bookingKey ?? "",
            "amount": objHotelBookingManager?.hotelPreBookResponse?.hotel?.totalNet?.value ?? 0.0,
            "currency": objHotelBookingManager?.hotelPreBookResponse?.hotel?.currency ?? "",
            "culture": "en",
            "stayDateRange":stayDateRange,
            "billingEmail": objUserSession.profileDetail?.email ?? "",
            "accessKey": "hotels_api",
            "hotelContact":hotelContact,
            "taxDetails":taxDetails,
            "paymentDetails":paymentDetails,
            "rooms":roomArray
        ]
        as [String : Any]
        
        return param
    }
    
    // MARK: - Get Hotel Listing
    // MARK: - Saved Address
    func getHotelBookingListing(page:Int, limit:Int, response: @escaping (ResponseModel<HotelBookingHistoryReponseDataModel>?, _ error: Error?) -> Void) {
        let url = ApiEnd().HOTEL_BOOKING_HISTORY + "?page=1&limit=20"
        WSManager.getRequest(url: url, resultType: ResponseModel<HotelBookingHistoryReponseDataModel>.self) { result, error in
            response(result, error)
        }
    }
    func cancelBooking(bookingReferenceId:String, conversationId:String, corporateTxnId:String, response: @escaping (ResponseModel<HotelBookingOrderResponseModel>?, _ error: Error?) -> Void) {
        
        let param = [
            "bookingReferenceId":bookingReferenceId,
            "conversationId":conversationId,
            "selectedCorporateTxnId": corporateTxnId
        ]
        print(param.toJSON())
        WSManager.postRequest(url: ApiEnd().HOTEL_BOOKING_CANCEL_BOOKING, param: param, resultType: ResponseModel<HotelBookingOrderResponseModel>.self) { result, error in
            print(result)
            response(result, error)
        }
    }
    
    // MARK: - Get Download
    func getDownloadInvoice(o_id:Int, response: @escaping (ResponseModel<HotelBookingDownloadResponseDataModel>?, _ error: Error?) -> Void) {
        let url = ApiEnd().HOTEL_BOOKING_DOWNLOAD_TICKET + "?orderId=\(o_id)"
        
        WSManager.getRequest(url: url, resultType: ResponseModel<HotelBookingDownloadResponseDataModel>.self) { result, error in
            response(result, error)
        }
    }
    
    
    // MARK: -
    
    func getGuestDetails(guestModel:HotelBookingGuestModel, isLead:Bool) -> [String : Any]{
       
        var areaCode = ""
        if objShareManager.getAppTarget() == .PekoUAE {
            areaCode = "971"
        }else{
            areaCode = "91"
        }
        let ptc = (guestModel.isChild!) ? "CHD" : "ADT"
        let gender = guestModel.honor.uppercased() == "MR" ? "male":"female"
      
        let passengerInfo = [
            "birthDate": "2007-06-06",
            "gender": gender,
            "nameTitle": guestModel.honor ,
            "givenName": guestModel.first_name ,
            "middleName": "none",
            "surname": guestModel.last_name 
        ]
        
        let postalAddress = [
            "label": "test123",
            "street": [
                "testStreet"
            ],
            "postalCode": "2432434",
            "cityName": "mumbai",
            "countryCode": "IN"
        ] as [String : Any]
        let contactProvided = [
            "emailAddress": [
                objUserSession.profileDetail?.email ?? ""
            ],
            "phone": [
                [
                    "label": "string",
                    "areaCode": areaCode,
                    "phoneNumber": objUserSession.profileDetail?.mobileNo ?? ""
                ]
            ]
        ]
        
        let contact = [
            "postalAddress":postalAddress,
            "contactProvided":[contactProvided]
        ] as [String : Any]
        let passengers = [
            "passengerKey": "1",
            "mealPreference": "breakfast",
            "isLead": true,
            "ptc": "ADT",
            "passengerInfo":passengerInfo,
            "contact":contact
        ] as [String : Any]
        
        return passengers
    }
    
}



