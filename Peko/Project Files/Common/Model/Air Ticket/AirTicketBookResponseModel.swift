//
//  AirTicketBookResponseModel.swift
//  Peko
//
//  Created by Hardik Makwana on 26/03/24.
//

import UIKit


struct AirTicketBookResponseModel: Codable {
    
    let conversationId:String?
 
    let meta:AncillariesMetaModel?
    let commonData:AncillariesCommonDataModel?
   
    let data:[AirTicketHistoryResponseModel]?
    
    let corporateFinalBalance:CustomDouble?
    let corporateCashback:CustomDouble?
    let orderId:CustomInt?
    let corporateTxnId:CustomInt?
    
    
}
