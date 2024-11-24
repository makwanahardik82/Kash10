//
//  AirTicketCancelpolicyViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 20/03/24.
//

import UIKit

class AirTicketCancelpolicyViewController: MainViewController {

    static func storyboardInstance() -> AirTicketCancelpolicyViewController? {
        return AppStoryboards.Air_Ticket.instantiateViewController(identifier: "AirTicketCancelpolicyViewController") as? AirTicketCancelpolicyViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.view.backgroundColor = .white
        self.setTitle(title: "Cancellation & Rescheduling Policy")
      
        
        // Do any additional setup after loading the view.
    }
    

}
