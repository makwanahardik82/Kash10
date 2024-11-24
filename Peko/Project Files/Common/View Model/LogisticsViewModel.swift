//
//  LogisticsViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 10/09/23.
//

import UIKit

struct LogisticsViewModel {
    
    func getAllCountry(response: @escaping (ResponseModel<LogisticsCountryResponseDataModel>?, _ error: Error?) -> Void) {
        WSManager.getRequest(url: ApiEnd().LOGISTICS_GET_ALL_COUNTRY, resultType: ResponseModel<LogisticsCountryResponseDataModel>.self) { result, error in
            response(result, error)
        }
    }
    // MARK: - Get City
    func getCityFromCountry(countryCode:String, response: @escaping (ResponseModel<LogisticsCityResponseModel>?, _ error: Error?) -> Void) {
        
        let urlString = ApiEnd().LOGISTICS_GET_CITIES + "?" + "countryCode=\(countryCode)"
        
        WSManager.getRequest(url:urlString, resultType: ResponseModel<LogisticsCityResponseModel>.self) { result, error in
          //  print(result)
            response(result, error)
        }
    }
    
    
    // MARK: - Get Address
    func getSavedAddress(isReceiver:Bool, response: @escaping (ResponseModel<AddressResponseDataModel2>?, _ error: Error?) -> Void) {
        
        let urlString = ApiEnd().LOGISTICS_GET_SAVED_ADDRESS + "?" + "isReceiver=\(isReceiver)"
        
        WSManager.getRequest(url:urlString, resultType: ResponseModel<AddressResponseDataModel2>.self) { result, error in
          //  print(result)
            response(result, error)
        }
    }
    
    // MARK: - Saved Address
    func addAddress(request:LogisticsAddressDetailModel, isReceiver:Bool, response: @escaping (ResponseModel<AddressModel>?, _ error: Error?) -> Void) {
        
        
        let parameter = [
           //     "credentialId": objUserSession.user_id,
          //      "nickname": "",
                "name": request.name ?? "",
             //   "department": "",
                "city": request.city ?? "",
                "country": request.country ?? "",
                "countryCode": request.countryCode ?? "",
                "addressLine1": request.buldingName ?? "",
                "addressLine2": request.addressLine1 ?? "",
                "phoneNumber": request.mobileNumber ?? "",
                "email": request.email ?? "",
                "zipCode": "",
                "isReceiver": isReceiver ? 1 : 0,
                "default": 0
        ] as [String : Any]
    
        print(parameter.toJSON())
        WSManager.postRequest(url: ApiEnd().LOGISTICS_ADD_ADDRESS, param: parameter, resultType: ResponseModel<AddressModel>.self) { result, error in
            response(result, error)
        }
    }
    
    // MARK: - Calculate Rate
    func calculateRate(response: @escaping (ResponseModel<LogisticsCalculateRateResponseModel>?, _ error: Error?) -> Void) {
        /*
        let originAddress = [
            "Line1": objLogisticsManager?.senderAddress?.name ?? "",
            "Line2": objLogisticsManager?.senderAddress?.buldingName ?? "",
            "Line3": "Address",
            "City": objLogisticsManager?.senderAddress?.city ?? "",
            "PostCode": "",
            "CountryCode": objLogisticsManager?.senderAddress?.countryCode ?? "",
            "Longitude": 0,
            "Latitude": 0,
            "Description": ""
        ] as [String : Any]
        
        
        let destinationAddress = [
            "Line1": objLogisticsManager?.receiverAddress?.name ?? "",
            "Line2": objLogisticsManager?.receiverAddress?.buldingName ?? "",
            "Line3": "Address",
            "City": objLogisticsManager?.receiverAddress?.city ?? "",
            "StateOrProvinceCode": "",
            "PostCode": "",
            "CountryCode": objLogisticsManager?.receiverAddress?.countryCode ?? "",
            "Longitude": 0,
            "Latitude": 0,
            "POBox": "",
            "Description": ""
        ] as [String : Any]
        
        var ProductGroup = ""
        if objLogisticsManager?.senderAddress?.countryCode == objLogisticsManager?.receiverAddress?.countryCode {
            ProductGroup = "DOM"
        }else{
            ProductGroup = "EXP"
        }
       
       let param = [
            "originAddress": originAddress,
            "destinationAddress": destinationAddress,
            "actualWeight":objLogisticsManager?.shipmentDetailModel?.weight ?? "0",
            "numberOfPieces":objLogisticsManager?.shipmentDetailModel?.noOfPieces ?? "0",
            "productGroup":ProductGroup,
            "productType":"OND",
            "customsValueAmount":0,
            "quantity":objLogisticsManager?.shipmentDetailModel?.noOfPieces ?? "0"
       ] as [String : Any]
         */
        let parameter = self.getParametersForCreateNIOrder(amount: 0.0)
        
        print(parameter.toJSON())
      
        WSManager.postRequest(url: ApiEnd().LOGISTICS_CALCULATE_RATE, param: parameter, resultType: ResponseModel<LogisticsCalculateRateResponseModel>.self) { result, error in
            response(result, error)
        }
        
        
    }
   
