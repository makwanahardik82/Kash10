//
//  WSManager.swift
//  Peko
//
//  Created by Hardik Makwana on 19/01/23.
//

import UIKit

import Alamofire

class WSManager: NSObject {
    
    class func getHeaders() -> HTTPHeaders? {
        var header : HTTPHeaders?
        if objUserSession.token != "" {
            header = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(objUserSession.token)",
                "sessionId":objUserSession.sessionId,
                "platform":"mobile"
            ]
            
        } else {
            header = nil
        }
        return header
    }
    
    
    // MARK: - POST METHOD
    class func postRequest<T: Codable>(url: String, param: [String:Any], resultType: T.Type, completionHandler:@escaping(_ result: T?, _ error: Error?)-> Void)
    {
        guard let urlStr = URL(string: ApiEnd().BASE_URL + url) else {
            return
        }
        //let header : HTTPHeaders = WSManager.getHeaders() ?? nil
//        if objUserSession.token != "" {
//            header = [
//                "Content-Type": "application/json",
//                "Authorization": "Bearer \(objUserSession.token)",
//                "sessionId":objUserSession.sessionId
//            ]
//            
//        } else {
//            header = nil
//        }
        AF.request(urlStr, method: .post, parameters: param, encoding: JSONEncoding.default, headers: WSManager.getHeaders()).responseDecodable { (response: DataResponse<T, AFError>) in
            if let result = response.value {
                
                if result is ResponseModel<T> {
                    print("YES")
                }
                
                
                completionHandler(result, nil)
            } else {
                completionHandler(nil, response.error)
            }
        }
    }
    
    // MARK: - GET METHOD
    class func getRequest<T: Codable>(url: String, resultType: T.Type, completionHandler:@escaping(_ result: T?, _ error: Error?)-> Void)
    {
        guard let urlStr = URL(string: (ApiEnd().BASE_URL + url).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            return
        }
       // let header : HTTPHeaders = WSManager.getHeaders()!
//        if objUserSession.token != "" {
//            header = [
//                "Content-Type": "application/json",
//                "Authorization": "Bearer \(objUserSession.token)",
//                "sessionId":objUserSession.sessionId
//            ]
//        } else {
//            header = nil
//        }
        // api/v1/transactions/22/reports
        AF.request(urlStr, method: .get, encoding: URLEncoding.default, headers: WSManager.getHeaders()).responseDecodable { (response: DataResponse<T, AFError>) in
            if let result = response.value {
                if result is ResponseModel<T> {
                    print("YES")
                }
                completionHandler(result, nil)
            } else {
               // let result = ResponseModel<T.Type>(err: response.error?.localizedDescription ?? "")
               
                completionHandler(nil, response.error)
             //   debugPrint(response.error?.localizedDescription)
               // completionHandler()
            }
        }
    }
    // MARK: - PUT METHOD
    class func putRequest<T: Codable>(url: String, param: [String:Any], resultType: T.Type, completionHandler:@escaping(_ result: T?, _ error: Error?)-> Void)
    {
        guard let urlStr = URL(string: ApiEnd().BASE_URL + url) else {
            return
        }
      //  let header : HTTPHeaders = WSManager.getHeaders()!
//        if objUserSession.token != "" {
//            header = [
//                "Content-Type": "application/json",
//                "Authorization": "Bearer \(objUserSession.token)",
//                "sessionId":objUserSession.sessionId
//            ]
//        } else {
//            header = nil
//        }
        AF.request(urlStr, method: .put, parameters: param, encoding: JSONEncoding.default, headers: WSManager.getHeaders()).responseDecodable { (response: DataResponse<T, AFError>) in
            if let result = response.value {
                completionHandler(result, nil)
            } else {
                completionHandler(nil, response.error)
            }
        }
    }
    // MARK: - POST METHOD
    class func deleteRequest<T: Codable>(url: String, param: [String:Any], resultType: T.Type, completionHandler:@escaping(_ result: T?, _ error: Error?)-> Void)
    {
        guard let urlStr = URL(string: ApiEnd().BASE_URL + url) else {
            return
        }
        
    //    let header : HTTPHeaders = WSManager.getHeaders()!
//        if objUserSession.token != "" {
//            header = [
//                "Content-Type": "application/json",
//                "Authorization": "Bearer \(objUserSession.token)",
//                "sessionId":objUserSession.sessionId
//            ]
//        } else {
//            header = nil
//        }
        AF.request(urlStr, method: .delete, parameters: param, encoding: JSONEncoding.default, headers: WSManager.getHeaders()).responseDecodable { (response: DataResponse<T, AFError>) in
            if let result = response.value {
                completionHandler(result, nil)
            } else {
                completionHandler(nil, response.error)
            }
        }
    }
    
    // MARK: - PATCH METHOD
    class func patchRequest<T: Codable>(url: String, param: [String:Any], resultType: T.Type, completionHandler:@escaping(_ result: T?, _ error: Error?)-> Void)
    {
        guard let urlStr = URL(string: ApiEnd().BASE_URL + url) else {
            return
        }
    //    let header : HTTPHeaders = WSManager.getHeaders()!
//        if objUserSession.token != "" {
//            header = [
//                "Content-Type": "application/json",
//                "Authorization": "Bearer \(objUserSession.token)",
//                "sessionId":objUserSession.sessionId
//            ]
//        } else {
//            header = nil
//        }
        AF.request(urlStr, method: .patch, parameters: param, encoding: JSONEncoding.default, headers: WSManager.getHeaders()).responseDecodable { (response: DataResponse<T, AFError>) in
            if let result = response.value {
                completionHandler(result, nil)
            } else {
                completionHandler(nil, response.error)
            }
        }
    }
    
    
    
    
    // MARK: - Upload Data
    // MARK: - Upload image
    class func requestUploadData(url : String, params :[String:Any], imageParams :[[String:Any]], completionHandler:@escaping([String:Any])-> Void) {
    
    //[String : AnyObject]!, imageName : String!,image:Data, success:@escaping ([String:Any]) -> Void, failure:@escaping (Error) -> Void) {
        
        guard let urlStr = URL(string: ApiEnd().BASE_URL + url) else {
            return
        }
     //   let header : HTTPHeaders = WSManager.getHeaders()!
//        if objUserSession.token != "" {
//            header = [
//                "Content-Type": "application/json",
//                "Authorization": "Bearer \(objUserSession.token)",
//                "sessionId":objUserSession.sessionId
//            ]
//        } else {
//            header = nil
//        }
//        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in params {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)}
                    
                    if value is Int {
                        multipartFormData.append("(temp)".data(using: .utf8)!, withName: key)}
                    
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                                if element is Int {
                                    let value = "(num)"
                                    multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                for imgDic in imageParams {
                    let imgData = imgDic["image_data"] as? Data ?? Data()
                    let imgName = imgDic["image_name"] as? String ?? ""
                    
                    multipartFormData.append(imgData, withName: imgName, fileName: "registerImage.png", mimeType: "image/png")
                }
               
        },
            to:  urlStr,
            method: .put,
            headers: WSManager.getHeaders()).responseJSON { (response) in
              
                switch response.result {
                case .success(_):
                    if let json = response.value
                    {
                        completionHandler((json as! [String:AnyObject]))
                    }
                    break
                case .failure(let error):
                    completionHandler(["success":false, "message":error.localizedDescription])
                    break
                }
                
//
//                if let result = response.value {
//                    completionHandler(result)
//                } else {
//                    debugPrint(response.error?.localizedDescription)
//                  //  completionHandler(nil)
//                    // completionHandler(.error(error: response.error?.localizedDescription ?? ""))
//                }
            }
    }

    
    
    // MARK: - JSON
    
    class func postRequestJSON(urlString:String, withParameter params: [String: Any]!, completion: @escaping (_ success: Bool, _ result:[String:Any]?) -> Void)  {
    
        guard let urlStr = URL(string: ApiEnd().BASE_URL + urlString) else {
            return
        }
     //   let header : HTTPHeaders = WSManager.getHeaders()!
//        if objUserSession.token != "" {
//            header = [
//                "Content-Type": "application/json",
//                "Authorization": "Bearer \(objUserSession.token)",
//                "sessionId":objUserSession.sessionId
//            ]
//        } else {
//            header = nil
//        }
//       
       // let string = params.toJSON()
        /*
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: params,
                                                            options: [.prettyPrinted]) else {
            return
        }
      
        var request = URLRequest(url: urlStr)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.headers = header!
        request.httpBody = theJSONData //(string).data(using: .unicode)
        
        AF.request(request).responseJSON { (response) in
            
            switch response.result {
                
            case .success(_):
                if let json = response.value as? [String : Any]
                {
                    print(response)
                    
                    //completion(true, json)
                }
                break
            case .failure(let error):
                completion(false, nil)
                break
            }
        }
        */
    // URLEncodedFormParameterEncoder(destination: .httpBody),
        AF.request(urlStr, method: .post, parameters: params, encoding: JSONEncoding.default, headers: WSManager.getHeaders()).responseJSON { (response) in
            
            switch response.result {
                
            case .success(_):
                if let json = response.value as? [String : Any]
                {
                    completion(true, json)
                }
                break
            case .failure(let error):
                completion(false, nil)
                break
            }
        }
    }
    
    class func getRequestJSON(urlString:String, withParameter params: [String: Any]!, completion: @escaping (_ success: Bool, _ result:[String:Any]?) -> Void)  {
    
        guard let urlStr = URL(string: ApiEnd().BASE_URL + urlString) else {
            return
        }
     //   let header : HTTPHeaders = WSManager.getHeaders()!
//        if objUserSession.token != "" {
//            header = [
//                "Content-Type": "application/json",
//                "Authorization": "Bearer \(objUserSession.token)",
//                "sessionId":objUserSession.sessionId
//            ]
//        } else {
//            header = nil
//        }
        
        AF.request(urlStr, method: .get, parameters: params, encoding: JSONEncoding.default, headers: WSManager.getHeaders()).responseJSON { (response) in
            
            switch response.result {
                
            case .success(_):
                if let json = response.value as? [String : Any]
                {
                    completion(true, json)
                }
                break
            case .failure(let error):
                completion(false, nil)
                break
            }
        }
    }
    class func putRequestJSON(urlString:String, withParameter params: [String: Any]!, completion: @escaping (_ success: Bool, _ result:[String:Any]?) -> Void)  {
    
        guard let urlStr = URL(string: ApiEnd().BASE_URL + urlString) else {
            return
        }
  //      let header : HTTPHeaders = WSManager.getHeaders()!
//        if objUserSession.token != "" {
//            header = [
//                "Content-Type": "application/json",
//                "Authorization": "Bearer \(objUserSession.token)",
//                "sessionId":objUserSession.sessionId
//            ]
//        } else {
//            header = nil
//        }
//        
        AF.request(urlStr, method: .put, parameters: params, encoding: JSONEncoding.default, headers: WSManager.getHeaders()).responseJSON { (response) in
            
            switch response.result {
                
            case .success(_):
                if let json = response.value as? [String : Any]
                {
                    completion(true, json)
                }
                break
            case .failure(let error):
                completion(false, nil)
                break
            }
        }
    }
    
    class func patchRequestJSON(urlString:String, withParameter params: [String: Any]!, completion: @escaping (_ success: Bool, _ result:[String:Any]?) -> Void)  {
    
        guard let urlStr = URL(string: ApiEnd().BASE_URL + urlString) else {
            return
        }
      //  let header : HTTPHeaders = WSManager.getHeaders()!
//        if objUserSession.token != "" {
//            header = [
//                "Content-Type": "application/json",
//                "Authorization": "Bearer \(objUserSession.token)",
//                "sessionid":objUserSession.sessionId
//            ]
//        } else {
//            header = nil
//        }
        
        AF.request(urlStr, method: .patch, parameters: params, encoding: JSONEncoding.default, headers: WSManager.getHeaders()).responseJSON { (response) in
            
            switch response.result {
                
            case .success(_):
                if let json = response.value as? [String : Any]
                {
                    completion(true, json)
                }
                break
            case .failure(let error):
                completion(false, nil)
                break
            }
        }
    }
    
}
