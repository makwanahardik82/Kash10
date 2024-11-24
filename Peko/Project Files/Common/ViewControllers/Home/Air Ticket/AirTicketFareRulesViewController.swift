//
//  AirTicketFareRulesViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 17/06/23.
//

import UIKit

class AirTicketFareRulesViewController: MainViewController {

    @IBOutlet weak var fareRuleTableView: UITableView!
    
//    var offerId:String = ""
//    var conversationId:String = ""
//
    static func storyboardInstance() -> AirTicketFareRulesViewController? {
        return AppStoryboards.Air_Ticket.instantiateViewController(identifier: "AirTicketFareRulesViewController") as? AirTicketFareRulesViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Baggage Details and Fare Rules")
      
        self.fareRuleTableView.backgroundColor = .clear
        self.fareRuleTableView.delegate = self
        self.fareRuleTableView.dataSource = self
        
        self.getFareDetails()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
    }
// MARK: -
    func getFareDetails() {
        
        HPProgressHUD.show()
        AirTicketViewModel().getFareRules() { response, error in
            HPProgressHUD.hide()
            
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    print(response)
                    
//                    objAirTicketManager?.conversationId = response?.data?.conversationId ?? ""
//                    self.airTicketArray = response?.data?.data ?? [AirportSearchDataModel]()
//                    self.listTableView.reloadData()
                }
            }else{
                var msg = ""
                if response?.message != nil {
                    msg = response?.message ?? ""
                }else if response?.error?.count != nil {
                    msg = response?.error ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
        
        
        
        HPProgressHUD.show()
        AirTicketViewModel().searchTicket() { response, error in
            HPProgressHUD.hide()
            print(response)
            
        }
        
        
    }
    
    // MARK: -
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }

}
extension AirTicketFareRulesViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableCell(withIdentifier: "FareHeaderCell")
        view?.backgroundColor = .clear
        
        let label = view?.viewWithTag(101) as! UILabel
        
        if section == 0 {
            label.text = "Baggage Details"
        }else if section == 1 {
            label.text = "Fare Details"
        }else if section == 2 {
            label.text = "Fare Rules"
        }
        
        return view
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default
                                   , reuseIdentifier: "Cell")
        cell.backgroundColor = .clear
        
        return cell
        
    }
}
