//
//  UtilityPaymentValidation.swift
//  Peko
//
//  Created by Hardik Makwana on 02/04/23.
//

import UIKit

struct UtilityPaymentValidation {

    func Validate(paymentRequest: UtilityPaymentRequest) -> AppValidationResult
    {
        if(paymentRequest.acoountNumber!.isEmpty)
        {
            return AppValidationResult(success: false, error: "Please enter your account number")
        }
        if objUtilityPaymentManager?.utilityPaymentType == .Salik || objUtilityPaymentManager?.utilityPaymentType == .Nol_Card {
            if(paymentRequest.amount!.isEmpty){
                return AppValidationResult(success: false, error: "Please enter amount")
            }
            
            let amount = Double(paymentRequest.amount ?? "0.0")
            let min = Double(objUtilityPaymentManager?.limitDataModel?.minDenomination ?? 0)
            let max = Double(objUtilityPaymentManager?.limitDataModel?.maxDenomination ?? 0)
            
            if(amount! < min || amount! > max)
            {
                return AppValidationResult(success: false, error: "Please enter an amount between min and max denominations")
            }
        }
        
        if objUtilityPaymentManager?.utilityPaymentType == .Salik {
            if(paymentRequest.pin!.isEmpty){
                return AppValidationResult(success: false, error: "Please enter your PIN")
            }
        }
        
        return AppValidationResult(success: true, error: nil)
    }
}
