//
//  GiftCardsProductsViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 10/05/23.
//

import UIKit


struct GiftCardsProductsViewModel {
    
    // MARK: - Category
    func getCategory(response: @escaping (ResponseModel<GiftCardProductDataModel>?, _ error: Error?) -> Void) {
       
        let url = ApiEnd.GIFT_CARD_CATEGORIES_URL
        print("\n\n\n URL => ", url)
        
        WSManager.getRequest(url: url, resultType: ResponseModel<GiftCardProductDataModel>.self) { result, error in
         //   print(result)
            response(result, error)
            
        }
    }
    // MARK: - fetchBeneficiary
    func getProducts(category_id:Int, offset:Int, limit:Int, response: @escaping (ResponseModel<[GiftCardProductModel]>?, _ error: Error?) -> Void) {
        
        var url = ""
        if objShareManager.appTarget == .PekoUAE {
            url = ApiEnd().GIFT_CARD_PRODUCTS_URL + "?page=\(offset)&pageSize=\(limit)"
            
            //  [10:56 am] Muhammed Sanan (External)
      //      purchase/giftcards/all?page=1&pageSize=20
             
            // &accessKeys=[\"premo_gift_cards\",\"quickcilver\",\"youGotAGift\"]"
            
        }else if objShareManager.appTarget == .PekoIndia {
            url = ApiEnd().GIFT_CARD_PRODUCTS_URL + "?offset=\(offset)&limit=\(limit)"
        }
        
        print("\n\n\n URL => ", url)
        
        WSManager.getRequest(url: url, resultType: ResponseModel<[GiftCardProductModel]>.self) { result, error in
         //   print(result)
            response(result, error)
            
        }
    }
    // MARK: - fetchBeneficiary
    func getProductsForIndia(category_id:Int, offset:Int, limit:Int, response: @escaping (ResponseModel<GiftCardProductDataIndiaModel>?, _ error: Error?) -> Void) {
        
        var url = ""
        url = ApiEnd().GIFT_CARD_PRODUCTS_URL + "?offset=\(offset)&limit=\(limit)"
        print("\n\n\n URL => ", url)
        
        WSManager.getRequest(url: url, resultType: ResponseModel<GiftCardProductDataIndiaModel>.self) { result, error in
         //   print(result)
            response(result, error)
            
        }
    }
   
    
    // MARK: -
    func orderGiftCard(amount:Double, response: @escaping (ResponseModel<GiftCardOrderModel>?, _ error: Error?) -> Void) {
    let url = ApiEnd().GIFT_CARD_ORDER_URL
        let parameter = self.getParametersForCreateOrder(amount: amount)
        print(parameter.toJSON())
        
        WSManager.postRequest(url: url, param: parameter, resultType: ResponseModel<GiftCardOrderModel>.self) { result, error  in
            response(result!, error)
        }
        
//        WSManager.postRequestJSON(urlString: url, withParameter: parameter) { success, result in
//            print(result)
//            print(result?.toJSON())
//            
//        }
    }
    func getParametersForCreateOrder(amount:Double) -> [String:Any] {
        
       // let address = objGiftCardManager?.address
    
        var parameter:[String:Any]?
       
        parameter = [
            "giftCardId": (objGiftCardManager?.productUAEModel?.product_id?.value ?? 0),
            "first_name": objGiftCardManager?.addressRequest?.firstName ?? "",
            "last_name": "",
            "email": objGiftCardManager?.addressRequest?.email ?? "",
           // "telephone": (address?.phoneNumber ?? ""),
           // "gender": "m",
            "amount": amount.decimalPoints(point: 2),
          //  "number_of_items": (objGiftCardManager?.quality ?? 1),
           // "load_amount": (objGiftCardManager?.amount ?? 0.0),
            "senderName": objUserSession.profileDetail?.name ?? "",
            "senderPhone": "",
            "message": objGiftCardManager?.addressRequest?.message ?? "",
            "accessKey":"globeTopper_gift_cards"
        ]
//        
//        "giftCardId": 663, // required  --
//          "first_name": "Christapher Antony", // required
//          "email": "onlineac012@gmail.com", // required
//          "amount": 50, // required-- amont to be added to cards
//          "senderName": "", // required
//          "senderPhone": "",
//          "senderEmail": "",
//          "message": "",
//          "accessKey": "globeTopper_gift_cards"
//        
        
        
        return parameter!
    }
    
    
    
    // MARK: - fetchBeneficiary
    func getHistory(fromDate:Date, toDate:Date, searchText:String, sort:String = "DESC", filter:String = "SUCCESS", offset:Int, limit:Int = 10, response: @escaping (ResponseModel<GiftCardHistoryResponseDataModel>?, _ error: Error?) -> Void) {
       
        let url = ApiEnd().GIFT_CARD_HISTORY_URL + "?sort=DESC&page=\(offset)&itemsPerPage=\(limit)"
        
        // "?from=\(fromDate.formate())&to=\(toDate.formate()) 23:59:59&searchText=&sort=DESC&page=\(offset)&itemsPerPage=\(limit)"

        print("\n\n\n URL => ", url)
       // ?from=2020-01-01&to=2024-02-05 12:57:54&searchText=&sort=DESC&page=1&itemsPerPage=2
        
        WSManager.getRequest(url: url, resultType: ResponseModel<GiftCardHistoryResponseDataModel>.self) { result, error in
          //  print(result)
            response(result, error)
        }
    }
    
}



