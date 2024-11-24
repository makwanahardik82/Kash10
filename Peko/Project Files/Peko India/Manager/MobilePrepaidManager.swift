//
//  MobilePrepaidManager.swift
//  Peko India
//
//  Created by Hardik Makwana on 19/12/23.
//

import UIKit



var objMobilePrepaidManager:MobilePrepaidManager?

class MobilePrepaidManager: NSObject {
    
    static let sharedInstance = MobilePrepaidManager()
    
    var getPlanRequest:MobilePrepaidRequest?
    
    var postpaidBillDataModel:MobilePostpaidBillDataModel?
    
    var operatorLogoImage:UIImage?
    var BBPS_BillersArray = [BBPS_BillersModel]()
   
}
