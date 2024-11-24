//
//  PekoStoreProductResponseDataModel.swift
//  Peko
//
//  Created by Hardik Makwana on 15/05/23.
//

import UIKit

struct PekoStoreProductResponseDataModel: Codable {
   
    let count:Int?
    let rows:[PekoStoreProductModel]?
            
}
struct PekoStoreProductDetailsResponseDataModel: Codable {
    let productDetails:PekoStoreProductModel?
    let photos:[PekoStoreProductPhotoModel]?
}
struct PekoStoreProductModel: Codable {
   
    let id:Int?
    let name:String?
    let SKUCode:String?
    let description:String?
   
    let productImage:String?
    let price:String?
    let vendorPrice:String?
    let actualPrice:String?
    
    let VAT:String?
    let vatType:String?
   
    
    let brand:String?
    let highlights:String?
    let warranty:String?
   
    let discountType:String?
    let discount:String?
    
    let quantity:Int?
 //   let status:Bool?
//
    let createdAt:String?
    let updatedAt:String?
    
    let categoryId:Int?
    let category:PekoStoreCategoryModel?
    
}
struct PekoStoreProductPhotoModel: Codable {

    let id:Int?
    let productImageUrl:String?
    let imageField:String?
    let productId:Int?

    let createdAt:String?
    let updatedAt:String?

}

/*
{
    "": 1,
    "": "HP 255 G8 NOTEBOOK 15.6-Inch",
    "": "255 G8 NOTEBOOK With 15.6-Inch Display, AMD Ryzen 7 5700U Processor/8GB RAM/256GB SSD/Integrated Graphics/Windows 11 English Silver",
    "": "HP255",
    
    "": "https://firebasestorage.googleapis.com/v0/b/peko-a2d2f.appspot.com/o/profile%2Fimages%2F1677050714750.jpeg?alt=media&token=b4c9d0d1-29b1-4524-a1dc-2bc76b8cc268",
    "": "1599.00",
    "": 1,
    "": true,
    
    "": "2023-02-22T07:25:21.000Z",
    "": "2023-02-22T07:25:21.000Z",
   
    "": 1,
    
    "category": {
        "id": 1,
        "categoryName": "Laptops",
        "categoryImage": "https://firebasestorage.googleapis.com/v0/b/peko-a2d2f.appspot.com/o/profile%2Fimages%2F1677050478614.png?alt=media&token=86ffaed1-264c-4330-8d46-a30f956dc63c",
        "categoryStatus": true,
        "createdAt": "2023-02-22T07:21:21.000Z",
        "updatedAt": "2023-02-22T07:58:29.000Z",
        "vendorId": 4
    }
}
*/
