//
//  PekoStoreHistoryViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 13/03/24.
//

import UIKit

struct PekoStoreHistoryViewModel {
   
    func getHisoryList(fromDate:Date, toDate:Date, sort:String = "DESC", searchText:String, offset:Int, limit:Int = 10, response: @escaping (ResponseModel<PekoStoreOrderListResponseModel>?, _ error: Error?) -> Void) {
        
        let url = ApiEnd().PEKO_STORE_HISTORY_URL + "?from=\(fromDate.formate()) 00:00:00&to=\(toDate.formate()) 23:59:59&sort=\(sort)&searchText=\(searchText)&page=\(offset)&itemsPerPage=\(limit)"
       
        WSManager.getRequest(url: url, resultType: ResponseModel<PekoStoreOrderListResponseModel>.self) { result, error in
            response(result, error)
        }
    }
    
    // MARK: -
    func getOrderDetail(o_id:Int, response: @escaping (ResponseModel<PekoStoreOrderDetailModel>?, _ error: Error?) -> Void) {
        
        let url = ApiEnd().PEKO_STORE_HISTORY_DETAIL_URL + "\(o_id)"
       
        WSManager.getRequest(url: url, resultType: ResponseModel<PekoStoreOrderDetailModel>.self) { result, error in
            response(result, error)
        }
    }
    
}
