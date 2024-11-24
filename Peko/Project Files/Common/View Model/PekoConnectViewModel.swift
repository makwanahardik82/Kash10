//
//  PekoConnectViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 22/05/23.
//

import UIKit

struct PekoConnectViewModel {
    
    // MARK: - getAllConnect
    func getAllConnect(response: @escaping (ResponseModel<PekoConnectResponseDataModel>?, _ error: Error?) -> Void) {
        
        let url = ApiEnd().PEKO_CONNECT_GET_ALL_URL
        print("\n\n\n URL => ", url)
        
        WSManager.getRequest(url: url, resultType: ResponseModel<PekoConnectResponseDataModel>.self) { result, error in
            //   print(result)
            response(result, error)
        }
    }
    func getServiceProviderDetail(p_id:Int, response: @escaping (ResponseModel<PekoConnectDetailResponseDataModel>?, _ error: Error?) -> Void) {
        
        let url = ApiEnd().PEKO_CONNECT_DETAIL_URL + "\(p_id)"
        print("\n\n\n URL => ", url)
        
        WSManager.getRequest(url: url, resultType: ResponseModel<PekoConnectDetailResponseDataModel>.self) { result, error in
            //   print(result)
            response(result, error)
        }
    }
    
    
    
    /*
     
     
     */
    // MARK: -
    func pekoConnect(request:PekoConnectRequest, serviceProvider:PekoConnectModel, response: @escaping (ResponseModel<PekoConnectModel>?, _ error: Error?) -> Void) {
     
        var code = objUserSession.mobileCountryCode
        
        let parameter: [String : Any] = [
            "credentialId": objUserSession.user_id,
            "name": request.name ?? "",
            "mobile": code + (request.phoneNumber ?? ""),
            "email": request.email ?? "",
            "requirement": request.requirement ?? "",
            "preferredMode": request.preferredMode ?? "",
            "connectId": serviceProvider.id ?? 0
        ]
        
        print(parameter)
        
        WSManager.postRequest(url: ApiEnd().PEKO_CONNECT_URL, param: parameter, resultType: ResponseModel<PekoConnectModel>.self) { result, error  in
            response(result!, error)
        }
       
    }
}
