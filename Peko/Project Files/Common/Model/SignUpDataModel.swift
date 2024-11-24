//
//  SignUpDataModel.swift
//  Peko
//
//  Created by Hardik Makwana on 23/01/23.
//

import UIKit

struct SignUpDataModel: Codable {
    let id: Int?
    let status:String?
    let firstName:String?
    let lastName:String?
    let name:String?
    let designation:String?
    let country:String?
    let countryCode:String?
    let mobileNo:String?
    let email:String?
    let city:String?
    let username:String?
    let address:String?
    let updatedAt:String?
    let createdAt:String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case status
        case firstName
        case lastName
        case name
        case designation
        case country
        case countryCode
        case mobileNo
        case email
        case city
        case username
        case address
        case updatedAt
        case createdAt
    }
  
}
