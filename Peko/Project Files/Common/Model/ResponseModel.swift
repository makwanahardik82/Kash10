//
//  ResponseModel.swift
//  Peko
//
//  Created by Hardik Makwana on 19/01/23.
//

import UIKit
import NISdk
//struct ResponseModel: <T>: Codable where T: Codable


//struct ResponseModel<T>: Codable where T: Codable {
struct ResponseModel<T>: Codable where T: Codable {
    
    let status: Bool?
    let success:Bool?
    let message:String?
    let error:String?
    let responseCode:String?
    
    var data: T?
    enum CodingKeys: String, CodingKey {
        case status // = "success"
        case success
        case message
        case data
        case error
        case responseCode
    }
    init() {
        self.status = false
        self.success = false
        self.message = "error_generic" //.localized
        self.data = nil
        self.error = ""
        self.responseCode = ""
    }
//    init(err: String) {
//        self.message = err
//        self.error = err
//        self.status = false
//      }
}

struct CommonResponseModel:Codable {
    
    let responseCode:String?
    let responseMessage:String?
    let success: Bool?
    let status: Bool?
    let message:String?
    let error:String?
    
}

struct NIOrderResponseDataModel:Codable {
    
    let data:OrderResponse?
    let paymentRefId:String?
    
}





struct LicensePaymentResponseModel:Codable {
   
    let errorcode:String?
    let errordesc:String?
    
    let datetime: String?
    let paidAmountInAed: Double?
    let paidAmount: CustomString?
    let orderId: CustomInt?
    
    let couponDetails:[CouponDetails]?
    
    let corporateTxnId:CustomInt?
    let corporateCashback:String?
    let corporateFinalBalance:String?
    
    let amount: CustomDouble?

    var date:Date {
        get {
            return self.datetime!.dateFromISO8601() ?? Date()
        }
    }
    
}

struct OTPResponseModel:Codable {
   
    let success:Bool?
    let message:String?
    let emailOtp:String?
    let phoneOtp:String?
}

/*
 
 
 // MARK: - ResArr
 struct ResponseData: Codable {
 var loginData:String
 
 init(from decoder: Decoder) throws {
 let container = try decoder.singleValueContainer()
 if let x = try? decoder.decode(LoginResponseData.self) {
 self.loginData = //String(format: "%d", x) // "\(x)" //.double(x)
 return
 }
 //        if let x = try? container.decode(String.self) {
 //            self.value = x //Int(x) ?? 0//.string(x)
 //            return
 //        }
 throw DecodingError.typeMismatch(TotalSavings.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for TransactionID"))
 }
 }
 class LoginResponseData: NSObject {
 let id: Int?
 let username:String?
 let token:String?
 let role:String?
 
 enum CodingKeys: String, CodingKey {
 case id
 case username
 case token
 case role
 }
 }
 */
/*
 {
 "status": true,
 "message": [
 "Login successful"
 ],
 "data": {
 "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IjEwMDAwMDAwMDQiLCJyb2xlIjoiQ09SUE9SQVRFIiwidXNlcklkIjoxMywidHlwZSI6InRva2VuIiwiaWF0IjoxNjczMjgwNzM0LCJleHAiOjE2Nzg0NjQ3MzQsImF1ZCI6Imh0dHBzOi8vcGVrby53b3JrIiwiaXNzIjoicGVrbyIsInN1YiI6ImluZm9AcGVrby53b3JrIn0.HPPTZjh9WiHp206q0a_r5c8x_lU8fmbXr7ZQwrkOcVY",
 "role": "CORPORATE",
 "id": 13,
 "username": "1000000004"
 }
 }
 */



