//
//  SupportTicketModel.swift
//  Peko
//
//  Created by Hardik Makwana on 12/03/24.
//

import UIKit


struct SupportTicketResponseDataModel:Codable {
    
    let data:[SupportTicketModel]?
    let recordsTotal:Int?
}
struct SupportTicketModel:Codable {
    let id:Int?
    
    let issueType:String?
    let module:String?
    let description:String?
    let screenshotImage:String?
    let status:String?
   
    let createdAt:String?
    let updatedAt:String?
    
    let corporateUserId:CustomInt?
    
    let chats:[SupportTicketChatModel]?
    
}
struct SupportTicketChatModel:Codable {
    
    let date:String?
    let name:String?
    let admin:Bool?
    let message:String?
 
    lazy var fullDate:Date = self.date!.dateFromISO8601() ?? Date()
    
  //  lazy var dateString = self.fullDate.mediumDate
    lazy var timeString = self.fullDate.formate(format: "hh:mm a")
    
    var dateString:String {
        mutating get {
            return self.fullDate.mediumDate
        }
    }
    
}


struct SupportTicketGeneralOptionsResponseModel:Codable {
    
    var modules:[SupportTicketRaiseOptionsModel]?
    var issueType:[SupportTicketRaiseOptionsModel]?
}
struct SupportTicketRaiseOptionsModel:Codable {
    
    let value:String?
    let label:String?
    
}


