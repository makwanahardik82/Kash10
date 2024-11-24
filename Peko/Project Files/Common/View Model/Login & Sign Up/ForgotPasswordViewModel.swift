//
//  ForgotPasswordViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 26/08/23.
//

import UIKit

struct ForgotPasswordViewModel {
    func forgotPassword(username: String, response: @escaping (CommonResponseModel?, _ error: Error?) -> Void) {
        let parameter = [
            "username":username
        ]
        
        WSManager.postRequest(url: ApiEnd().FORGOT_PASSWORD_URL, param: parameter, resultType: CommonResponseModel.self) { result, error  in
            response(result!, error)
        }
    
//        
//        WSManager.postRequestJSON(urlString: ApiEnd.FORGOT_PASSWORD_URL, withParameter: parameter) { success, result in
//            print(result)
//        }
    }
}
