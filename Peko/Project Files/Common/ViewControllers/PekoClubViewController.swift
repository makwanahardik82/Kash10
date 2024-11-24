//
//  PekoClubViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 25/03/24.
//

import UIKit

class PekoClubViewController: UIViewController {

    static func storyboardInstance() -> PekoClubViewController? {
        return AppStoryboards.PekoClub.instantiateViewController(identifier: "PekoClubViewController") as? PekoClubViewController
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
