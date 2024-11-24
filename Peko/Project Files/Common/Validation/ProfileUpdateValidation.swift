//
//  ProfileUpdateValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 09/04/23.
//

import UIKit

struct ProfileUpdateValidation {
    func Validate(profileRequest: ProfileRequest) -> AppValidationResult
    {
      
        
        if(profileRequest.name!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter full name")
        }
        if(profileRequest.dob!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select DOB")
        }
        if(profileRequest.gender!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select gender")
        }
//        if(profileRequest.lastName!.isEmpty)
//        {
//            return AppValidationResult(success: false, error: "Please enter last name")
//        }
        /*
        if(profileRequest.mobileNo!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter phone number")
        }
        if(profileRequest.email!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter email")
        }
        if !(profileRequest.email?.isValidEmail ?? false) {
            return AppValidationResult(success: false, error: "Please enter valid email")
        }
        if(profileRequest.designation!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter designation name")
        }
        if objShareManager.appTarget == .PekoUAE {
            if(profileRequest.emirates!.isEmpty)
            {
                return AppValidationResult(success: false, error: "Please enter emirates")
            }
            if(profileRequest.emirates!.count != 15)
            {
                return AppValidationResult(success: false, error: "Please enter valid emirates, it must be 15 digits")
            }
        }
        
        if(profileRequest.companySize!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select company size")
        }
        if(profileRequest.landlineNo!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter landline number")
        }
        if(profileRequest.activity!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter activity")
        }
        if(profileRequest.tradeLicenseNo!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter trade license number")
        }
        if(profileRequest.issuingAuthority!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter trade license authority")
        }
        if(profileRequest.trnNo!.isEmpty)
        {            return AppValidationResult(success: false, error: "Please enter TRN number")
        }
         */

        return AppValidationResult(success: true, error: nil)
    }
}
/*
 struct SignupValidation {
     func Validate(profileRequest: profileRequest) -> AppValidationResult
     {
         if(profileRequest.first_name!.isEmpty)
         {
             return AppValidationResult(success: false, error: "Please enter first name")
         }
         if(profileRequest.last_name!.isEmpty)
         {
             return AppValidationResult(success: false, error: "Please enter last name")
         }
         if(profileRequest.mobile_number!.isEmpty)
         {
             return AppValidationResult(success: false, error: "Please enter mobile number")
         }
         if(profileRequest.email!.isEmpty)
         {
             return AppValidationResult(success: false, error: "Please enter email")
         }
         if !(profileRequest.email?.isValidEmail ?? false) {
             return AppValidationResult(success: false, error: "Please enter valid email")
         }
         if(profileRequest.company_name!.isEmpty)
         {
             return AppValidationResult(success: false, error: "Please company name")
         }
         if(profileRequest.city!.isEmpty)
         {
             return AppValidationResult(success: false, error: "Please select city")
         }
         if(profileRequest.sector!.isEmpty)
         {
             return AppValidationResult(success: false, error: "Please select sector")
         }
         return AppValidationResult(success: true, error: nil)
         
       //  var first_name, last_name, mobile_number, email, company_name, city, sector,
         
         // country_name, country_code,  op, designation: String?
         
         
         
     }
 }
 
 */
