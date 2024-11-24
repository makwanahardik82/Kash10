//
//  PayrollAddEmployeeManager.swift
//  Peko
//
//  Created by Hardik Makwana on 21/06/24.
//

import UIKit


var objPayrollAddEmployeeManager:PayrollAddEmployeeManager?

class PayrollAddEmployeeManager: NSObject {
    
    static let sharedInstance = PayrollAddEmployeeManager()
   
    var personalInfoRequest:PayrolAddEmployeePersonalInfoRequest?
    var empInfoRequest:PayrolAddEmployeeInfoRequest?
    var salaryInfoRequest:PayrolAddEmployeeSalaryInfoRequest?
    var officialDocumentRequest:PayrolAddEmployeeOfficialDocumentsRequest?
    var bankInfoRequest:PayrolAddEmployeeBankInfoRequest?
    
}
