//
//  PekoStoreHistoryListViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 13/03/24.
//

import UIKit
import SkeletonView

class PekoStoreHistoryListViewController: MainViewController {

    
    @IBOutlet weak var historytableView: UITableView!
    
    var fromDate = Date().last30Day()
    var toDate = Date()
//    
    var offset = 1
    var limit = 10
   // var categoryName = ""
    var isPageRefreshing:Bool = false
   
    var isSkeletonView:Bool = true
    var historyArray = [PekoStoreOrderListModel]()
    
    static func storyboardInstance() -> PekoStoreHistoryListViewController? {
        return AppStoryboards.PekoStore.instantiateViewController(identifier: "PekoStoreHistoryListViewController") as? PekoStoreHistoryListViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Order History")
        self.view.backgroundColor = .white
        
        self.historytableView.delegate = self
        self.historytableView.dataSource = self
        self.historytableView.separatorStyle = .none
        self.historytableView.backgroundColor = .clear
        
        self.historytableView.register(UINib(nibName: "PekoStoreHistoryListTableViewCell", bundle: nil), forCellReuseIdentifier: "PekoStoreHistoryListTableViewCell")
        // Do any additional setup after loading the view.
        
        self.historytableView.isUserInteractionEnabled = false
        self.getOrderHistoryList()
    }

    // MARK: -
    func getOrderHistoryList() {
        PekoStoreHistoryViewModel().getHisoryList(fromDate: self.fromDate!, toDate: self.toDate, searchText: "", offset: self.offset) { response, error in
            
            if error != nil {
                
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    self.historytableView.isUserInteractionEnabled = true
                    self.isSkeletonView = false
                    
                    self.historyArray.append(contentsOf: response?.data?.result ?? [PekoStoreOrderListModel]())
                    
                    if self.historyArray.count < response?.data?.totalData ?? 0 {
                        self.isPageRefreshing = false
                    }else{
                        self.isPageRefreshing = true
                    }
                    self.historytableView.reloadData()
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
    
}
// MARK: - UITableView
extension PekoStoreHistoryListViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSkeletonView {
            return 10
        }
        return self.historyArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PekoStoreHistoryListTableViewCell") as! PekoStoreHistoryListTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        if self.isSkeletonView {
            cell.containerView.showAnimatedGradientSkeleton()
        }else{
            cell.containerView.hideSkeleton()
            
            let model = self.historyArray[indexPath.row]
          //  print(model.order?.orderResponse)
            let dic = model.order?.orderResponse?.convertToDictionary()
            
            if let productArray = dic!["products"] as? [[String:Any]], let p_dic = productArray.first{
                if let name = p_dic["productName"] as? String {
                    cell.productNameLabel.text = name
                }
            }
            
            if (model.order?.ecomOrderStatus?.uppercased() == "COMPLETED") || (model.order?.ecomOrderStatus?.uppercased() == "CANCELLED") {
                cell.trackButton.setTitle("View", for: .normal)
            }else{
                cell.trackButton.setTitle("Track", for: .normal)
            }
            cell.deliveryLabel.text = "Delivery by -"
        }
        
        // PENDING,  CONFIRMED, ONPROGRESS, SHIPPED, COMPLETED, CANCELLED
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = PekoStoreHistoryDetailViewController.storyboardInstance(){
            vc.orderModel = self.historyArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: -
extension PekoStoreHistoryListViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.historytableView.contentOffset.y >= (self.historytableView.contentSize.height - self.historytableView.bounds.size.height)) {
            if !isPageRefreshing {
                isPageRefreshing = true
                self.offset += 1
                self.getOrderHistoryList()
            }
        }
    }
}
