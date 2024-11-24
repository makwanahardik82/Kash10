//
//  SignupValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 25/01/23.
//

import UIKit

struct SignupValidation {
    func Validate(signupRequest: SignUpRequest) -> AppValidationResult
    {
        if(signupRequest.first_name!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter full name")
        }
//        if(signupRequest.last_name!.isEmpty)
//        {
//            return AppValidationResult(success: false, error: "Please enter last name")
//        }
//        if(signupRequest.company_name!.isEmpty)
//        {
//            return AppValidationResult(success: false, error: "Please enter company name")
//        }
        if(signupRequest.email!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter email")
        }
        if !(signupRequest.email?.isValidEmail ?? false) {
            return AppValidationResult(success: false, error: "Please enter valid email")
        }
        if(signupRequest.mobile_number == "+\(signupRequest.country_code ?? "")")
        {
            return AppValidationResult(success: false, error: "Please enter mobile number")
        }
       
        if(signupRequest.password!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter password")
        }
         /*
        if(signupRequest.confirm_password!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter confirm password")
        }
        
        if(signupRequest.confirm_password != signupRequest.password)
        {
            return AppValidationResult(success: false, error: "Please password and confirm password doesn’t match")
        }
        */
        
       
       
      
        /*
        if(signupRequest.city!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select city")
        }
        if(signupRequest.sector!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select sector")
        }
        */
        return AppValidationResult(success: true, error: nil)
        
      //  var first_name, last_name, mobile_number, email, company_name, city, sector,
        
        // country_name, country_code,  op, designation: String?
        
        
        
    }
}
