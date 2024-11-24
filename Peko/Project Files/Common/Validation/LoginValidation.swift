//
//  LoginValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 04/01/23.
//

import UIKit


struct LoginValidation {

    func Validate(loginRequest: LoginRequest) -> AppValidationResult
    {
        if(loginRequest.email!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter account id / email")
        }
        if !(UITextField().numberValidation(number: loginRequest.email!)) {
            if !(loginRequest.email?.isValidEmail ?? false) {
                return AppValidationResult(success: false, error: "Please enter valid email")
            }
        }
        if(loginRequest.password!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter password")
        }
        return AppValidationResult(success: true, error: nil)
    }
}
