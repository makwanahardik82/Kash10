//
//  SavedBankViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 21/02/24.
//

import UIKit

class SavedBankViewController: MainViewController {

    @IBOutlet weak var banktableView: UITableView!
  
    @IBOutlet var headerView: UIView!
    
    @IBOutlet weak var noDataView: UIView!
    var isSkeletonView = true
    
    var bankListArray = [BankModel]()
    
    static func storyboardInstance() -> SavedBankViewController? {
        return AppStoryboards.Account.instantiateViewController(identifier: "SavedBankViewController") as? SavedBankViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Saved Bank Accounts")
        self.view.backgroundColor = .white
       
        self.noDataView.isHidden = true
        
        self.banktableView.delegate = self
        self.banktableView.dataSource = self
        self.banktableView.backgroundColor = .clear
        self.banktableView.separatorStyle = .none
        self.banktableView.register(UINib(nibName: "SavedTableViewCell", bundle: nil), forCellReuseIdentifier: "SavedTableViewCell")
        banktableView.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getBanks()
    }
    
    // MARK: - Address
    func getBanks(){
        
        ProfileViewModel().getBankList { response, error in
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response.status, status == true {
                DispatchQueue.main.async {
                    
                    self.bankListArray = response.data?.data ?? [BankModel]()
                   //  self.addreessTableView.tableFooterView = self.footerView
                    self.banktableView.isUserInteractionEnabled = true
                    self.isSkeletonView = false
                    self.banktableView.reloadData()
                    
                    if self.bankListArray.count == 0 {
                        self.noDataView.isHidden = false
                        self.banktableView.tableHeaderView = nil
                    }else{
                        self.noDataView.isHidden = true
                        self.banktableView.tableHeaderView = self.headerView
                    }
                }
            }else{
                var msg = ""
                if response.message != nil {
                    msg = response.message
                    ?? ""
                }else if response.error?.count != nil {
                    msg = response.error ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
    }
    
    // MARK: -
    @IBAction func addBankAccountButtonClick(_ sender: Any) {
        if let addVC = AddBankViewController.storyboardInstance(){
            self.navigationController?.pushViewController(addVC, animated: true)
        }
    }
    
}
// MARK: -
extension SavedBankViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSkeletonView {
            return 10
        }
        return self.bankListArray.count
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 93
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedTableViewCell") as! SavedTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        if self.isSkeletonView {
            cell.view_1.showAnimatedGradientSkeleton()
        }else{
            cell.view_1.hideSkeleton()
           
            let bank = self.bankListArray[indexPath.row]
            cell.titleLabel.text = bank.bankName ?? ""
            cell.subTitleLabel.text = bank.accountNumber
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
