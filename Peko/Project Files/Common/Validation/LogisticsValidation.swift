//
//  LogisticsValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 13/09/23.
//

import UIKit


struct LogisticsValidation {
    
    func ValidateAddress(request: LogisticsAddressDetailModel) -> AppValidationResult
    {
        if objShareManager.appTarget == .PekoUAE {
            if(request.name!.isEmpty)
            {
                return AppValidationResult(success: false, error: "Please enter name")
            }
            if(request.country!.isEmpty)
            {
                return AppValidationResult(success: false, error: "Please select country")
            }
            if(request.city!.isEmpty)
            {
                return AppValidationResult(success: false, error: "Please select city")
            }
            if(request.buldingName!.isEmpty)
            {
                return AppValidationResult(success: false, error: "Please enter building name/number and street name")
            }
            if(request.addressLine1!.isEmpty)
            {
                return AppValidationResult(success: false, error: "Please enter address line 1")
            }
            if(request.email!.isEmpty)
            {
                return AppValidationResult(success: false, error: "Please enter email address")
            }
            if !(request.email?.isValidEmail ?? false) {
                return AppValidationResult(success: false, error: "Please enter valid email address")
            }
            if(request.mobileNumber!.isEmpty)
            {
                return AppValidationResult(success: false, error: "Please enter phone number")
            }
        }else{
            if(request.name!.isEmpty)
            {
                return AppValidationResult(success: false, error: "Please enter name")
            }
            if(request.email!.isEmpty)
            {
                return AppValidationResult(success: false, error: "Please enter email address")
            }
            if !(request.email?.isValidEmail ?? false) {
                return AppValidationResult(success: false, error: "Please enter valid email address")
            }
            if(request.mobileNumber!.isEmpty)
            {
                return AppValidationResult(success: false, error: "Please enter phone number")
            }
            if(request.buldingName!.isEmpty)
            {
                return AppValidationResult(success: false, error: "Please enter address")
            }
            
//            if objLogisticsManager?.senderAddress != nil {
//                if(request.address2.isEmpty)
//                {
//                    return AppValidationResult(success: false, error: "Please enter address 2")
//                }
//            }
            
            if(request.pinCode!.isEmpty)
            {
                return AppValidationResult(success: false, error: "Please enter pincode")
            }
            if(request.city!.isEmpty)
            {
                return AppValidationResult(success: false, error: "Please verify pincode")
            }
        }
        return AppValidationResult(success: true, error: nil)
    }
    
    
    func ValidateAddress(request: LogisticsShipmentDetailModel) -> AppValidationResult
    {
        if(request.content!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter shipment content")
        }
        if(request.noOfPieces!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter No. of pieces")
        }
       
        if(request.weight!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter total weight")
        }
        if(request.sheduleDate == nil)
        {
            return AppValidationResult(success: false, error: "Please schedule a pickup for this shipment")
        }
        if(request.serviceType!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter width")
        }
      
        return AppValidationResult(success: true, error: nil)
    }
    
}
