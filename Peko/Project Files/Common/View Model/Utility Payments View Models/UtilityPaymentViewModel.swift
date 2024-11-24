//
//  UtilityPaymentViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 01/04/23.
//

import UIKit

enum UtilityPaymentType: Int {
    case FEWA = 0
    case AADC
    case ADDC
    case Ajman_Sewerage
    case Lootah_Gas
    // case MAWAQiF
    case Salik
    case Nol_Card
    case SEWA
}


struct UtilityPaymentViewModel {

    func getLimitData(type: UtilityPaymentType, response: @escaping (ResponseModel<LimitDataModel>?, _ error: Error?) -> Void) {
        
        var url = ""
        
        switch type {
        case .FEWA:
            url = ApiEnd().FEWA_LIMIT_URL
            break
        case .AADC:
            url = ApiEnd().AADC_LIMIT_URL
            break
        case .ADDC:
            url = ApiEnd().ADDC_LIMIT_URL
            break
        case .Ajman_Sewerage:
            url = ApiEnd().AJMAN_SEWERANGE_LIMIT_URL
            break
        case .Lootah_Gas:
            url = ApiEnd().LOOTAH_GAS_LIMIT_URL
            break
//        case .MAWAQiF:
//            //    url = ApiEnd().
//            break
        case .Salik:
            url = ApiEnd().SALIK_LIMIT_URL
            break
        case .Nol_Card:
            url = ApiEnd().NOL_CARD_LIMIT_URL
            break
        case .SEWA:
            url = ApiEnd().SEWA_LIMIT_URL
            break
        }
        
        WSManager.getRequest(url: url, resultType: ResponseModel<LimitDataModel>.self) { result, error in
            print(result)
            
            response(result, error)
        }
    }
    
}
