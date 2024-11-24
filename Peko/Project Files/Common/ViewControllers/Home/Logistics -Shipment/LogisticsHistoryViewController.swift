//
//  LogisticsHistoryViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 15/03/24.
//

import UIKit

class LogisticsHistoryViewController: MainViewController {

    @IBOutlet weak var historyTableView: UITableView!
  
    var offset = 1
    var limit = 10
    
    var isPageRefreshing:Bool = false
   
    var isSkeletonView:Bool = true
    var historyArray = [PekoStoreOrderListModel]()
    
    static func storyboardInstance() -> LogisticsHistoryViewController? {
        return AppStoryboards.Logistics.instantiateViewController(identifier: "LogisticsHistoryViewController") as? LogisticsHistoryViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.isBackNavigationBarView = true
        self.view.backgroundColor = .white
        self.setTitle(title: "Order History")

        self.historyTableView.delegate = self
        self.historyTableView.dataSource = self
        self.historyTableView.separatorStyle = .none
        self.historyTableView.backgroundColor = .clear
        
        self.historyTableView.register(UINib(nibName: "PekoStoreHistoryListTableViewCell", bundle: nil), forCellReuseIdentifier: "PekoStoreHistoryListTableViewCell")
        // Do any additional setup after loading the view.
        
        self.historyTableView.isUserInteractionEnabled = false
        self.getOrderHistoryList()
    }

    // MARK: -
    func getOrderHistoryList() {
        LogisticsViewModel().getHistory(page: offset, limit: self.limit) { response, error in
            if error != nil {
                
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    self.historyTableView.isUserInteractionEnabled = true
                    self.isSkeletonView = false
                    
                    self.historyArray.append(contentsOf: response?.data?.result ?? [PekoStoreOrderListModel]())
                    
                    if self.historyArray.count < response?.data?.totalData ?? 0 {
                        self.isPageRefreshing = false
                    }else{
                        self.isPageRefreshing = true
                    }
                    self.historyTableView.reloadData()
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
extension LogisticsHistoryViewController:UITableViewDelegate, UITableViewDataSource {
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
            
            if let shipmentDetails = dic!["shipmentDetails"] as? [String:Any]{
                if let name = shipmentDetails["Comments"] as? String { // , let pickupDate = shipmentDetails["PickupDate"] as? String {
                    cell.productNameLabel.text = name
//                    let dateString = pickupDate.replacingOccurrences(of: "/Date(", with: "").replacingOccurrences(of: ")/", with: "")
//                    let date = Date(timeIntervalSince1970: TimeInterval(dateString)!)
//                    
//                    cell.productNameLabel.attributedText = NSMutableAttributedString().color(.black, name, font: .medium(size: 16), 4).color(.darkGray, "\nPickup Date" + date.formate(format: "dd MMM, yyyy"), font: .regular(size: 12), 4)
//                    
//                    if let shipments = shipmentDetails["Shipments"] as? [Dictionary<String, Any>], let dic = shipments.first {
//                        
//                    }
                    
                }
            }
            
            /*
            if (model.order?.ecomOrderStatus?.uppercased() == "COMPLETED") || (model.order?.ecomOrderStatus?.uppercased() == "CANCELLED") {
                cell.trackButton.setTitle("View", for: .normal)
            }else{
                cell.trackButton.setTitle("Track", for: .normal)
            }
            */
            cell.trackButton.setTitle("Track", for: .normal)
            cell.deliveryLabel.text = "Order ID - " + (model.order?.corporateTxnId ?? "")
            cell.deliveryLabel.textColor = .darkGray
            
//            cell.deliveryLabel.text = "Delivery by -"
        }
        
        // PENDING,  CONFIRMED, ONPROGRESS, SHIPPED, COMPLETED, CANCELLED
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = LogisticsTrackOrderViewController.storyboardInstance(){
            vc.orderModel = self.historyArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
