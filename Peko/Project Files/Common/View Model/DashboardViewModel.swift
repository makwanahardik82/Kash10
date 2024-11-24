//
//  DashboardViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 15/03/23.
//

import UIKit

struct DashboardViewModel {

    func getProfileDetails(response: @escaping (ResponseModel<ProfileDetailModel>?, _ error: Error?) -> Void) {
        let url = ApiEnd().GET_BASIC_PROFILE_DETAILS
        WSManager.getRequest(url: url, resultType: ResponseModel<ProfileDetailModel>.self) { result, error  in
            response(result, error)
        }
    }
    func getProfileWalletDetails(response: @escaping (ResponseModel<ProfileWalletModel>?, _ error: Error?) -> Void) {
        let url = ApiEnd().GET_PROFILE_WALLET_DETAILS
        WSManager.getRequest(url: url, resultType: ResponseModel<ProfileWalletModel>.self) { result, error  in
            response(result, error)
        }
    }
    
    
    
    // MARK: - Dashboard
    func getDashboardDetails(response: @escaping (ResponseModel<DashboardModel>?, _ error: Error?) -> Void) {
        let url = ApiEnd().GET_DASHBOARD_DETAILS
        WSManager.getRequest(url: url, resultType: ResponseModel<DashboardModel>.self) { result, error in
           // print(result)
            response(result, error)
        }
        
//        WSManager.getRequestJSON(urlString: url, withParameter: nil) { success, result in
//            print(result)
//        }
    }
}
