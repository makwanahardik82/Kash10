//
//  TransactionsViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 30/03/23.
//

import UIKit

struct TransactionsViewModel {

    func getTransactionsDetails(fromDate:Date, toDate:Date, categoryName:String, searchText:String, sort:String = "DESC", filter:String = "SUCCESS", offset:Int, limit:Int = 10, response: @escaping (ResponseModel<TransactionResponseModel>?, _ error: Error?) -> Void) {
      
        let url = ApiEnd().GET_TRANSACTION + "?from=\(fromDate.formate()) 00:00:00&to=\(toDate.formate()) 23:59:59&categoryName=\(categoryName)&searchText=\(searchText)&sort=\(sort)&page=\(offset)&itemsPerPage=\(limit)&filter=\(filter)"
      
        WSManager.getRequest(url: url, resultType: ResponseModel<TransactionResponseModel>.self) { result, error in
            response(result, error)
        }
    }
}
