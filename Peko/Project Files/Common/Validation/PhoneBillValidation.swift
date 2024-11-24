//
//  PhoneBillValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 28/01/23.
//

import UIKit

struct PhoneBillValidation {

    func Validate(billRequest: PhoneBillRequest) -> AppValidationResult
    {
      //  if objPhoneBillsManager?.phoneBillType == .DU_Prepaid || objPhoneBillsManager?.phoneBillType == .Etisalat_Prepaid ||
            
        if objPhoneBillsManager?.phoneBillType == .Etisalat_Postpaid {
            if(billRequest.service_type!.isEmpty)
            {
                return AppValidationResult(success: false, error: "Please select service type")
            }
        }
  
        if(billRequest.number!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter your number")
        }
        if !(billRequest.number?.isValidUAEMobileNumber ?? false) {
            return AppValidationResult(success: false, error: "Please enter valid number\n(Ex. 0-5X-XXXXXXX)")
        }
            
        if objPhoneBillsManager?.phoneBillType != .DU_Postpaid && objPhoneBillsManager?.phoneBillType != .Etisalat_Postpaid{
            if(billRequest.amount!.isEmpty)
            {
                return AppValidationResult(success: false, error: "Please enter amount")
            }
            
            let amount = Double(billRequest.amount ?? "0.0")
            let min = Double(objPhoneBillsManager?.limitDataModel?.minDenomination ?? 0)
            let max = Double(objPhoneBillsManager?.limitDataModel?.maxDenomination ?? 0)
            
            if(amount! < min || amount! > max)
            {
                return AppValidationResult(success: false, error: "Please enter an amount between min and max denominations")
            }
        }
        
        return AppValidationResult(success: true, error: nil)
    }
}
