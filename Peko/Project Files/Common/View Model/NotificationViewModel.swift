//
//  NotificationViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 16/03/24.
//

import UIKit

struct NotificationViewModel {
    func getAllNotifications(response: @escaping (ResponseModel<NotificationResponseDataModel>?, _ error: Error?) -> Void) {
      
        let url = ApiEnd().GET_ALL_NOTIFICATION
       
        WSManager.getRequest(url: url, resultType: ResponseModel<NotificationResponseDataModel>.self) { result, error in
            response(result, error)
        }
    }
}


