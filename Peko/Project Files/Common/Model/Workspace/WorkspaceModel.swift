//
//  WorkspaceModel.swift
//  Peko
//
//  Created by Hardik Makwana on 09/07/23.
//

import UIKit

struct WorkspaceModel:Codable {
    
    let id:Int?
    
    let name:String?
    let monthlyPrice:String?
    let yearlyPrice:String?
 
    let address:String?
    let latLng:String?
    let logo:String?
   
    let status:Bool?
   
    let updatedAt:String?
    let createdAt:String?
    let planId:Int?
    
}
struct WorkspaceUploadFileModel:Codable {
    
    let initialApprovalUrl:String?
    
}


struct WorkspacePaymentModel:Codable {
    
    let id:Int?
    
    let corporateFinalBalance:String?
    let corporateCashback:String?
    let datetime:String?
    
    let amount:CustomDouble?
    let corporateTxnId:CustomInt?
    
}
