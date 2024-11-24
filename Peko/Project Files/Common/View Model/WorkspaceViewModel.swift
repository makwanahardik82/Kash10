//
//  WorkspaceViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 09/07/23.
//

import UIKit


struct WorkspaceViewModel {
    // MARK: -
    
    func getAllPlans(response: @escaping (ResponseModel<WorkspacePlanResponseDataModel>??, _ error: Error?) -> Void) {
        WSManager.getRequest(url: ApiEnd().WORKSPACE_GET_ALL_PLAN, resultType: ResponseModel<WorkspacePlanResponseDataModel>.self) { result, error in
          //  print(result)
            response(result, error)
        }
    }
    
    // MARK: -
//    func getWorkspace(response: @escaping (ResponseModel<[WorkspaceModel]>??, _ error: Error?) -> Void) {
//        WSManager.getRequest(url: ApiEnd.WORKSPACE_GET_ALL_WORKSPACES, resultType: ResponseModel<[WorkspaceModel]>.self) { result, error in
//          //  print(result)
//            response(result, error)
//        }
//    }
    // MARK: -
    func workspacePayment(amount:Double, response: @escaping (ResponseModel<WorkspacePaymentModel>??, _ error: Error?) -> Void){
      
        let url = ApiEnd().WORKSPACE_PAYMENT
        /*
        let file = [
            "ownerVisUrl":objOfficeAddressManager?.request?.ownerVisaBase64 ?? "",
            "tradeLicenseUrl":objOfficeAddressManager?.request?.tradeLicenseBase64 ?? ""
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let str = dateFormatter.string(from: objOfficeAddressManager?.request?.expiryDate ?? Date())
        let userDetail = [
            "companyName":objOfficeAddressManager?.request?.companyName ?? "",
            "expiryDate":str,
            "licenseType":objOfficeAddressManager?.request?.licenseType ?? "",
            "fileUploadData":file
        ] as [String : Any]
        let parameter = [
            "amount":amount,
            "planId":objOfficeAddressManager?.selectedPlanModel?.id ?? 0,
            "bookDetails": [],
            "userDetails":userDetail
        ] as [String : Any]
      */
        let parameter = self.getParametersForCreateNIOrder(amount: amount)
        print(parameter.toJSON())
        
        WSManager.postRequest(url: url, param: parameter, resultType: ResponseModel<WorkspacePaymentModel>?.self) { result, error in
            response(result, error)
        }
    }
    func getParametersForCreateNIOrder(amount:Double) -> [String:Any] {
        let file = [
            "ownerVisUrl":objOfficeAddressManager?.request?.ownerVisaBase64 ?? "",
            "tradeLicenseUrl":objOfficeAddressManager?.request?.tradeLicenseBase64 ?? ""
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let str = dateFormatter.string(from: objOfficeAddressManager?.request?.expiryDate ?? Date())
        let userDetail = [
            "companyName":objOfficeAddressManager?.request?.companyName ?? "",
            "expiryDate":str,
            "licenseType":objOfficeAddressManager?.request?.licenseType ?? "",
            "fileUploadData":file
        ] as [String : Any]
        let parameter = [
            "amount":amount,
            "planId":objOfficeAddressManager?.selectedPlanModel?.id ?? 0,
            "bookDetails": [],
            "userDetails":userDetail
        ] as [String : Any]
        
        return parameter
    }
    
    
    func uploadImage(base64:String, response: @escaping (ResponseModel<WorkspaceUploadFileModel>??, _ error: Error?) -> Void){
      
        let parameter = [
            "fileUploadData":[
                [
                    "file":"initialApproval",
                    "base64String":base64,
                    "imageFormat":"PNG"
                ]
            ]
        ]
        WSManager.postRequest(url: ApiEnd().WORKSPACE_UPLOAD_FILE, param: parameter, resultType: ResponseModel<WorkspaceUploadFileModel>?.self) { result, error in
            response(result, error)
        }
    }
}
