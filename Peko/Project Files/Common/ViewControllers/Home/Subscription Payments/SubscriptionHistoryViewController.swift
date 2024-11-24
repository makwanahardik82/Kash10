//
//  SubscriptionHistoryViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 03/03/24.
//

import UIKit
import SkeletonView
import CodableFirebase

class SubscriptionHistoryViewController: MainViewController {

    @IBOutlet weak var histroyTableView: UITableView!
   
    var isShowSkeletonView = true
    var offset = 1
    var isPageRefreshing:Bool = false
   
    var historyArray = [SubscriptionHistoryOrderResponseModel]()
    
    
    var fromDate = Date().last30Day()
    var toDate = Date()
    
    static func storyboardInstance() -> SubscriptionHistoryViewController? {
        return AppStoryboards.SubscriptionPayments.instantiateViewController(identifier: "SubscriptionHistoryViewController") as? SubscriptionHistoryViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Subscriptions")
        self.view.backgroundColor = .white
      
        self.histroyTableView.delegate = self
        self.histroyTableView.dataSource = self
        self.histroyTableView.backgroundColor = .clear
        self.histroyTableView.separatorStyle = .none
        
        self.histroyTableView.isUserInteractionEnabled = false
        //self.backNavigationView?.subscriptionHistoryButton.isHidden = false
    
        self.getOrderHistory()
    }
    // MARK: - Get History
    func getOrderHistory(){
        
        SubscriptionPaymentsViewModel().getOrderHistory(startDate: fromDate!, endDate: toDate, offset: self.offset, limit: 10, search: "") { response, error in
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                
            }else if let status = response??.status, status == true {
                DispatchQueue.main.async {
                   
                    self.histroyTableView.isUserInteractionEnabled = true
                    self.isShowSkeletonView = false
                    self.historyArray.append(contentsOf: response??.data?.result ?? [SubscriptionHistoryOrderResponseModel]())
                    self.histroyTableView.reloadData()
                    
                    if self.historyArray.count < response??.data?.totalData ?? 0 {
                        self.isPageRefreshing = false
                    }else{
                        self.isPageRefreshing = true
                    }
                }
            }else{
                var msg = ""
                if response??.message != nil {
                    msg = response??.message ?? ""
                }else if response??.error?.count != nil {
                    msg = response??.error ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
    }
}
extension SubscriptionHistoryViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isShowSkeletonView {
            return 10
        }
        return self.historyArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 154
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionHistoryTableViewCell") as! SubscriptionHistoryTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        if isShowSkeletonView {
            cell.containerView.showAnimatedGradientSkeleton()
        }else{
            cell.containerView.hideSkeleton()
            let model = self.historyArray[indexPath.row]
          
            let base = model.order?.baseProduct
            let type = (model.order?.subscriptionType ?? "").capitalized
            
            cell.nameLabel.text = base?.name ?? ""
            //  + " Licences: 1 Licence"
            cell.billingCycleLabel.text = "Billing Cycle: " + (type)
            cell.companyNameLabel.text = "Company : -"
           
            if let product = model.order?.product {
                let price = objUserSession.currency + (product.price?.value ?? "0.0").toDouble().withCommas()
                cell.amountLabel.text = price
                
                cell.currentPlanLabel.text = "Current Plan: " + price + "/" + (type)
                cell.logoImgView.sd_setImage(with: URL(string: (product.productImage ?? "")), placeholderImage: nil)
              
            }else if let product = model.order?.software {
                let price = (model.order?.amountInINR?.value ?? "0.0").toDouble().withCommas()
               
                cell.amountLabel.text = price
                
                cell.currentPlanLabel.text = "Current Plan: " + price + "/" + (type)
                cell.logoImgView.sd_setImage(with: URL(string: (product.image ?? "")), placeholderImage: nil)
              
            }
            
            
         
          
        }
        
        return cell
    }
}
// MARK: - SubscriptionHistory
class SubscriptionHistoryTableViewCell:UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logoImgView: UIImageView!
    
    @IBOutlet weak var nameLabel: PekoLabel!
    
    @IBOutlet weak var currentPlanLabel: PekoLabel!
    
    @IBOutlet weak var billingCycleLabel: PekoLabel!
    
    @IBOutlet weak var companyNameLabel: PekoLabel!
    
    @IBOutlet weak var amountLabel: PekoLabel!
}
