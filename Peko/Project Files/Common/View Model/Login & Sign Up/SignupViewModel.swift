//
//  SignupViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 25/01/23.
//

import UIKit

struct SignupViewModel {
    
    func userSignup(signupRequest: SignUpRequest, phoneOtp:String, emailOtp:String, response: @escaping (ResponseModel<SignUpDataModel>?, _ error: Error?) -> Void) {
       
        
        let mobileNumber = signupRequest.mobile_number?.replacingOccurrences(of: objUserSession.mobileCountryCode, with: "")
        
        let parameter:[String:Any] = [
            "name":signupRequest.first_name!,
            "countryCode":signupRequest.country_code!.replacingOccurrences(of: "+", with: ""),
            "mobileNo":mobileNumber ?? "",
            "email":signupRequest.email!,
            "password":signupRequest.password!,
            "phoneOtp":phoneOtp,
            "scope": Constants.OTP_SCOPE,
        ]
     
        
//        name":"company Name",
//        "countryCode":"971",
//        "mobileNo": "+5611455443",
//        "email": "jypifo4@tutupp.bid",
//        "contactPersonName":"person name",
//        "password":"Admin@123"
        
        
        print("\n\n\nGENERATE OTP => ", parameter.toJSON())
    
        WSManager.postRequest(url: ApiEnd().REGISTER_URL, param: parameter, resultType: ResponseModel<SignUpDataModel>.self) { result, error  in
            response(result!, error)
        }
    }
}
