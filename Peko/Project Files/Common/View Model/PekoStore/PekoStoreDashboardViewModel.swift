//
//  PekoStoreDashboardViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 15/05/23.
//

import UIKit

struct PekoStoreDashboardViewModel {
    
    
    // MARK: - Get Products
    func getCategories(response: @escaping (ResponseModel<PekoStoreCategoryResponseDataModel>?, _ error: Error?) -> Void) {
       
        let url = ApiEnd().PEKO_STORE_CATEGORIES_URL
  
        WSManager.getRequest(url: url, resultType: ResponseModel<PekoStoreCategoryResponseDataModel>.self) { result, error in
         //   print(result)
            response(result, error)
            
        }
    }
    
    // MARK: - Get Products
    func getProducts(category_id:String, offset:Int, limit:Int, search:String, sortBy:String, response: @escaping (ResponseModel<PekoStoreProductResponseDataModel>?, _ error: Error?) -> Void) {
       // offset=0&limit=10&searchText=
        var url = ApiEnd().PEKO_STORE_PRODUCTS_URL + "?offset=\(offset)&limit=\(limit)&searchText=\(search)"
        if category_id.count != 0 {
            url = url + "&catIds=\(category_id)"
        }
        if sortBy.count != 0 {
            url = url + "&sortBy=\(sortBy.lowercased())"
        }else{
            url = url + "&sortBy=all"
        }
        WSManager.getRequest(url: url, resultType: ResponseModel<PekoStoreProductResponseDataModel>.self) { result, error in
         //   print(result)
            response(result, error)
            
        }
    }
    func getProductDetails(product_id:String, response: @escaping (ResponseModel<PekoStoreProductDetailsResponseDataModel>?, _ error: Error?) -> Void) {
       // offset=0&limit=10&searchText=
        var url = ApiEnd().PEKO_STORE_PRODUCTS_DETAILS_URL + "?productId=\(product_id)"
       
        WSManager.getRequest(url: url, resultType: ResponseModel<PekoStoreProductDetailsResponseDataModel>.self) { result, error in
         //   print(result)
            response(result, error)
            
        }
    }
    // MARK: - Add to Cart
    func addProductsToCart(product_id:Int, qty:Int, response: @escaping (ResponseModel<PekoStoreAddToCartModel>?, _ error: Error?) -> Void) {
       
        let url = ApiEnd().PEKO_STORE_ADD_TO_CART_URL
  
        let parameter = [
            "productId":"\(product_id)",
            "productQuantity":"\(qty)"
        ]
        
        WSManager.postRequest(url: url, param: parameter, resultType: ResponseModel<PekoStoreAddToCartModel>.self) { result, error  in
            response(result!, error)

        }
    }
    
    // MARK: - Update Product QTY
    func updateProductsQTY(product_id:Int, qty:Int, isAdd:Bool, response: @escaping (CommonResponseModel?, _ error: Error?) -> Void) {
       
        let url = ApiEnd().PEKO_STORE_UPDATE_CART_URL
  
        var parameter = [
            "productId":"\(product_id)",
            "productQuantity":"\(qty)",
            "userType":objUserSession.role
        ]
        
        if isAdd {
            parameter["operation"] = "increase"
        }else{
            parameter["operation"] = "decrease"
        }
        print(parameter.toJSON())
        
        WSManager.putRequest(url: url, param: parameter, resultType: CommonResponseModel.self) { result, error  in
            response(result!, error)

        }
    }
    // MARK: - Delete Product from Cart
    func deleteProductFromCart(product_id:Int, response: @escaping (CommonResponseModel?, _ error: Error?) -> Void) {
       
        let url = ApiEnd().PEKO_STORE_DELETE_FROM_CART_URL + "?productId=\(product_id)"
  
        WSManager.deleteRequest(url: url, param: [:], resultType: CommonResponseModel.self) { result, error  in
            response(result!, error)

        }
    }
    
    // MARK: - payment
    func payment(total:Double, response: @escaping (ResponseModel<PekoStoreOrderPaymentModel>?, _ error: Error?) -> Void) {
       
        let url = ApiEnd().PEKO_STORE_PAYMENT_URL
       
       
        let parameter = self.getParametersForCreateNIOrder(amount: total)
        
        print(parameter.toJSON())
        WSManager.postRequest(url: url, param: parameter, resultType: ResponseModel<PekoStoreOrderPaymentModel>.self) { result, error  in
            response(result, error)
        }
    }
   
    func getParametersForCreateNIOrder(amount:Double) -> [String:Any] {
        let timestamp = Date().timeIntervalSince1970

        var array:[String] = [(objPekoStoreManager?.selectedAddress?.addressLine1 ?? ""), (objPekoStoreManager?.selectedAddress?.addressLine2 ?? ""), (objPekoStoreManager?.selectedAddress?.city ?? ""), (objPekoStoreManager?.selectedAddress?.country ?? ""), (objPekoStoreManager?.selectedAddress?.zipCode ?? "")]
        array = array.filter({ $0 != ""})
        
        let address = [
            "firstName":objPekoStoreManager?.selectedAddress?.name ?? "",
            "lastName":objPekoStoreManager?.selectedAddress?.nickname ?? "",
            "address": array.joined(separator: ", "),
        //    "zipcode": objPekoStoreManager?.selectedAddress?.zipCode ?? "",
            "phoneNumber": objPekoStoreManager?.selectedAddress?.phoneNumber ?? "",
            "remarks": ""
        ]
        
        let parameter = [
            "userEmail":objUserSession.profileDetail?.email ?? "",
         //   "account":objUserSession.username,
            "transactionId":"\(Int(timestamp))",
      //      "payCashback":false,
            "amount":amount,
            "cartId":objPekoStoreManager?.cartDetailModel?.cartId ?? 0,
          //  "remarks":"",
            "address":address,
            "accessKey":"ecommerce"
        ] as [String : Any]
      
        
        return parameter
    }
}
