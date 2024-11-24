//
//  PekoStoreHistoryDetailViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 13/03/24.
//

import UIKit


class PekoStoreHistoryDetailViewController: MainViewController {

    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var deliveryLabel: PekoLabel!
    @IBOutlet weak var productNameLabel: PekoLabel!
    @IBOutlet weak var orderIdLabel: PekoLabel!
    @IBOutlet weak var priceLabel: PekoLabel!
    var orderModel:PekoStoreOrderListModel?
    var orderDetailModel:PekoStoreOrderDetailModel?
    
    @IBOutlet weak var statusTableView: UITableView!
   
    var shipmentStatusArray = [PekoStoreShipmentStatusModel]()
   
    var statusArray = [
        [
            "status":"CONFIRMED",
            "name":"Order Placed",
            "icon":"icon_order_placed"
        ],
        [
            "status":"ONPROGRESS",
            "name":"In Progress",
            "icon":"icon_order_shipped"
        ],
        [
            "status":"SHIPPED",
            "name":"Order Shipped",
            "icon":"icon_order_out_delivered"
        ],
        [
            "status":"COMPLETED",
            "name":"Delivered",
            "icon":"icon_order_delivered"
        ]
    ]
    
   // ecomOrderStatus will be ,  , , , , CANCELLED
    
    static func storyboardInstance() -> PekoStoreHistoryDetailViewController? {
        return AppStoryboards.PekoStore.instantiateViewController(identifier: "PekoStoreHistoryDetailViewController") as? PekoStoreHistoryDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isBackNavigationBarView = true
        self.setTitle(title: "Order Details")
        self.view.backgroundColor = .white
       
        self.statusTableView.delegate = self
        self.statusTableView.dataSource = self
        self.statusTableView.backgroundColor = .clear
        self.statusTableView.separatorStyle = .none
        self.statusTableView.isHidden = true
        self.getOrderDetail()
        // Do any additional setup after loading the view.
    }
    
    // MARK: -
    func getOrderDetail() {
        HPProgressHUD.show()
        let o_id =  self.orderModel?.order?.id ?? 0
        PekoStoreHistoryViewModel().getOrderDetail(o_id: o_id) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    
                    self.orderDetailModel = response?.data
                    
                    self.deliveryLabel.text = "Delivery by -"
                    self.orderIdLabel.text = "Order ID: \(self.orderDetailModel?.corporateTxnId ?? "")"
                    
                    if self.orderDetailModel?.orderResponse?.products?.count != 0 {
                        let productModel = self.orderDetailModel?.orderResponse?.products?.first
                        self.productNameLabel.text = productModel?.productName ?? ""
                        self.priceLabel.text = objUserSession.currency + (productModel?.totalPrice?.value.withCommas() ?? "")
                        
                        self.productImgView.sd_setImage(with: URL(string: productModel?.image ?? ""))
                        self.shipmentStatusArray = self.orderDetailModel?.shipmentStatus ?? [PekoStoreShipmentStatusModel]()
                        
                        
                        self.statusTableView.isHidden = false
                        self.statusTableView.reloadData()
                    }else{
                        self.showAlert(title: "", message: "Product not found")
                    }
                    
                    
                    /*
                    self.historytableView.isUserInteractionEnabled = true
                    self.isSkeletonView = false
                    
                    self.historyArray.append(contentsOf: response?.data?.result ?? [PekoStoreOrderListModel]())
                    
                    if self.historyArray.count < response?.data?.totalData ?? 0 {
                        self.isPageRefreshing = false
                    }else{
                        self.isPageRefreshing = true
                    }
                    self.historytableView.reloadData()
                    */
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
// MARK: -
extension PekoStoreHistoryDetailViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statusArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderStatusTableViewCell") as! OrderStatusTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let dic = self.statusArray[indexPath.row]
        
        cell.imgView.image = UIImage(named: dic["icon"]!)
        cell.timeDateLabel.text = ""
        cell.orderStatusLabel.text = dic["name"]
        
        cell.circleView.backgroundColor = .gray
        cell.lineView.backgroundColor =  .gray.withAlphaComponent(0.5)
        
        if indexPath.row == 0 {
            if (self.orderDetailModel?.ecomOrderStatus ?? "") == "CANCELLED" {
                cell.orderStatusLabel.text = "CANCELLED".capitalized
            }else if (self.orderDetailModel?.ecomOrderStatus ?? "") == "PENDING" {
                cell.circleView.backgroundColor = UIColor(red: 0, green: 187/255.0, blue: 30/255.0, alpha: 1) //rgba(0, 187, 30, 1)
                cell.lineView.backgroundColor = UIColor(red: 216/255.0, green: 1, blue: 220/255.0, alpha: 1)
               
            }
        }
        
        if (self.shipmentStatusArray.count) > indexPath.row{
            cell.circleView.backgroundColor = UIColor(red: 0, green: 187/255.0, blue: 30/255.0, alpha: 1) //rgba(0, 187, 30, 1)
            cell.lineView.backgroundColor = UIColor(red: 216/255.0, green: 1, blue: 220/255.0, alpha: 1)
            let statusModel = self.shipmentStatusArray[indexPath.row]
            
            cell.timeDateLabel.text = statusModel.UpdateDateTime?.dateFromISO8601()?.shortDate
            
        }
        if indexPath.row == (self.statusArray.count - 1){
            cell.lineView.isHidden = true
        }else{
            cell.lineView.isHidden = false
        }
        
//        "status":"PENDING",
//        "name":"Pending",
//        "icon":""
//        
        return cell
    }
}


// MARK: -

class OrderStatusTableViewCell:UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var timeDateLabel: PekoLabel!
    
    @IBOutlet weak var orderStatusLabel: PekoLabel!
    
    @IBOutlet weak var detailLabel: PekoLabel!
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var circleView: UIView!
}
