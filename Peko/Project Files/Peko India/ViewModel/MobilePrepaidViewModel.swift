//
//  MobilePrepaidViewModel.swift
//  Peko India
//
//  Created by Hardik Makwana on 19/12/23.
//

import UIKit

//class MobilePrepaidViewModel: NSObject {
//
//}
struct MobilePrepaidViewModel {

    // MARK: - Get Prepaid Plan
    func getPrepaidPlanDetails(response: @escaping (MobilePrepaidPlanResponseModel?, _ error: Error?) -> Void) {
        
        let param = [
            "serviceProvider":(objMobilePrepaidManager!.getPlanRequest!.serviceProvider ?? "").uppercased(),
            "location":(objMobilePrepaidManager!.getPlanRequest!.location ?? "").prefix(3).uppercased()
        ]
        
        WSManager.postRequest(url: ApiEnd.GET_MOBILE_PREPAID_PLANS, param: param, resultType: MobilePrepaidPlanResponseModel.self) { result, error in
            response(result, error)
        }
    }
    // MARK: - Prepaid Payment
    func prepaidRechargePayment(amount:Double, response: @escaping (ResponseModel<MobilePrepaidBillPaymentModel>?, _ error: Error?) -> Void) {
        
        let param = [
            "account":objMobilePrepaidManager?.getPlanRequest?.mobileNumber ?? "",
            "amount":amount,
            "payCashback":amount,
            "accessKey":"JRI_prepaid",
            "authKey":"4B38AB89-725D-4205-9751-6A397953C68C"
        ] as [String : Any]
        
        WSManager.postRequest(url: ApiEnd.MOBILE_PREPAID_PAYMENT, param: param, resultType: ResponseModel<MobilePrepaidBillPaymentModel>.self) { result, error in
            response(result, error)
        }
    }
    // MARK: -
    // MARK: - api/v1/bbps/billers?
    // GET_BBPS_BILLERS_LIST
    func getBBPS_BillersList(response: @escaping (ResponseModel<[BBPS_BillersModel]>?, _ error: Error?) -> Void) {
       
        let urlString = ApiEnd.GET_BBPS_BILLERS_LIST + "?categoryName=Mobile Postpaid" 
        print(urlString)
        WSManager.getRequest(url: urlString, resultType: ResponseModel<[BBPS_BillersModel]>.self) { result, error in
           // print(result)
            response(result, error)
        }
    }
    
    func getPostpaidBillDetails(response: @escaping (ResponseModel<MobilePostpaidBillResponseModel>?, _ error: Error?) -> Void) {
//        print(objMobilePrepaidManager?.getPlanRequest?.bbpsBillerID)
//        print(objMobilePrepaidManager?.getPlanRequest?.mobileNumber)
//        EXC_BAD_ACCESS
        let param = [
            "billerId":(objMobilePrepaidManager?.getPlanRequest?.bbpsBillerID ?? ""),
            "mobile":(objMobilePrepaidManager?.getPlanRequest?.mobileNumber ?? "")
        ]
        
        WSManager.postRequest(url: ApiEnd.GET_MOBILE_POSTPAID_BILL, param: param, resultType: ResponseModel<MobilePostpaidBillResponseModel>.self) { result, error in
            response(result, error)
        }
    }
    
    // MARK: - Postpaid Payment
    func postpaidRechargePayment(amount:Double, response: @escaping (ResponseModel<MobilePostpaidBillPaymentModel>?, _ error: Error?) -> Void) {
        
        let param = [
            "mobile":objMobilePrepaidManager?.getPlanRequest?.mobileNumber ?? "",
            "accessKey":"bbps_telecom_postpaid",
            "refId":objMobilePrepaidManager?.postpaidBillDataModel?.refId ?? "",
            "billerRefId":objMobilePrepaidManager?.postpaidBillDataModel?.billerRefId ?? "",
            "amount":amount
        ] as [String : Any]
        
        print(param)
        
        WSManager.postRequest(url: ApiEnd.MOBILE_POSTPAID_PAYMENT, param: param, resultType: ResponseModel<MobilePostpaidBillPaymentModel>.self) { result, error in
           // print(result)
            response(result, error)
        }
        /*
        WSManager.postRequestJSON(urlString: ApiEnd.MOBILE_POSTPAID_PAYMENT, withParameter: param) { success, result in
            print(result)
        }
         */
    }
    
    
    // MARK: -
    // MARK: - fetchBeneficiary
    func getBeneficiary(isPostpaid:Bool, response: @escaping (ResponseModel<[MobileBeneficiaryDataModel]>?, _ error: Error?) -> Void) {
        
        let accessKey = isPostpaid ? "bbps_telecom_postpaid":"JRI_prepaid"
        let urlString = ApiEnd.GET_BENEFICIARY + "?credentialId=\(objUserSession.user_id)&accessKey=\(accessKey)"
   
        print("\n\n\n URL => ", urlString)
        
        WSManager.getRequest(url: urlString, resultType: ResponseModel<[MobileBeneficiaryDataModel]>.self) { result, error in
           // print(result)
            response(result, error)
        }
        
    }
    
    // MARK: -
    func addBeneficiary(request:MobileAddBeneficiaryRequest, isPostpaid:Bool, otpString:String, response: @escaping (ResponseModel<MobileBeneficiaryDataModel>?, _ error: Error?) -> Void) {
        let accessKey = isPostpaid ? "bbps_telecom_postpaid":"JRI_prepaid"
        let parameter = [
            "name":request.name!,
            "phoneNo":request.mobileNumber!,
            "serviceProvider":request.serviceProvider ?? "",
            "providerCircle":"",
            "accessKey":accessKey,
            "isActive": "1",
            "credentialId": "\(objUserSession.user_id)",
            "otp":otpString,
            "scope":CommonConstants.OTP_SCOPE
        ]
        print(parameter)
      
        WSManager.postRequest(url: ApiEnd.ADD_BENEFICIARY, param: parameter, resultType: ResponseModel<MobileBeneficiaryDataModel>.self) { result, error  in
            response(result!,error)

        }
        
    }
    // MARK: - Update Beneficiary
    func updateBeneficiary(b_id:Int, request:MobileAddBeneficiaryRequest, isPostpaid:Bool, otpString:String, isActive:Bool, response: @escaping (ResponseModel<[BeneficiaryDataModel]>) -> Void) {
       
        let accessKey = isPostpaid ? "bbps_telecom_postpaid":"JRI_prepaid"
     
        let parameter:[String:Any] = [
            "name":request.name!,
            "phoneNo":request.mobileNumber!,
            "serviceProvider":request.serviceProvider ?? "",
            "providerCircle":"",
            "accessKey":accessKey,
            "isActive": isActive,
            "credentialId": objUserSession.user_id,
            "otp":otpString,
            "scope":CommonConstants.OTP_SCOPE
        ]
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
