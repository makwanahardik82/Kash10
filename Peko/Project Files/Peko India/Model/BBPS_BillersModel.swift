//
//  BBPS_BillersModel.swift
//  Peko India
//
//  Created by Hardik Makwana on 19/12/23.
//

import UIKit

struct BBPS_BillersModel:Codable {
    
    let categoryName:String?
    let coverage:String?
    
    let fetchApiType:String?
    let id:String?
    
    let name:String?
    let customerParams:[BBPS_BillersCustomerParams]?
    
    let payWithoutFetchAllowed:Bool?
    let supportsPendingStatus:Bool?
    
}
struct BBPS_BillersCustomerParams:Codable {
    let dataType:String?
    let paramName:String?
   
    let maxLength:CustomInt?
    let minLength:CustomInt?
   
    let optional:Bool?
    let visibility:Bool?
   
    let categoryName:String?
    let coverage:String?
   
}

//    :    NUMERIC
//    :    10
//    :    10
//    :    false
//    :    Mobile Number
//regex    :    null
//values    :    null
//    :    true

