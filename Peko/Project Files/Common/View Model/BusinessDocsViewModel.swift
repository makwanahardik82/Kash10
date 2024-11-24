//
//  BusinessDocsViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 10/10/23.
//

import UIKit


struct BusinessDocsViewModel {
    
    func getAllCategory(response: @escaping (ResponseModel<BusinessDocsCategoryResponseDataModel>??, _ error: Error?) -> Void) {
        WSManager.getRequest(url: ApiEnd().BUSINESS_GET_CATEGORIES, resultType: ResponseModel<BusinessDocsCategoryResponseDataModel>.self) { result, error in
            //  print(result)
            response(result, error)
        }
    }
    
    // MARK: -
    func getDocument(categoryName:String, response: @escaping (ResponseModel<BusinessDocsDocumentResponseDataModel>??, _ error: Error?) -> Void) {
        
        let urlString = ApiEnd().BUSINESS_GET_DOCUMENT + "?" + "categoryName=\(categoryName)"
        
        WSManager.getRequest(url: urlString, resultType: ResponseModel<BusinessDocsDocumentResponseDataModel>.self) { result, error in
            //  print(result)
            response(result, error)
        }
    }
}
