//
//  LogisticsSavedAddressViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 14/09/23.
//

import UIKit

class LogisticsSavedAddressViewController: UIViewController {

    static func storyboardInstance() -> LogisticsSavedAddressViewController? {
        return AppStoryboards.Logistics.instantiateViewController(identifier: "LogisticsSavedAddressViewController") as? LogisticsSavedAddressViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
