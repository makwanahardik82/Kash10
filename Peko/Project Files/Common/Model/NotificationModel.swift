//
//  NotificationModel.swift
//  Peko
//
//  Created by Hardik Makwana on 16/03/24.
//

import UIKit


struct NotificationResponseDataModel: Codable {
   
    let count:Int?
    let data:[NotificationModel]?
      
}
struct NotificationModel: Codable {
    
    let id:Int?
    
    let notificationTitle:String?
    let notificationBrief:String?
    let notificationCategory:String?
    
    let notificationTo:String?
    let notificationBy:String?
    
    let flag:Bool?
    
    let createdAt:String?
    let updatedAt:String?
    
    let scheduleDate:String?
    
}