    // MARK: - Create Shipment
    func createShipment(finalAmount:Double, response: @escaping (ResponseModel<LogisticsCreateShipmentResponseModel>?, _ error: Error?) -> Void) {
       
        let parameter = self.getParametersForCreateNIOrder(amount: finalAmount)
        
        WSManager.postRequest(url: ApiEnd().LOGISTICS_CREATE_SHIPMENT, param: parameter, resultType: ResponseModel<LogisticsCreateShipmentResponseModel>.self) { result, error in
            response(result, error)
        }
    }
    
    func getParametersForCreateNIOrder(amount:Double) -> [String:Any] {
        let originAddress = [
            "Line1": objLogisticsManager?.senderAddress?.name ?? "",
            "Line2": objLogisticsManager?.senderAddress?.buldingName ?? "",
            "Line3": objLogisticsManager?.senderAddress?.addressLine1 ?? "",
            "City": objLogisticsManager?.senderAddress?.city ?? "",
            "PostCode": objLogisticsManager?.senderAddress?.pinCode ?? "",
            "CountryCode": objLogisticsManager?.senderAddress?.countryCode ?? "",
     //       "Longitude": 0,
       //     "Latitude": 0,
            "Description": objLogisticsManager?.senderAddress?.email ?? ""
        ] as [String : Any]
        
        let destinationAddress = [
            "Line1": objLogisticsManager?.receiverAddress?.name ?? "",
            "Line2": objLogisticsManager?.receiverAddress?.buldingName ?? "",
            "Line3": objLogisticsManager?.receiverAddress?.addressLine1 ?? "",
            "City": objLogisticsManager?.receiverAddress?.city ?? "",
       //     "StateOrProvinceCode": "",
            "PostCode": objLogisticsManager?.receiverAddress?.pinCode ?? "",
            "CountryCode": objLogisticsManager?.receiverAddress?.countryCode ?? "",
            "Longitude": 0,
            "Latitude": 0,
         //   "POBox": "",
            "Description": objLogisticsManager?.receiverAddress?.email ?? ""
        ] as [String : Any]
        
        var ProductGroup = ""
        if objLogisticsManager?.senderAddress?.countryCode == objLogisticsManager?.receiverAddress?.countryCode {
            ProductGroup = "DOM"
        }else{
            ProductGroup = "EXP"
        }
        let dateString = objLogisticsManager?.shipmentDetailModel?.sheduleDate?.formate(format: "yyyy-MM-dd hh:mm")
        var parameter = [
            "originAddress": originAddress,
            "destinationAddress": destinationAddress,
            "actualWeight":objLogisticsManager?.shipmentDetailModel?.weight ?? "0",
            "numberOfPieces":objLogisticsManager?.shipmentDetailModel?.noOfPieces ?? "0",
            "productGroup":ProductGroup,
            "productType":"OND",
            "customsValueAmount":0,
            "quantity":objLogisticsManager?.shipmentDetailModel?.noOfPieces ?? "0",
            
        ] as [String : Any]
        //
        
        if amount != 0.0 {
            parameter["amount"] = amount
            parameter["date"] = dateString ?? ""
            parameter["shipmentContent"] = (objLogisticsManager!.shipmentDetailModel?.content ?? "").lowercased()
            parameter["accessKey"] = "shipment_services"
        }
        
        return parameter
    }
    
    
    
    // MARK: - Get History
    func getHistory(page:Int, limit:Int, response: @escaping (ResponseModel<PekoStoreOrderListResponseModel>?, _ error: Error?) -> Void) {
        
        let urlString = ApiEnd().LOGISTICS_HISTORY + "?" + "searchText=&sort=DESC&page=\(page)&itemsPerPage=\(limit)"
        
        WSManager.getRequest(url:urlString, resultType: ResponseModel<PekoStoreOrderListResponseModel>.self) { result, error in
          //  print(result)
            response(result, error)
        }
    }
    
    func trackLogistics(order_id:String, response: @escaping (ResponseModel<LogisticsShipmentTrackModel>?, _ error: Error?) -> Void) {
        
        let parameter = [
            "shipments": [
                order_id
            ],
            "lastTrackingUpdate": true
        ] as [String : Any]
        
        WSManager.postRequest(url: ApiEnd().LOGISTICS_TRACK_SHIPMENTS, param: parameter, resultType: ResponseModel<LogisticsShipmentTrackModel>.self) { result, error in
            response(result, error)
        }
    }
}


