//
//  CarbonViewModel.swift
//  Peko
//
//  Created by Hardik Makwana on 06/03/24.
//

import UIKit

struct CarbonViewModel {
    
    func getQuestions(type:String = "BASIC", response: @escaping (ResponseModel<CarbonQuestionResponseDataModel>??, _ error: Error?) -> Void) {
        let url = ApiEnd().GET_CARBON_QUESTIONS + "?type=\(type)"
        WSManager.getRequest(url: url, resultType: ResponseModel<CarbonQuestionResponseDataModel>.self) { result, error in
            //  print(result)
            response(result, error)
        }
    }
    
    func getDashboardDetails(response: @escaping (ResponseModel<CarbonDashboardDataModel>??, _ error: Error?) -> Void) {
        let url = ApiEnd().GET_CARBON_DASHBOARD_DETAILS
       
        WSManager.getRequest(url: url, resultType: ResponseModel<CarbonDashboardDataModel>.self) { result, error in
            //  print(result)
            response(result, error)
        }
    }
    func payment(finalAmount:Double, response: @escaping (ResponseModel<CarbonPaymentResponseModel>?, _ error: Error?) -> Void) {
        let url = ApiEnd().CARBON_PAYMENT
       
        let parameters = self.getParametersForCreateNIOrder(amount: finalAmount)
       
        print(parameters.toJSON())
        
        WSManager.postRequest(url: url, param: parameters, resultType: ResponseModel<CarbonPaymentResponseModel>.self) { result, error in
            response(result, error)
        }
    }
    func getParametersForCreateNIOrder(amount:Double) -> [String:Any] {
        let parameter = [
            "accessKey": "carbon_footprint",
            "amount":(objCarbonManager?.co2AmountInUSD ?? 0.0),
            "amountInAed": amount,
            "co2Offset":(objCarbonManager?.co2Tons ?? 0.0),
            "credits": (objCarbonManager?.co2Tons ?? 0.0),
            "selectedProject": [
                "id": objCarbonManager?.selectedProjectModel?.id ?? 0
            ],
            "selectedPackage":[
                "id": objCarbonManager?.selectedPackageModel?.id ?? 0
            ]
        ] as [String : Any]
        return parameter
    }
    
    func getNeutraliseDetails(p_id:Int, response: @escaping (ResponseModel<CarbonProjectNeutralizeResponseDataModel>??, _ error: Error?) -> Void) {
        let url = ApiEnd().GET_CARBON_NEUTRALIZE_DETAILS + "\(p_id)"
       
        WSManager.getRequest(url: url, resultType: ResponseModel<CarbonProjectNeutralizeResponseDataModel>.self) { result, error in
            //  print(result)
            response(result, error)
        }
    }
    
    
    func getAllProjects(page:Int, response: @escaping (ResponseModel<CarbonProjectResponseDataModel>??, _ error: Error?) -> Void) {
        let url = ApiEnd().GET_CARBON_ALL_PROJECTS + "?itemsPerPage=10&page=\(page)"
       
        WSManager.getRequest(url: url, resultType: ResponseModel<CarbonProjectResponseDataModel>.self) { result, error in
            //  print(result)
            response(result, error)
        }
    }
    
