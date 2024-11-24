//
//  PekoConnectValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 23/05/23.
//

import UIKit

struct PekoConnectValidation {

    func Validate(request: PekoConnectRequest) -> AppValidationResult
    {
        if(request.name!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter name")
        }
        if(request.phoneNumber!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter phone number")
        }
        if(request.email!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter email")
        }
        if !(request.email?.isValidEmail ?? false) {
            return AppValidationResult(success: false, error: "Please enter valid email")
        }
        if(request.preferredMode!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select Preferred Mode")
        }
        if(request.requirement!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter requirement")
        }
        if(request.note!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter description")
        }
        return AppValidationResult(success: true, error: nil)
    }
}
