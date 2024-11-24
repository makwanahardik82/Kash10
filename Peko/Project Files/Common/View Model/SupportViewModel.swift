//
//  SupportViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 12/03/24.
//

import UIKit

struct SupportViewModel {
    
    func getFAQ(response: @escaping (_ response:[String:Any]?, _ error: Bool?) -> Void) {
        let url = ApiEnd.GET_FAQ_SUPPORT
        WSManager.getRequestJSON(urlString: url, withParameter: nil) { success, result in
            response(result, success)
        }
    }
  
 // MARK: -
    func getTickets(fromDate:Date, toDate:Date, moduleName:String, searchText:String, offset:Int = 1, limit:Int = 10, response: @escaping (ResponseModel<SupportTicketResponseDataModel>?, _ error: Error?) -> Void) {
      
        let url = ApiEnd().GET_TICKETS_LIST + "?from=\(fromDate.formate()) 00:00:00&to=\(toDate.formate()) 23:59:59&module=\(moduleName)&searchText=\(searchText)&page=\(offset)&itemsPerPage=\(limit)"
       
        WSManager.getRequest(url: url, resultType: ResponseModel<SupportTicketResponseDataModel>.self) { result, error in
            response(result, error)
        }
    }
    func getTicketsDetails(t_id:Int, response: @escaping (ResponseModel<SupportTicketModel>?, _ error: Error?) -> Void) {
      
        let url = ApiEnd().GET_TICKETS_DETAIL + "\(t_id)"
       
        WSManager.getRequest(url: url, resultType: ResponseModel<SupportTicketModel>.self) { result, error in
            response(result, error)
        }
    }
    
    
    func getIssueTyoe(response: @escaping (ResponseModel<SupportTicketGeneralOptionsResponseModel>?, _ error: Error?) -> Void) {
      
        let url = ApiEnd.GET_ISSUE_TYPE
        WSManager.getRequest(url: url, resultType: ResponseModel<SupportTicketGeneralOptionsResponseModel>.self) { result, error in
            response(result, error)
        }
    }
    func getModules(response: @escaping (ResponseModel<SupportTicketGeneralOptionsResponseModel>?, _ error: Error?) -> Void) {
      
        let url = ApiEnd.GET_MODULES
        WSManager.getRequest(url: url, resultType: ResponseModel<SupportTicketGeneralOptionsResponseModel>.self) { result, error in
            response(result, error)
        }
    }
    
    func addSuport(request:SupportRaiseTicketRequest, response: @escaping (ResponseModel<SupportTicketModel>?, _ error: Error?) -> Void) {
      
        let url = ApiEnd().ADD_SUPPORT
        
        let parameter = [
            "description":request.description ?? "",
            "issueType":request.issueType ?? "",
            "module":request.module ?? "",
            "screenshot":request.imageBase64String ?? "",
            "screenshotImageFormat":"png"
        ]
   
        WSManager.postRequest(url: url, param: parameter, resultType: ResponseModel<SupportTicketModel>.self) { result, error in
            response(result, error)
        }
    }
    
    // MARK: -
    
    func sendMSG(supportID:Int, msg:String, response: @escaping (ResponseModel<SupportTicketModel>?, _ error: Error?) -> Void) {
      
        let url = ApiEnd().SEND_SUPPORT_MSG
        let dateString = Date().formate(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z") //ISO8601Format()
        let parameter = [
            "supportId":supportID,
            "isAdmin":false,
            "message":msg,
            "name":objUserSession.username,
            "date":dateString
        ] as [String : Any]
   
        WSManager.postRequest(url: url, param: parameter, resultType: ResponseModel<SupportTicketModel>.self) { result, error in
            response(result, error)
        }
    }
    
}
