//
//  PekoStoreCategoryModel.swift
//  Peko
//
//  Created by Hardik Makwana on 20/05/23.
//

import UIKit

struct PekoStoreCategoryResponseDataModel: Codable {
    let data:[PekoStoreCategoryModel]?
}
struct PekoStoreCategoryModel: Codable {
   
    let id:Int?
    let vendorId:Int?
 //   let categoryStatus:Bool?
    
    let categoryName:String?
    let categoryImage:String?
    
    let createdAt:String?
    let updatedAt:String?
    
}


/*
{
            "": 2,
            "": "Electronics",
            "": "https://firebasestorage.googleapis.com/v0/b/peko-a2d2f.appspot.com/o/profile%2Fimages%2F1677030234823.gif?alt=media&token=193cc2f3-bb92-478a-ba2c-f7c49e4ae889",
            "": true,
            "": "2023-02-22T01:43:57.000Z",
            "": "2023-02-22T01:43:57.000Z",
            "": 6
        },
*/
