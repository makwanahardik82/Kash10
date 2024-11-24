//
//  PhoneBillsDashboardViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 27/01/23.
//

import UIKit

enum PhoneBillType: Int {
    case DU_Prepaid = 0
    case DU_Postpaid
    case Etisalat_Prepaid
    case Etisalat_Postpaid
    
}

struct PhoneBillsDashboardViewModel {

    func getLimitData(type: PhoneBillType, response: @escaping (ResponseModel<LimitDataModel>?, _ error: Error?) -> Void) {
        
        var url = ""
        
        switch type {
        case .DU_Prepaid:
            url = ApiEnd().DU_PREPAID_LIMIT_URL
            break
        case .DU_Postpaid:
            url = ApiEnd().DU_POSTPAID_LIMIT_URL
            break
        case .Etisalat_Prepaid:
            url = ApiEnd().ETISALAT_PREPAID_LIMIT_URL
            break
        case .Etisalat_Postpaid:
            url = ApiEnd().ETISALAT_POSTPAID_LIMIT_URL
            break
        }
        
        WSManager.getRequest(url: url, resultType: ResponseModel<LimitDataModel>.self) { result, error in
           // print(result)
            
            response(result, error)
        }
    }
    
}
