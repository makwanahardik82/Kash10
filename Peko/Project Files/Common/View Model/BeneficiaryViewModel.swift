//
//  BeneficiaryViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 13/05/24.
//

import UIKit

struct BeneficiaryViewModel {
    func getLatestBeneficiary(response: @escaping (ResponseModel<BeneficiaryResponseDataModel>?, _ error: Error?) -> Void) {
        
        let url = ApiEnd().GET_LATEST_BENEFICIARY
        
        WSManager.getRequest(url: url, resultType: ResponseModel<BeneficiaryResponseDataModel>.self) { result, error in
            response(result, error)
        }
    }
    
}
