//
//  HotelBookingManager.swift
//  Peko
//
//  Created by Hardik Makwana on 09/01/24.
//

import UIKit

var objHotelBookingManager:HotelBookingManager?

class HotelBookingManager: NSObject {
    
    static let sharedInstance = HotelBookingManager()
    
    var conversationId:String = ""
    var searchKey:String = ""
    var hotelKey:String = ""
    
    var hotelListData:HotelBookingSearchResponseDataModel?
    var hotelDetailsData:HotelBookingSearchResponseDataModel?
   
    var searchRequest:HotelBookingSearchRequest?
    
    var selectedRooms = [HotelBookingSearchRoomModel]()
    
    var hotelPreBookResponse:HotelBookingPreBookDataResponseModel?
    
    var guestArray = [HotelBookingGuestModel]()
    
    /*
    lazy var roomDetails: HotelBookingSearchRoomModel? = {
        if roomsArray != nil && roomsArray?.count != 0 {
            return roomsArray?.first
        }
        return nil
    }()
    
    func roomKeyArray(index:Int = 0) -> [Dictionary<String, Any>] { // 0 = Pre Book, 1 = Book
        
        var array = [Dictionary<String, Any>]()
        
        if roomsArray != nil && roomsArray?.count != 0 {
           
            if index == 0 {
                for val in roomsArray!{
                    let tmp = [
                        "roomIndex": val.roomIndex ?? "",
                        "roomKey": val.roomKey ?? ""
                    ] as [String : Any]
                    array.append(tmp)
                }
            }
            return array
        }
        return array
    }
    */
}


