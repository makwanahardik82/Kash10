//
//  eSimModel.swift
//  Peko
//
//  Created by Hardik Makwana on 14/04/24.
//

import UIKit


struct DeviceListResponseDataModel: Codable {
    let deviceList:[MobileDeviceModel]?
}
struct MobileDeviceModel: Codable {
    
    let model:String?
    let os:String?
    let brand:String?
    
    let name:String?
    
}



struct PackageResponseDataModel: Codable {
    let packages:[ESimPackageModel]?
    let usdToAed:CustomDouble?
}


struct ESimPackageModel: Codable {
    
    let slug:String?
    let country_code:String?
    let title:String?
    
    let image:ESimPackageImageModel?
    let operators:[ESimPackageOperatorModel]?
}
struct ESimPackageImageModel: Codable {
    let width:Int?
    let height:Int?
    let url:String?
}
struct ESimPackageOperatorModel: Codable {
    let id:Int?
    
    let style:String?
    let gradient_start:String?
    let gradient_end:String?
    let type:String?
    let title:String?
    let esim_type:String?
    // let warning:String?
    let apn_type:String?
    let apn_value:String?
    //  let info:String?
    
    let is_prepaid:Bool?
    let is_roaming:Bool?
    let is_kyc_verify:Bool?
    let rechargeability:Bool?
    let image:ESimPackageImageModel?
    
    let plan_type:String?
    let activation_policy:String?
    // let other_info:String?
    
    let coverages:[ESimPackageOperatorCoveragesModel]?
    
    let packages:[ESimPackageOperatorPakageModel]?
    let countries:[ESimPackageOperatorCountriesModel]?
    
}
struct ESimPackageOperatorCoveragesModel: Codable {
    let networks:[ESimPackageOperatorCoveragesNetworksModel]?
    let name:String?
}
struct ESimPackageOperatorCoveragesNetworksModel: Codable {
    let name:String?
    //types
}

struct ESimPackageOperatorPakageModel: Codable {
    
    let id:String?
    let type:String?
    let price:CustomDouble?
    let amount:CustomDouble?
    let day:CustomInt?
    let is_unlimited:Bool?
    let title:String?
    let data:String?
    //  let short_info:String?
    let qr_installation:CustomString?
    let manual_installation:CustomString?
    let voice:CustomString?
    let text:CustomString?
    let net_price:CustomDouble?
    
}
struct ESimPackageOperatorCountriesModel: Codable {
    let image:ESimPackageImageModel?
    
    let title:String?
    let country_code:String?
   
}



struct ESimPaymentResponseDataModel: Codable {
    
    let corporateFinalBalance:String?
 //   let corporateTxnId:CustomInt?
    let corporateCashback:String?
   
    let orderId: CustomInt?
    let transactionId: CustomInt?
    let customerTxnId: CustomInt?

}




//struct PackageResponseDataModel: Codable {
struct HistoryResponseDataModel: Codable {
//    let packageList:[eSimHistoryModel]?
//    let usdToAed:CustomDouble?
    
    let data:[eSimHistoryModel]?
    let recordsTotal:Int?
    
}

struct eSimHistoryModel: Codable {
    
    let id:Int?
    
    let remarks:String?
    let quantity:CustomInt?
    let amount:CustomDouble?
    let createdAt:String?
    let updatedAt:String?
    
    let credentialId:CustomInt?
    let transactionId:CustomInt?
   
  
    let packageDetails:HistoryPackageDetailModel?
    let simDetails:[HistorySimDetailModel]?
  //  let credential:HistoryPackageModel?
    let transaction:eSimHistoryTransactionModel?
   
}

struct eSimHistoryDetailModel: Codable {
    
    let packageDetails:HistoryPackageDetailModel?
    let simDetails:HistorySimDetailModel?
    let usage:eSimHistoryUsageModel?
}

struct HistoryPackageDetailModel: Codable {
    
     let id:Int?
   
    let price:CustomDouble?
    let validity:Int?
    
    let code:String?
    let data:String?
    let type:String?
    let package:String?
    let currency:String?
    let quantity:String?
    let esim_type:String?
    let created_at:String?
    let package_id:String?
    let description:String?
    let operatorName:String?
    let operatorImage:String?
    let manual_installation:String?
    let qrcode_installation:String?
  
  //  let isRechargable:Bool?
  //  let installation_guides:[String]?
        
}
struct HistorySimDetailModel: Codable {
    
    let id:Int?
    
    let lpa:String?
    let iccid:String?
    let imsis:String?
    let qrcode:String?
    let apn_type:String?
    let apn_value:String?
    let created_at:String?
    let qrcode_url:String?
    let airalo_code:String?
    let matching_id:String?
    let confirmation_code:String?
    
    let is_roaming:Bool?
    
}
struct eSimHistoryTransactionModel: Codable {
    
    let corporateTxnId:String?
    let status:String?
    
    let order:eSimHistoryTransactionOrderModel?
    let createdAt:String?
    let updatedAt:String?
    
    let credentialId:CustomInt?
    let transactionId:CustomInt?
    
}
struct eSimHistoryTransactionOrderModel: Codable {
    let paymentMode:String?
    let amountInAed:String?
}


struct eSimHistoryUsageModel: Codable {
    let remaining:Int?
    let total:Int?
    let remaining_voice:Int?
    let remaining_text:Int?
    let total_voice:Int?
    let total_text:Int?
   
   
    let expired_at:String?
    let status:String?
    
    let is_unlimited:Bool?
    
}

