//
//  WorkspacePlanModel.swift
//  Peko
//
//  Created by Hardik Makwana on 09/07/23.
//

import UIKit

struct WorkspacePlanResponseDataModel:Codable {
    let data:[WorkspacePlanModel]?
}
struct WorkspacePlanModel:Codable {
    
    let id:Int?
    
    let name:String?
    let price:String?
    
    let billingCycle:String?
    
    let description:String?
    let highlights:String?
    let logo:String?
   
    let status:Bool?
   
    let updatedAt:String?
    let createdAt:String?

}


