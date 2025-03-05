//
//  TransactionsViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 04/01/23.
//

import UIKit
import Fastis
import SkeletonView

class TransactionsViewController: MainViewController {
    @IBOutlet weak var transactionTableView: UITableView!
//    @IBOutlet weak var filterLabel: UILabel!
  
    var transactionArray = [TransactionModel]()
    var searchArray = [TransactionModel]()
    
    var fromDate = Date().last30Day()
    var toDate = Date()
    
    var isSkeletonView:Bool = true
    
    var offset = 1
    var limit = 10
    var categoryName = ""
    var isPageRefreshing:Bool = false
    
    var iconArray = [
        "Telecom Payments":"icon_bills",
        "Utility Payments":"icon_bills",
        "Travel":"icon_eSIM",
        "Office Supplies":"icon_office_supplies",
        "Shipment Services":"icon_logistics",
        "Subscriptions":"icon_subscription_payments",
        "Gift Cards":"icon_gift_cards",
        "Office Address":"icon_office_space",
        "Softwares":"icon_subscription_payments",
        "Gift Cards/Vouchers":"icon_gift_cards",
        "Others":"icon_bills",
        "Mobile Topup":"icon_mobile_top_up"
    ]
    
    static func storyboardInstance() -> TransactionsViewController? {
        return AppStoryboards.Transactions.instantiateViewController(identifier: "TransactionsViewController") as? TransactionsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isNavigationTitle = true
        self.view.backgroundColor = .white
        self.setTitle(title: "Transaction")
        
        self.transactionTableView.delegate = self
        self.transactionTableView.dataSource = self
        self.transactionTableView.register(UINib(nibName: "TransactionsTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionsTableViewCell")
        
        self.transactionTableView.isUserInteractionEnabled = false
        
        // Do any additional setup after loading the view.
       // self.filterLabel.text = "Filter by Month"
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.transactionTableView.reloadData()
        self.offset = 1
        self.getTransaction()
    }
    // MARK: - Get Transaction
    func getTransaction() {
        TransactionsViewModel().getTransactionsDetails(fromDate: self.fromDate!, toDate: self.toDate, categoryName: self.categoryName, searchText: "", offset: self.offset, limit: 30) { response, error in
            if error != nil {
                
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    self.transactionTableView.isUserInteractionEnabled = true
                    self.isSkeletonView = false
                    
                    if self.offset == 1 {
                        self.transactionArray.removeAll()
                    }
                    let array = (response?.data?.result ?? [TransactionModel]()) //.reversed()
                    self.transactionArray.append(contentsOf: array)
                    self.searchArray = self.transactionArray // .reversed()
                  //  self.transactionTableView.reloadData()
                    
                    if self.transactionArray.count < response?.data?.totalData ?? 0 {
                        self.isPageRefreshing = false
                    }else{
                        self.isPageRefreshing = true
                    }
                    self.transactionTableView.reloadData()
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
    }
    // MARK: - Sort Button Click
    @IBAction func filterButtonClick(_ sender: Any) {
        /*
        if self.filterLabel.text == "Filter by Month" {
            let fastisController = FastisController(mode: .range)
            fastisController.title = "Choose range"
            fastisController.maximumDate = Date()
            fastisController.allowToChooseNilDate = true
            fastisController.shortcuts = [.lastWeek, .lastMonth]
            fastisController.dismissHandler = { action in
                switch action {
                case .done(let resultRange):
                    self.fromDate = resultRange?.fromDate ?? Date()
                    self.toDate = resultRange?.toDate ?? Date()
                    self.filterLabel.text = "Clear\nFilter"
                    self.getTransaction()
                    break
                case .cancel:
                    
                    break
                }
            }
            fastisController.present(above: self)
        }else{
            self.fromDate = Date()// .last30Day()
            self.toDate = Date()
            self.filterLabel.text = "Filter by Month"
            self.getTransaction()
        }
        */
        
    }
    // MARK: -
    @IBAction func monthButtonClick(_ sender: Any) {
        
    }
}
// MARK: -
extension TransactionsViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSkeletonView {
                return 10
        }
        return self.searchArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 77
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsTableViewCell") as! TransactionsTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        if self.isSkeletonView {
            cell.showAnimatedGradientSkeleton()
            
        }else{
            cell.hideSkeleton()
            
            let transaction = self.searchArray[indexPath.row]
            
            cell.iconImgView.image = UIImage(named: self.iconArray[transaction.transactionCategory ?? ""] ?? "")
            cell.dateLabel.text = transaction.date.formate(format: "MMMM dd, yyyy 'at' h:mm a") //formate(format: "MMMM dd, yyyy")
            
            let serviceProvider = transaction.serviceOperator?.serviceProvider ?? ""
            
            if serviceProvider.count == 0 {
                cell.paymentLabel.text = transaction.transactionCategory ?? ""
            }else{
                cell.paymentLabel.text = serviceProvider
            }
            
            
            
            let bill_amount = (transaction.order?.amountInUsd?.value ?? 0.0) // ?? "0.0").toDouble()
            let cashback_amount = (transaction.corporateCashback ?? "0.0").toDouble()
            
            cell.billAmountLabel.text = objUserSession.currency + (bill_amount.decimalPoints(point: 2))
            
            if cashback_amount == 0.0 {
                cell.cashbackLabel.text = ""
            }else{
                cell.cashbackLabel.text = objUserSession.currency + "+ " + (cashback_amount.decimalPoints())
            }
            
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let transactionVC = TransactionDetailViewController.storyboardInstance() {
            transactionVC.transactionModel = self.searchArray[indexPath.row]
            
            transactionVC.modalPresentationStyle = .overCurrentContext
            transactionVC.modalTransitionStyle = .crossDissolve
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController!.present(transactionVC, animated: false)
       
          //  self.present(transactionVC, animated: true)
        }
    }
}
extension TransactionsViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.self.transactionTableView.contentOffset.y >= (self.transactionTableView.contentSize.height - self.transactionTableView.bounds.size.height)) {
            if !isPageRefreshing {
                isPageRefreshing = true
                self.offset += 1
                self.getTransaction()
            }
        }
    }
    
}
