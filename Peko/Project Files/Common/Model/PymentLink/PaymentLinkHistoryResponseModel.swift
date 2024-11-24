//
//  PaymentLinkHistoryResponseModel.swift
//  Peko
//
//  Created by Hardik Makwana on 21/05/23.
//

import UIKit
import CodableFirebase

struct PaymentLinkHistoryResponseModel: Codable {
   
    var success:Bool?

    var recordsTotal:Int?
    var recordsFiltered:Int?
    
    var data:[PaymentLinkHistoryModel]?
}

struct PaymentLinkHistoryModel: Codable {
  
    var id:Int?
    var credentialId:Int?
    
    var sentPayload:String?
    var response:String?
    var createdAt:String?
    var updatedAt:String?
    
    var date:Date {
        get {
            return self.createdAt!.dateFromISO8601() ?? Date()
        }
    }
    
    var sentPayloadDictionary:[String:Any] {
        get {
            if let array = self.sentPayload?.toJSON() as? [String:Any] {
                return array
            }
            return [String:Any]()
        }
    }
    
    var responseDictionary:[String:Any] {
        get {
            if let array = self.response?.toJSON() as? [String:Any] {
                return array
            }
            return [String:Any]()
        }
    }
    var quickLinkRequestModel:QuickLinkRequestModel? {
        if let dic = self.sentPayloadDictionary["QuickLinkRequest"] as? [String:Any] {
            
            do {
                let model = try FirebaseDecoder().decode(QuickLinkRequestModel.self, from: dic)
                return model
            } catch let error {
                print(error)
            }
        }
        return nil
    }
}

struct QuickLinkRequestModel: Codable {
    
    var StoreID:CustomString?
    var Details:QuickLinkRequestDetailModel?
    
}
struct QuickLinkRequestDetailModel: Codable {
    
    var Cart:Int?
  
    var Currency:String?
    var Amount:CustomDouble?
    var MinQuantity:String?
    var MaxQuantity:String?
    
    var FullName:String?
    var Addr1:String?
    var City:String?
    var Country:String?
    var Email:String?
    var Phone:String?
    var Desc:String?
   
}

