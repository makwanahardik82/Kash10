//
//  LoginResponse.swift
//  Peko
//
//  Created by Hardik Makwana on 04/01/23.
//

import UIKit

//struct LoginResponse : Codable {
//
//    let status: Bool?
//    let message:String?
//    let data: LoginModel?
//    enum CodingKeys: String, CodingKey {
//        case status = "success"
//        case message
//        case data
//    }
//    
//    
//}

struct LoginDataModel:Codable {
    let id: Int?
    let corporateId: Int?
    
    let username:String?
    let token:String?
    let refreshToken:String?
    let role:String?
    let roleName:String?
    let sessionId:String?
    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case username
//        case token
//        case role
//        case refreshToken
//    }
}

//struct LoginResponseData : Decodable
//{
//    let userName: String
//    let userID: Int
//    let email: String
//
//    enum CodingKeys: String, CodingKey {
//        case userName
//        case userID = "userId"
//        case email
//    }
//}

