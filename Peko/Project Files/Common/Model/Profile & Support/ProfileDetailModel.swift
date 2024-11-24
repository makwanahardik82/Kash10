//
//  ProfileDetailModel.swift
//  Peko
//
//  Created by Hardik Makwana on 15/03/23.
//

import UIKit

struct ProfileDetailModel: Codable {

    
    let name:String?
    let mobileNo:String?
    let city:String?
    let designation:String?
  
    let email:String?
    let country:String?
    let companyName:String?
    let companySize:String?
 
    let landlineNo:String?
   
    let dob:String? //  "dob": "1990-12-09",
    let gender:String?
  
    let logo:String?
   
    var dateDOB:Date {
        get {
            return self.dob?.toDate(format: "yyyy-MM-dd") ?? Date()
        }
    }
    
    
    /*
    let id:Int?
    let firstName:String?
    let lastName:String?
  
    let website:String?
   
    let sector:String?
    let countryCode:String?
    let poBox:String?

    let contactPersonName:String?
    let contactPersonEmail:String?
    let contactPersonPhone:String?
  
    let activity:String?
    
    let tradeLicenseNo:String?
    let tradeLicenseExpiry:String?
    let tradeLicenseDoc:String?
    
    let trnCertificate:String?
    let trnNo:String?
//    let trnExpiry:

    let eidDoc:String?
    
    let issuingAuthority:String?
  
    let kycRemarks:String?
    let kycStatus:String?
    let isActive:Int?
   
    let latLng:String?
   
    let totpSecret:String?
    */
    let registeredBy:String?
    let isMFA:Int?
    let sendMfaCodeToEmail:Int?
    let sendMfaCodeToPhone:Int?
    let sendMfaCodeToAuthApp:Int?
    
   
    
//    "name": "Peko",
//            "mobileNo": "0504930554",
//            "city": "Dubai",
//            "designation": "CTO",
//            "email": "sanan@ared.ai",
//            "country": null,
//            "companyName": "Savoll FZ LLC",
//            "companySize": "1-10",
//            "landlineNo": "",
          //  "logo": null,
//            "gender": "MALE",
//            "dob": "1990-12-09",
//            "package": {
//                "packageName": "Basic"
//            },
//            "credential": {
//                "username": "100000001"
//            }
    
    
   // referralCode
//    "backupCodes": [],
//    "eidDoc": null,
    
  
  
    

    let createdAt:String?
    let updatedAt:String?
  
    let credentialId:Int?
    let packageId:Int?
//    
    let package:PackageModel?
    let credential:CredentialModel?
}

// MARK: -
class CredentialModel: Codable {
    
    let id:Int?
    let role:String?
    let name:String?
    let email:String?
    let password:String?
    let passwordResetToken:String?
    let passwordResetExpires:String?
    
    let lastLogin:String?
    let createdAt:String?
    let updatedAt:String?
    
}

// MARK: -
struct ProfileUpdateResponseModel: Codable {
    
    let result:[CustomString]?
   // let docs:[String:String]?
    
    
}


class ProfileWalletModel: Codable {
    
    let balance:CustomDouble?
    let credentialId:CustomInt?
 
    
    let roleName:String?
    
    let logo:String?
   
    let contactPersonName:String?
   
    let email:String?
    let mobileNo:String?
    
    let lastLogin:String?
    let createdAt:String?
    let updatedAt:String?
    
}
/*
"balance": "9705357.0050",
       "credentialId": 22,
       "credential.role": "CORPORATE",
       "credential.username": "100000001",
       "": "corporate",
       "productTour": {
           "payroll": false,
           "dashboard": false
       },
       "": "https://firebasestorage.googleapis.com/v0/b/peko-storage.appspot.com/o/profile%2Fimages%2F1710151139554.png?alt=media&token=27fb3e0f-6249-4447-8d54-5b9c28287a1f",
       "": "",
       "": "asif@peko.one",
       "": "0504930554",
       "credential.companyName": "Savoll FZ LLC"
*/
//
//{
//        "result": "https://firebasestorage.googleapis.com/v0/b/peko-storage.appspot.com/o/profile%2Fimages%2F1710151139554.png?alt=media&token=27fb3e0f-6249-4447-8d54-5b9c28287a1f",
//        "docs": {
//            "logo": "https://firebasestorage.googleapis.com/v0/b/peko-storage.appspot.com/o/profile%2Fimages%2F1710151139554.png?alt=media&token=27fb3e0f-6249-4447-8d54-5b9c28287a1f",
//            "tradeLicenseDoc": "https://firebasestorage.googleapis.com/v0/b/peko-storage.appspot.com/o/profile%2Fimages%2F1710151148885.png?alt=media&token=673388f3-ccff-4660-9ea5-32bc87a3e2e7",
//            "trnCertificate": "https://firebasestorage.googleapis.com/v0/b/peko-storage.appspot.com/o/profile%2Fimages%2F1710151151634.png?alt=media&token=34e56408-11f7-47b0-ae4f-9270db1174a0"
//        }

