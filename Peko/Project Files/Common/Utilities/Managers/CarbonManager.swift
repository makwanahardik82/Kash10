//
//  CarbonManager.swift
//  Peko
//
//  Created by Hardik Makwana on 23/03/24.
//

import UIKit

var objCarbonManager:CarbonManager?

class CarbonManager: NSObject {
    
    static let sharedInstance = CarbonManager()
   
    var selectedProjectModel:CarbonProjectModel?
   // var co2FootPrint:Double = 0.0
    
    var co2Tons:Double = 0.0
    var co2AmountInAED:Double = 0.0
    var co2AmountInUSD:Double = 0.0
    var selectedPackageModel:CarbonProjectPackagesModel?
    
    
    var paymentResponseModel:CarbonPaymentResponseModel?
}
