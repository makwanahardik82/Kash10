//
//  ChangePasswordValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 30/03/23.
//

import UIKit


struct ChangePasswordValidation {

    func Validate(changePasswordRequest: ChangePasswordRequest) -> AppValidationResult
    {
        if(changePasswordRequest.oldPassword!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter current password")
        }
        if(changePasswordRequest.newPassword!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter new password")
        }
        if(changePasswordRequest.confirmPassword!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter confirm password")
        }
        
        if(changePasswordRequest.confirmPassword != changePasswordRequest.newPassword)
        {
            return AppValidationResult(success: false, error: "Please password and confirm password doesn’t match")
        } 
        return AppValidationResult(success: true, error: nil)
    }
}
