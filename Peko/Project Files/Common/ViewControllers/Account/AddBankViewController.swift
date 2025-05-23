//
//  AddBankViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 02/04/24.
//

import UIKit

class AddBankViewController: MainViewController {

    static func storyboardInstance() -> AddBankViewController? {
        return AppStoryboards.Account.instantiateViewController(identifier: "AddBankViewController") as? AddBankViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isBackNavigationBarView = true
        self.setTitle(title: "Add a bank account")
        self.view.backgroundColor = .white
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
