//
//  UtilityBillsViewModel.swift
//  Peko India
//
//  Created by Hardik Makwana on 20/12/23.
//

import UIKit

struct UtilityBillsViewModel {
    
    // GET_BBPS_BILLERS_LIST
    func getBBPS_BillersList(categoryName:String, state:String, response: @escaping (ResponseModel<[BBPS_BillersModel]>?, _ error: Error?) -> Void) {
       
        let urlString = ApiEnd.GET_BBPS_BILLERS_LIST + "?categoryName=\(categoryName)&state=" + state.uppercased().prefix(3)
        print(urlString)
        WSManager.getRequest(url: urlString, resultType: ResponseModel<[BBPS_BillersModel]>.self) { result, error in
           // print(result)
            response(result, error)
        }
    }
    
    // MARK: - Get Electricity Bill
    func getUtilityBill(response: @escaping (ResponseModel<MobilePostpaidBillResponseModel>?, _ error: Error?) -> Void)  {
        
        let param = [
            "billerId":(objUtilityBillsManager!.bbpsBillerID ),
            "mobile":(objUtilityBillsManager!.consumerNumber )
        ]
        
        WSManager.postRequest(url: ApiEnd().GET_UTILITY_BILL, param: param, resultType: ResponseModel<MobilePostpaidBillResponseModel>.self) { result, error in
           // print(result)
            response(result, error)
        }
    }
    
    // MARK: - Payment Bill
    func paymentBill(amount:Double, response: @escaping (ResponseModel<MobilePostpaidBillPaymentModel>?, _ error: Error?) -> Void) {
        
        let accessKey = "bbps_utility_\(objUtilityBillsManager!.utilityBillType ?? "")"
        let param = [
            "mobile":objUtilityBillsManager!.consumerNumber ?? "",
            "accessKey":accessKey,
            "refId":objUtilityBillsManager!.billDataModel?.refId ?? "",
            "billerRefId":objUtilityBillsManager!.billDataModel?.billerRefId ?? "",
            "amount":amount
        ] as [String : Any]
        
        print(param)
        
        WSManager.postRequest(url: ApiEnd.MOBILE_POSTPAID_PAYMENT, param: param, resultType: ResponseModel<MobilePostpaidBillPaymentModel>.self) { result, error in
           // print(result)
            response(result, error)
        }
        
    }
    
    
    // MARK: -
    // MARK: -
    // MARK: -
    // MARK: - fetchBeneficiary
    func getBeneficiary(response: @escaping (ResponseModel<[BeneficiaryDataModel]>?, _ error: Error?) -> Void) {
        
        let accessKey = "bbps_utility_\(objUtilityBillsManager!.utilityBillType)"
        
        let urlString = ApiEnd.GET_BENEFICIARY + "?credentialId=\(objUserSession.user_id)&accessKey=\(accessKey)"
   
        print("\n\n\n URL => ", urlString)
        
        WSManager.getRequest(url: urlString, resultType: ResponseModel<[BeneficiaryDataModel]>.self) { result, error in
           // print(result)
            response(result, error)
        }
        
//        WSManager.getRequestJSON(urlString: urlString, withParameter: nil) { success, result in
//            print(result)
//        }
    }
    
    // MARK: - Add Brnrficiary
    func addBeneficiary(request:UtilityAddBeneficiaryRequest, billerID:String, paramName:String, otpString:String, response: @escaping (ResponseModel<BeneficiaryDataModel>?, _ error: Error?) -> Void) {
        
        let accessKey = "bbps_utility_\(objUtilityBillsManager!.utilityBillType)"
       // let name = "\(objUtilityBillsManager!.utilityBillType) Bill".capitalized
        
        
        let customerParams = [
            "paramName":paramName,
            "value":request.consumerNumber ?? ""
        ]
        
        let parameter = [
            "name":request.name ?? "",
            "phoneNo":"",
            "serviceProvider":request.serviceProvider ?? "",
            "providerCircle":request.state ?? "",
            "accessKey":accessKey,
            "isActive": "1",
            "credentialId": "\(objUserSession.user_id)",
            "otp":otpString,
            "scope":CommonConstants.OTP_SCOPE,
            "billerId":billerID,
            "customerParams":customerParams
            
        ] as [String : Any]
        print(parameter)
      
//        WSManager.postRequestJSON(urlString: ApiEnd.ADD_BENEFICIARY, withParameter: parameter) { success, result in
//            print(result)
//        }
        
        WSManager.postRequest(url: ApiEnd.ADD_BENEFICIARY, param: parameter, resultType: ResponseModel<BeneficiaryDataModel>.self) { result, error  in
            response(result!, error)

        }
        
    }
    // MARK: - Update Beneficiary
    func updateBeneficiary(b_id:Int, request:UtilityAddBeneficiaryRequest, billerID:String, paramName:String, otpString:String, response: @escaping (ResponseModel<[BeneficiaryDataModel]>) -> Void) {
       
//        let accessKey = "bbps_utility_\(objUtilityBillsManager!.utilityBillType)"
//        let name = "\(objUtilityBillsManager!.utilityBillType) Bill".capitalized
//        
        let accessKey = "bbps_utility_\(objUtilityBillsManager!.utilityBillType)"
       
        let customerParams = [
            "paramName":paramName,
            "value":request.consumerNumber ?? ""
        ]
        
        let parameter = [
            "name":request.name ?? "",
            "phoneNo":"",
            "serviceProvider":request.serviceProvider ?? "",
            "providerCircle":request.state ?? "",
            "accessKey":accessKey,
            "isActive": "1",
            "credentialId": "\(objUserSession.user_id)",
            "otp":otpString,
            "scope":CommonConstants.OTP_SCOPE,
            "billerId":billerID,
            "customerParams":customerParams
            
        ] as [String : Any]
     
       print(parameter)
        
        WSManager.putRequest(url: ApiEnd.ADD_BENEFICIARY + "\(b_id)", param: parameter, resultType: ResponseModel<[BeneficiaryDataModel]>.self) { result in
            print(result)
            response(result)
        }
        
//        WSManager.putRequestJSON(urlString: ApiEnd.ADD_BENEFICIARY + "\(b_id)", withParameter: parameter) { success, result in
//            print(result)
//        }
//
    }
    //MARK: - DELETE BENEFICIARY
    func deleteBeneficiary(beneficiary_id:String, response: @escaping (ResponseModel<BeneficiaryModel>?, _ error: Error?) -> Void) {
        
        WSManager.postRequest(url: ApiEnd.DELETE_BENEFICIARY + beneficiary_id, param: [:], resultType: ResponseModel<BeneficiaryModel>.self) { result, error  in
            response(result!, error)

        }
    }
}