    func calculate(answer:[String:Any], response: @escaping (ResponseModel<CarbonCalculateResponseModel>??, _ error: Error?) -> Void) {
        let url = ApiEnd().GET_CARBON_QUESTIONS
       
        let parameter = [
            "answersObj":answer
        ]
       /*
        let parameter = [
            "answersObj": [
                "35": [
                    "category": "Energy and Utilities",
                    "type": "BASIC",
                    "answers": [
                        [
                            "60715272": [
                                "85446208": [
                                    "selectedUnitId": 46552501,
                                    "value": 4
                                ]
                            ]
                        ]
                    ]
                ],
                "36": [
                    "category": "Fleet Management",
                    "type": "BASIC",
                    "answers": [
                        [
                            "4707241": [
                                "49114208": [
                                    "selectedUnitId": 40575639,
                                    "value": 40
                                ]
                            ]
                        ]
                    ]
                ],
                "37": [
                    "category": "Employee Driving Habits",
                    "type": "BASIC",
                    "answers": [
                        [
                            "22587274": [
                                "1569023": [
                                    "selectedUnitId": 1553128,
                                    "value": 10
                                ],
                                "57727139": [
                                    "selectedUnitId": 29626939,
                                    "value": 20
                                ],
                                "80019825": [
                                    "selectedUnitId": 25279496,
                                    "value": 60
                                ],
                                "84272459": [
                                    "selectedUnitId": 13473950,
                                    "value": 80
                                ]
                            ]
                        ]
                    ]
                ],
                "38": [
                    "category": "Electricity",
                    "type": "BASIC",
                    "answers": [
                        [
                            "89076061": [
                                "682237": [
                                    "selectedUnitId": 12722433,
                                    "value": 0
                                ],
                                "741657": [
                                    "selectedUnitId": 86027779,
                                    "value": 0
                                ],
                                "1391346": [
                                    "selectedUnitId": 88556092,
                                    "value": 0
                                ],
                                "2414533": [
                                    "selectedUnitId": 30717261,
                                    "value": 0
                                ],
                                "5274878": [
                                    "selectedUnitId": 48628743,
                                    "value": 0
                                ],
                                "72269642": [
                                    "selectedUnitId": 4596011,
                                    "value": 0
                                ],
                                "76716680": [
                                    "selectedUnitId": 70172296,
                                    "value": 30
                                ],
                                "89729201": [
                                    "selectedUnitId": 58495982,
                                    "value": 0
                                ],
                                "95014957": [
                                    "selectedUnitId": 34712305,
                                    "value": 0
                                ]
                            ]
                        ]
                    ]
                ],
                "39": [
                    "category": "Business Travel",
                    "type": "BASIC",
                    "answers": [
                        [
                            "99135228": [
                                "25932924": [
                                    "selectedUnitId": 44976929,
                                    "value": 40
                                ],
                                "62746901": [
                                    "selectedUnitId": 84232640,
                                    "value": 20
                                ],
                                "77356444": [
                                    "selectedUnitId": 20821322,
                                    "value": 10
                                ],
                                "83451821": [
                                    "selectedUnitId": 77042220,
                                    "value": 10
                                ]
                            ]
                        ]
                    ]
                ],
                "40": [
                    "category": "Logistics",
                    "type": "BASIC",
                    "answers": [
                        [
                            "90703129": [
                                "72088121": [
                                    "selectedUnitId": 35558398,
                                    "value": 50
                                ]
                            ]
                        ]
                    ]
                ],
                "41": [
                    "category": "Waste Management",
                    "type": "BASIC",
                    "answers": [
                        [
                            "49159850": [
                                "45524138": [
                                    "selectedUnitId": 47348901,
                                    "value": 50
                                ],
                                "92807513": [
                                    "selectedUnitId": 43575724,
                                    "value": 80
                                ],
                                "99276194": [
                                    "selectedUnitId": 16996483,
                                    "value": 10
                                ]
                            ]
                        ]
                    ]
                ],
                "42": [
                    "category": "Online Presence",
                    "type": "BASIC",
                    "answers": [
                        [
                            "23848645": [
                                "29779698": [
                                    "selectedUnitId": 68831389,
                                    "value": 1
                                ],
                                "54626077": [
                                    "selectedUnitId": 69117490,
                                    "value": 1
                                ],
                                "60714214": [
                                    "selectedUnitId": 85209685,
                                    "value": 1
                                ],
                                "64652074": [
                                    "selectedUnitId": 58682803,
                                    "value": 2
                                ],
                                "66145126": [
                                    "selectedUnitId": 46235466,
                                    "value": 2
                                ],
                                "68051320": [
                                    "selectedUnitId": 17419882,
                                    "value": 2
                                ]
                            ]
                        ]
                    ]
                ],
                "43": [
                    "category": "Remote Work",
                    "type": "BASIC",
                    "answers": [
                        [
                            "80747136": [
                                "68491275": [
                                    "selectedUnitId": 43828740,
                                    "value": 5
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]

      */
        print(parameter.toJSON())
        
//        WSManager.postRequest(url: url, param: parameter, resultType: ResponseModel<CarbonCalculateResponseModel>.self) { result, error in
//            response(result, error)
//        }
        
        WSManager.postRequestJSON(urlString: url, withParameter: parameter) { success, result in
            print(result)
        }
    }
    /*
     
     
    // MARK: -
    func getDocument(categoryName:String, response: @escaping (ResponseModel<BusinessDocsDocumentResponseDataModel>??, _ error: Error?) -> Void) {
        
        let urlString = ApiEnd().BUSINESS_GET_DOCUMENT + "?" + "categoryName=\(categoryName)"
        
        WSManager.getRequest(url: urlString, resultType: ResponseModel<BusinessDocsDocumentResponseDataModel>.self) { result, error in
            //  print(result)
            response(result, error)
        }
    }
    */
}
