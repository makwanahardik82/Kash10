//
//  eSimViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 14/04/24.
//

import UIKit


struct eSimViewModel {
    
    func getSupportedDevice(response: @escaping (ResponseModel<DeviceListResponseDataModel>?, _ error: Error?) -> Void) {
      
        let url = ApiEnd().GET_ESIM_COMPATIBLE_DEVICE
       
        WSManager.getRequest(url: url, resultType: ResponseModel<DeviceListResponseDataModel>.self) { result, error in
            response(result, error)
        }
    }
    
    // MARK
    func getPackages(type:String, countryCode:String,response: @escaping (ResponseModel<PackageResponseDataModel>?, _ error: Error?) -> Void) {
      
        let url = ApiEnd().GET_ESIM_PACKAGE + "?type=\(type)&country=\(countryCode)" //&limit=&page="
       
        WSManager.getRequest(url: url, resultType: ResponseModel<PackageResponseDataModel>.self) { result, error in
            response(result, error)
        }
    }
    
    func payment(finalAmount:Double, response: @escaping (ResponseModel<ESimPaymentResponseDataModel>?, _ error: Error?) -> Void) {
      
        let url = ApiEnd().GET_ESIM_PAYMENT
        
        
        let parameter = self.getParametersForCreateOrder(amount: finalAmount)
        
        print(parameter.toJSON())
        WSManager.postRequest(url: url, param: parameter, resultType: ResponseModel<ESimPaymentResponseDataModel>.self) { result, error in
            response(result, error)
        }
    }
    
    
    func getParametersForCreateOrder(amount:Double) -> [String:Any] {
        let operators =  objeSIMManager?.selectedPackage?.operators?.first
       
        let parameter = [
            "amount" : amount.decimalPoints(point: 2),
            "packageId" : objeSIMManager?.selectedeSimPackage?.id ?? "",
            "quantity": 1,
            "type" : (objeSIMManager?.selectedeSimPackage?.type ?? "").uppercased(),
            "operatorImage" : operators?.image?.url ?? "",
            "operatorName" : operators?.title ?? "",
            "isRechargable" : operators?.rechargeability ?? false,
            "accessKey":"e_sim"
            
        ] as [String : Any]
        
        return parameter
    }
    
    // MARK: - Get History
    
    // MARK
    func getHistory(offset:Int, limit:Int = 10, response: @escaping (ResponseModel<HistoryResponseDataModel>?, _ error: Error?) -> Void) {
      
        let url = ApiEnd().GET_ESIM_HISTORY + "?searchText=&sort=DESC&page=\(offset)&itemsPerPage=\(limit)"
        
        WSManager.getRequest(url: url, resultType: ResponseModel<HistoryResponseDataModel>.self) { result, error in
            response(result, error)
        }
    }
    
    func getHistoryDetail(orderID:Int, iccid:String, response: @escaping (ResponseModel<eSimHistoryDetailModel>?, _ error: Error?) -> Void) {
      
        let url = ApiEnd().GET_ESIM_HISTORY_ORDER_DETAIL + "?orderId=\(orderID)&iccid=\(iccid)"
        
        WSManager.getRequest(url: url, resultType: ResponseModel<eSimHistoryDetailModel>.self) { result, error in
            response(result, error)
        }
    }
 
}
