//
//  PaymentPayNowViewController.swift
//  Peko India
//
//  Created by Hardik Makwana on 13/12/23.
//

import UIKit

class PaymentPayNowViewController: MainViewController {

    @IBOutlet weak var payNowTableView: UITableView!
    
    @IBOutlet var footerview: UIView!
    
    @IBOutlet weak var payNowButton: PekoButton!
    
    static func storyboardInstance() -> PaymentPayNowViewController? {
        return AppStoryboards.Payment.instantiateViewController(identifier: "PaymentPayNowViewController") as? PaymentPayNowViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: objPaymentManager!.screenTitle)
        self.view.backgroundColor = .white

        self.payNowTableView.register(UINib(nibName: "FinalPaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "FinalPaymentTableViewCell")
        self.payNowTableView.backgroundColor = .clear
        self.payNowTableView.separatorStyle = .none
        self.payNowTableView.delegate = self
        self.payNowTableView.dataSource = self
        
        self.payNowTableView.tableFooterView = self.footerview
        
        if objPaymentManager?.reviewPaymentType == .MobilePrepaidRecharge {
            self.backNavigationView?.bharatBillPayImgView.isHidden = true
        }else if objPaymentManager?.reviewPaymentType == .MobilePostpaidRecharge {
            self.backNavigationView?.bharatBillPayImgView.isHidden = false
        }else if objPaymentManager?.reviewPaymentType == .UtilityBills {
            self.backNavigationView?.bharatBillPayImgView.isHidden = false
        }
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Pay Now Button
    @IBAction func payNowButtonClick(_ sender: Any) {
   
        if let paymentVC = PaymentReviewsViewController.storyboardInstance() {
            self.navigationController?.pushViewController(paymentVC, animated: true)
        }
    }
    
    // MARK: -
    @objc func editButtonClick(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension PaymentPayNowViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return objPaymentManager!.billSummaryArray.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        }else{
            return 35
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FinalPaymentTableViewCell") as! FinalPaymentTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            cell.nameLabel.text = objUtilityBillsManager!.billDataModel?.bill?.customerName ?? ""
            cell.numberLabel.text = objUtilityBillsManager!.billDataModel?.bill?.billNumber?.value ?? ""

            cell.amountLabel.text = objUserSession.currency + (objUtilityBillsManager!.billDataModel?.bill?.amount!.value ?? "")
            cell.editButton.addTarget(self, action: #selector(editButtonClick(sender: )), for: .touchUpInside)
            return cell
        }else{
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            cell.accessoryType = .none
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
            cell.textLabel?.font = AppFonts.Regular.size(size: 14)
            cell.detailTextLabel?.font = AppFonts.Regular.size(size: 14)
            cell.textLabel?.textColor = UIColor(named: "747474")
            cell.detailTextLabel?.textColor = UIColor(named: "747474")
          
            let dic = objPaymentManager!.billSummaryArray[indexPath.row]
            
            cell.textLabel?.text = dic["title"]
            cell.detailTextLabel?.text = dic["detail"]
            
            return cell
        }
    }
}
