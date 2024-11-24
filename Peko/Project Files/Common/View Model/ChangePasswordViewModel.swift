//
//  ChangePasswordViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 30/03/23.
//

import UIKit

struct ChangePasswordViewModel {

    func changePassowrd(changePasswordRequest:ChangePasswordRequest, response: @escaping (CommonResponseModel?) -> Void) {
        
        let parameter: [String : Any] = [
            "id":objUserSession.user_id,
            "oldPassword":changePasswordRequest.oldPassword!,
            "newPassword":changePasswordRequest.newPassword!
        ]
        
        WSManager.patchRequest(url: ApiEnd().CHANGE_PASSWORD, param: parameter, resultType: CommonResponseModel.self) { result, error in
            response(result!)
        }
    }
}
