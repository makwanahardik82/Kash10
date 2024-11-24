//
//  LoginViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 04/01/23.
//

import UIKit

struct LoginViewModel {
    
    func userLogin(loginRequest: LoginRequest, response: @escaping (ResponseModel<LoginDataModel>?, _ error: Error?) -> Void) {
        let parameter = [
            "username":loginRequest.email!,
            "password":loginRequest.password!
        ]
      //  parameter.toJSON()
        WSManager.postRequest(url: ApiEnd().LOGIN_URL, param: parameter, resultType: ResponseModel<LoginDataModel>.self) { result, error  in
            response(result, error)
        }
    }
    func logout(response: @escaping (CommonResponseModel?, _ error: Error?) -> Void) {
        
        WSManager.postRequest(url: ApiEnd().LOGOUT_URL, param: [:], resultType: CommonResponseModel.self) { result, error  in
            response(result, error)
        }
    }
}
