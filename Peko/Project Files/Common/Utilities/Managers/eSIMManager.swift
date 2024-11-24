//
//  eSIMManager.swift
//  Peko
//
//  Created by Hardik Makwana on 15/04/24.
//

import UIKit

var objeSIMManager:eSIMManager?

class eSIMManager: NSObject {
    
    static let sharedInstance = eSIMManager()
   
    var selectedPackage:ESimPackageModel?
    var selectedeSimPackage:ESimPackageOperatorPakageModel?
    
    var otherSimPackagesArray = [ESimPackageOperatorPakageModel]()
  //  var usdToAed:Double = 0.0
    
    var paymentResponseModel:ESimPaymentResponseDataModel?
//    private var selectedOperator:ESimPackageOperatorModel?
//    private var selectedTopUpArray:[ESimPackageOperatorPakageModel]?

}
