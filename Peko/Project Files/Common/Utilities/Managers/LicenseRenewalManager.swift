//
//  LicenseRenewalManager.swift
//  Peko
//
//  Created by Hardik Makwana on 09/05/23.
//

import UIKit

var objLicenseRenewalManager:LicenseRenewalManager?

class LicenseRenewalManager: NSObject {

    static let sharedInstance = LicenseRenewalManager()
   
    var limitDataModel:LimitDataModel?
    var balanceDataModel:LicenseBalanceModel?
  
    var customerName:String?
    var emiratesID:String?
    
    
    var paymentModel:LicensePaymentResponseModel?
}
