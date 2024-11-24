//
//  PekoStoreTrolleyViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 19/05/23.
//

import UIKit

struct PekoStoreTrolleyViewModel {
    
    // MARK: - fetchBeneficiary
    func getCartDetails(response: @escaping (ResponseModel<PekoStoreCartDetailModel>?, _ error: Error?) -> Void) {
       
        let url = ApiEnd().PEKO_STORE_GET_CART_DETAILS_URL
  
        WSManager.getRequest(url: url, resultType: ResponseModel<PekoStoreCartDetailModel>.self) { result, error in
         //   print(result)
            response(result, error)
            
        }
    }
}
