//
//  UtilityBillsManager.swift
//  Peko
//
//  Created by Hardik Makwana on 13/12/23.
//

import UIKit

var objUtilityBillsManager:UtilityBillsManager?

class UtilityBillsManager: NSObject {

    static let sharedInstance = UtilityBillsManager()
   
    var selectedUtilityBillType:UtilityBillsType?
    var selectedUtilityBillName:String?
    
//    var selectedBillerModel:BBPS_BillersModel?
    
    var serviceProvideName:String = ""
    var bbpsBillerID:String = ""
    var consumerNumber:String = ""
    var billDataModel:MobilePostpaidBillDataModel?
    
    var all_BBPS_BillersArray = [BBPS_BillersModel]()
   
    var utilityBillType:String {
        var type = ""
        
        switch objUtilityBillsManager!.selectedUtilityBillType {
        case .Electricity: // Electricity
            type = "electricity"
            break
        case .Broadband: // Broadband
            type = "broadband"
            break
        case .LPGCylinder: // LPG
            type = "lpg"
            break
        case .PipedGas: //
            type = "pipedGas"
            break
        case .Water: // WATER
            type = "water"
            break
        case .EducationFee: // EDUCATION
            type = "education"
            break
        case .Landline:
            type = "landline"
            break
        case .none:
            break
        }
        
        return type
    }
    
    
    
    
    
    
}
