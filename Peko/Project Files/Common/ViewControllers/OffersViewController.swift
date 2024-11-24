//
//  OffersViewController.swift
//  Kash10
//
//  Created by Hardik Makwana on 23/06/24.
//

import UIKit

class OffersViewController: UIViewController {

    static func storyboardInstance() -> OffersViewController? {
        return AppStoryboards.Offers.instantiateViewController(identifier: "OffersViewController") as? OffersViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
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
