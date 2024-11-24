//
//  ManageBeneficiaryViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 21/02/24.
//

import UIKit

class ManageBeneficiaryViewController: MainViewController {

    @IBOutlet weak var beneficiaryTableView: UITableView!
   
    static func storyboardInstance() -> ManageBeneficiaryViewController? {
        return AppStoryboards.ManageBeneficiary.instantiateViewController(identifier: "ManageBeneficiaryViewController") as? ManageBeneficiaryViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        
        self.setTitle(title: "Manage Beneficiary")
        self.view.backgroundColor = .white
       
        beneficiaryTableView.backgroundColor = .clear
        beneficiaryTableView.separatorStyle = .none
        self.beneficiaryTableView.delegate = self
        self.beneficiaryTableView.dataSource = self
        self.beneficiaryTableView.register(UINib(nibName: "ManageBeneficiaryTableViewCell", bundle: nil), forCellReuseIdentifier: "ManageBeneficiaryTableViewCell")
        
        // Do any additional setup after loading the view.
    }
    
}
// MARK: - UITableView
extension ManageBeneficiaryViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageBeneficiaryTableViewCell") as! ManageBeneficiaryTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        
        return cell
    }
}
