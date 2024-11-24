//
//  CarbonResponseModel.swift
//  Peko
//
//  Created by Hardik Makwana on 06/03/24.
//

import UIKit

class CarbonResponseModel: NSObject {

}
struct CarbonQuestionResponseDataModel:Codable {
    let success:Bool?
    let recordsTotal:Int?
    let data:CarbonQuestionAnswerArrayModel?
}
struct CarbonQuestionAnswerArrayModel:Codable {
    
    let questionSheet:[CarbonQuestionDataModel]?
 //   let answerSheet:AnswerSheetModel?

}
struct CarbonQuestionDataModel:Codable {
    
    let id:Int?
    let category:String?
    let type:String?
    let status:Bool?
    let questions:[CarbonQuestionModel]?

}
struct CarbonQuestionModel:Codable {
    let id:Int?
    let toolTip:String?
    let question:String?
    let options:[CarbonQuestionOptionsModel]?
}
struct CarbonQuestionOptionsModel:Codable {
    let id:Int?
    let title:String?
    let units:[CarbonQuestionOptionsUnitModel]?
}
struct CarbonQuestionOptionsUnitModel:Codable {
    let EF:CustomDouble?
    let id:Int?
    let unit:String?
}

// MARK: - DASHBOARD


struct CarbonDashboardDataModel:Codable {
    let counters:CarbonDashboardDataCountersModel?
    let projects:[CarbonProjectModel]?
}

struct CarbonDashboardDataCountersModel:Codable {
 
    let communityOffset:CustomDouble?
    let projectsInvested:CustomDouble?
    let totalProjects:CustomDouble?
    let userOffset:CustomDouble?
    let co2FootPrint:CustomDouble?
 
}

// MARK: - PROJECTS

struct CarbonProjectResponseDataModel:Codable {
    
    let success:Bool?
    let data:[CarbonProjectModel]?
    let count:Int?
    let totalPages:Int?
}

struct CarbonProjectNeutralizeResponseDataModel:Codable {
    
    let success:Bool?
    let data:CarbonProjectModel?
 
    let calculatedRate:Double?
    let co2FootPrint:String?
    let usdToAed:Double?
}

struct CarbonProjectModel:Codable {
 
    let id:Int?
    let name:String?
    let description:String?
    let working:String?
   
    let logo:String?
    let country:String?
    let countryCode:String?
    let latLng:String?
    let city:String?
    let address:String?
    let goal:String?
   
    let status:Bool?
   
    let createdAt:String?
    let updatedAt:String?
   
    let categoryId:Int?
    let vendorId:Int?
    
    let body:CarbonProjectBodyModel?
    
    let category:CarbonProjectCategoryModel?
    let rate:CarbonProjectRateModel?
    
    let packages:[CarbonProjectPackagesModel]?
    let photos:[CarbonProjectPhotoModel]?

    let vendor:CarbonProjectVendorModel?
  
    let ProjectGoalsAssociation:[CarbonProjectProjectGoalsAssociationModel]?
   
    
   
}
struct CarbonProjectBodyModel:Codable {
    var html:String?
}
struct CarbonProjectCategoryModel:Codable {
    var name:String?
    var logo:String?
}
struct CarbonProjectRateModel:Codable {
    var priceToSMB:String?
    var priceToIndividual:String?
    var priceToPartner:String?
}
struct CarbonProjectPackagesModel:Codable {
    var id:Int?
    var name:String?
    var description:String?
    
    var amount:String?
    var credits:String?
    var logo:String?
}

struct CarbonProjectPhotoModel:Codable {
    var projectImageUrl:String?
    var imageField:String?
}

struct CarbonProjectVendorModel:Codable {
   
    var id:Int?
    
    var vendorName:String?
    var type:String?
    var isActive:Bool?
    
    var apiUrl:String?
    var healthUrl:String?
    var country:String?
    
    var currency:String?
   
    var optional1:String?
    var optional2:String?
    var optional3:String?
    var optional4:String?
    var optional5:String?
    var optional6:String?
    
    let createdAt:String?
    let updatedAt:String?
   
}

struct CarbonProjectProjectGoalsAssociationModel:Codable {
    
    var id:Int?
    
    var name:String?
    var logo:String?
  
    var status:Bool?
    
    var createdAt:String?
    var updatedAt:String?
    
    var ProjectGoals:CarbonProjectProjectGoalsAssociationProjectGoalsModel?
}
struct CarbonProjectProjectGoalsAssociationProjectGoalsModel:Codable {
    
    var projectId:Int?
    var goalId:Int?
   
    var createdAt:String?
    var updatedAt:String?
    
}

struct CarbonPaymentResponseModel:Codable {
  
    
    let corporateFinalBalance:CustomString?
    let corporateCashback:String?
    let datetime:String?
    let corporateTxnId:CustomInt
  
    var orderId:Int?
    
    var resultData:CarbonPaymentResponseResultDataModel?
   
}
struct CarbonPaymentResponseResultDataModel:Codable {
    
    var certificateNo:Int?
    var id:Int?
  
    var transactionId:CustomString?
    
    var transactionDate:String?
    var transactionType:String?
    
    var remarks:String?
    var status:String?
    
    var inventoryHistoryConsumption:String?
    
    var partnerCashback:String?
    
    var updatedAt:String?
    var createdAt:String?
   
    var amount:Double?
    var co2Offset:Double?
    
    var providerId:CustomInt?
    var packageId:CustomInt?
   
    var orderId:CustomInt?
    var projectId:CustomInt?
    var credentialId:CustomInt?
   
    var date:Date {
        get {
            return self.transactionDate!.dateFromISO8601() ?? Date()
        }
    }
}

// MARK: -
struct CarbonCalculateResponseModel:Codable {
    
    var success:Bool?
    var data:CarbonCalculateDataModel?
  
}
struct CarbonCalculateDataModel:Codable {
    
    var totalCo2Usage:CustomString?
    var groupedByCategory:[CarbonCalculateDataGroupedCategoryModel]?
  
}

struct CarbonCalculateDataGroupedCategoryModel:Codable {
    let category:String?
    let totalCo2Usage:CustomDouble?
}
/*
// MARK: - Model
struct AnswerSheetModel:Codable {
    
    var unknown:AnswerSheetDetailModel?
   
}
struct AnswerSheetDetailModel:Codable {
    
    let category:String?
    let type:String?
   
    let answers:[AnswerSheetQuestionModel]?
}

struct AnswerSheetQuestionModel:Codable {
    var unknown:AnswerSheetOptionModel?
}

struct AnswerSheetOptionModel:Codable {
    var unknown:AnswerSheetValueModel?
}
struct AnswerSheetValueModel:Codable {
    let selectedUnitId:Int?
    let value:String?
}
*/
