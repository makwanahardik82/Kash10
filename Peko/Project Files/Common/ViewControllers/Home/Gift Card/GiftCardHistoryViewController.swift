//
//  GiftCardHistoryViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 16/03/24.
//

import UIKit

class GiftCardHistoryViewController: MainViewController {

    @IBOutlet weak var historyTableView: UITableView!
   
    var fromDate = Date().addDays(day: -120)
    var toDate = Date()
    
    var isSkeletonView:Bool = true
    
    var offset = 1
    var limit = 10
  //  var categoryName = ""
    var isPageRefreshing:Bool = false
    
    var historyArray = [GiftCardHistoryModel]()
    
    static func storyboardInstance() -> GiftCardHistoryViewController? {
        return AppStoryboards.GiftCards.instantiateViewController(identifier: "GiftCardHistoryViewController") as? GiftCardHistoryViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Order History")
        self.view.backgroundColor = .white
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        self.historyTableView.backgroundColor = .clear
        historyTableView.separatorStyle = .none
        self.historyTableView.isUserInteractionEnabled = false
       
        self.getHistory()
        // Do any additional setup after loading the view.
    }
    // MARK: - Get Products
    func getHistory(){
        GiftCardsProductsViewModel().getHistory(fromDate: self.fromDate!, toDate: self.toDate, searchText: "", offset: self.offset, limit: self.limit){ response, error in
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    
                    if response?.data?.result != nil {
                        self.historyArray.append(contentsOf: response?.data?.result ?? [GiftCardHistoryModel]())
                    }
                    
                    if self.historyArray.count < response?.data?.totalData ?? 0 {
                        self.isPageRefreshing = false
                    }else{
                        self.isPageRefreshing = true
                    }
                    self.historyTableView.isUserInteractionEnabled = true
                    self.isSkeletonView = false
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
extension GiftCardHistoryViewController:UITableViewDelegate, UITableViewDataSource {
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GiftCardHistoryTableViewCell") as! GiftCardHistoryTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        if self.isSkeletonView {
            cell.view_1.showAnimatedGradientSkeleton()
        }else{
            cell.view_1.hideSkeleton()
            
            let model = self.historyArray[indexPath.row]
          
            let value = model.order?.orderResponse?.value
            cell.titleLabel.text = value?.name ?? ""
            cell.imgView.sd_setImage(with: URL(string: value?.image ?? ""))
            
            /*
            if let selectedCard = dic!["selectedCard"] as? [String:Any] {
                if let name = selectedCard["name"] as? String {
                    cell.titleLabel.text = name
                }
                if let image = selectedCard["image"] as? String {
                    cell.imgView.sd_setImage(with: URL(string: image))
                }
            }
            
            print(dic)
            
            
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
            */
            cell.deliveryLabel.text = "Delivery by -"
        }
        
        // PENDING,  CONFIRMED, ONPROGRESS, SHIPPED, COMPLETED, CANCELLED
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let vc = PekoStoreHistoryDetailViewController.storyboardInstance(){
//            vc.orderModel = self.historyArray[indexPath.row]
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
}

// MARK: -
extension GiftCardHistoryViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.historyTableView.contentOffset.y >= (self.historyTableView.contentSize.height - self.historyTableView.bounds.size.height)) {
            if !isPageRefreshing {
                isPageRefreshing = true
                self.offset += 1
                self.getHistory()
            }
        }
    }
}

// MARK: -
class GiftCardHistoryTableViewCell:UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var deliveryLabel: PekoLabel!
    
    @IBOutlet weak var view_1: UIView!
    @IBOutlet weak var titleLabel: PekoLabel!
}
