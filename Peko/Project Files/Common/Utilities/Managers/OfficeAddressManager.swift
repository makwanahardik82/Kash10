//
//  OfficeAddressManager.swift
//  Peko
//
//  Created by Hardik Makwana on 16/11/23.
//

import UIKit

var objOfficeAddressManager:OfficeAddressManager?

class OfficeAddressManager: NSObject {
    
    static let sharedInstance = OfficeAddressManager()
    
    var selectedPlanModel:WorkspacePlanModel?
    var request:WorkspaceRequest?
    
}
