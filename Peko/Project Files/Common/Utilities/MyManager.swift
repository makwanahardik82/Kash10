//
//  MyManager.swift
//  Peko
//
//  Created by Hardik Makwana on 03/01/23.
//

import UIKit
import DapiSDK

enum NavigateTo: Int {
    case Onboarding = 0
    case LoginVC
    case TabBarVC
    case ProfileVC
    case LogoutVC
    case FaceID
}

enum AppTarget: Int {
    case PekoUAE = 0
    case PekoIndia
}

let objShareManager = MyManager.sharedInstance


class MyManager: NSObject {
    static let sharedInstance = MyManager()
    var navigateToViewController:NavigateTo = NavigateTo(rawValue: 0)!
 
    
    func initializeDapiSDK (){
        
        let environment:DAPIEnvironment = is_live ? .production:.sandbox
      
        Dapi.shared.start(appKey: Constants().DAPI_SDK_APP_KEY,
                          environment: environment, //.sandbox or .production
                          clientUserID: "\(objUserSession.user_id)") { dapi, error in
            
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            print(dapi)
        
           // DAPIConfigurations
            let configurations  = DAPIConfigurations(countries: [.ae])
            print(configurations)
            configurations.showTransferSuccessfulResult = true
            configurations.showTransferSuccessfulResult = false
            configurations.endPointExtraBody = [.all: ["appSecret": Constants().DAPI_SDK_APP_SECRET]]
            configurations.endPointExtraHeaderFields = [.all: ["appSecret": Constants().DAPI_SDK_APP_SECRET]]
          
            Dapi.shared.configurations = configurations
        }
    }
    let dapiReceiverBeneficiary:DAPIBeneficiary = {
        
        let tmp = DAPIBeneficiary()
        
        tmp.name = "Current"
        tmp.nickname = "Current"
        tmp.iban = "DAPIBANKAEMSHRQB1663305937020827426807"
        tmp.accountNumber = "1663305937020827426807"
        tmp.swiftCode = "BOMLAEAD"
        
        tmp.country = "AE"
        tmp.branchAddress = "Dubai"
        tmp.branchName = "Wio Bank"
        tmp.linesAddress?.line1 = "Al Furjan"
        tmp.linesAddress?.line2 = "Dubai"
        tmp.linesAddress?.line3 = "United Arab Emirates"
        return tmp
    }()
    
    func getAppTarget() -> AppTarget {
        let bundleID = Bundle.main.bundleIdentifier
        
        if bundleID == "com.app.peko.payment" {
            return .PekoUAE
        }else if bundleID == "com.app.peko.india" {
            return .PekoIndia
        }
        return .PekoUAE
    }
    
    lazy var appTarget: AppTarget? = {
        let bundleID = Bundle.main.bundleIdentifier
        
        if bundleID == "com.app.peko.payment" {
            return .PekoUAE
        }else if bundleID == "com.app.peko.india" {
            return .PekoIndia
        }
        return .PekoUAE
    }()
}
