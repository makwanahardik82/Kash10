//
//  SupportRaiseTicketValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 29/03/24.
//

import UIKit



struct SupportRaiseTicketValidation {
    
    func Validate(request: SupportRaiseTicketRequest) -> AppValidationResult
    {
        if(request.issueType!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select issue type")
        }
        if(request.module!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please select module")
        }
        
        if !request.isEdit! {
            if(request.imageBase64String!.isEmpty)
            {
                return AppValidationResult(success: false, error: "Please select screenshot")
            }
        }
       
        if(request.description!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter description")
        }
        return AppValidationResult(success: true, error: nil)
    }
}
