//
//  LogisticsTrackOrderViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 29/02/24.
//

import UIKit


class LogisticsTrackOrderViewController: MainViewController {

    @IBOutlet weak var senderAddressLabel: PekoLabel!
    @IBOutlet weak var receiverAddressLabel: PekoLabel!
    
    @IBOutlet weak var trackTableView: UITableView!
    @IBOutlet weak var trackingNumberLabel: PekoLabel!
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var footerView: UIView!
    
    var orderModel:PekoStoreOrderListModel?
    var orderDetailModel:LogisticsShipmentTrackModel?
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
    /*
    var array = [
        [
            "time":"04:00 PM - Thu 22 Feb ",
            "title":"Order Placed",
            "detail":"On cancellation at least 72 hours before departure",
            "icon":"icon_logistics_order_placed"
        ],
        [
            "time":"04:00 PM - Mon 11 Mar",
            "title":"Packaging",
            "detail":"On cancellation 2 - 72 hours before departure",
            "icon":"icon_logistics_packaging"
        ],
        [
            "time":"04:00 PM - Thu 14 Mar",
            "title":"Shipped",
            "detail":"On cancellation 2 - 72 hours before departure",
            "icon":"icon_logistics_shipped"
        ],
        [
            "time":"08:00 PM - Thu 14 Mar",
            "title":"Delivered",
            "detail":"On cancellation 2 - 72 hours before departure",
            "icon":"icon_logistics_delivered"
        ]
    ]
    */
    static func storyboardInstance() -> LogisticsTrackOrderViewController? {
        return AppStoryboards.Logistics.instantiateViewController(identifier: "LogisticsTrackOrderViewController") as? LogisticsTrackOrderViewController
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Track Order")
        self.view.backgroundColor = .white
        
        self.trackTableView.backgroundColor = .clear
        self.trackTableView.tableHeaderView = self.headerView
     //   self.trackTableView.tableFooterView = self.footerView
        self.trackTableView.separatorStyle = .none
        self.trackTableView.delegate = self
        self.trackTableView.dataSource = self
        self.trackTableView.isHidden = true
        
        self.trackOrder()
        // Do any additional setup after loading the view.
    }
    
    // MARK: -
    func trackOrder() {
        
        HPProgressHUD.show()
        let o_id = orderModel?.order?.providerId ?? ""
        self.trackingNumberLabel.attributedText = NSMutableAttributedString().color(.black, "Tracking Number: ", font: .regular(size: 12)).color(.redButtonColor, o_id, font: .regular(size: 12))
        LogisticsViewModel().trackLogistics(order_id: o_id) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    self.trackTableView.isHidden = false
                    self.shipmentStatusArray = self.orderDetailModel?.shipmentStatus ?? [PekoStoreShipmentStatusModel]()
                    
                    
                     let dic = response?.data?.orderResponse?.convertToDictionary()
                    print(dic)
                    
                    if let shipmentDetails = dic!["shipmentDetails"] as? [String:Any], let array = shipmentDetails["Shipments"] as? [[String:Any]], let Shipments = array.first {
                        
                        
                        if let sender = Shipments["Shipper"] as? [String:Any], let PartyAddress = sender["PartyAddress"] as? [String:Any] {
                            self.senderAddressLabel.text = self.convertToAddressFormat(PickupAddress: PartyAddress)
                        }
                        if let reciever = Shipments["Consignee"] as? [String:Any], let PartyAddress = reciever["PartyAddress"] as? [String:Any] {
                            self.receiverAddressLabel.text = self.convertToAddressFormat(PickupAddress: PartyAddress)
                        }
                       // print(PickupAddress)
                        
                    }
                    
                    self.trackTableView.reloadData()
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
    func convertToAddressFormat(PickupAddress:[String:Any]) -> String {
        var array:[String] = [PickupAddress["Line1"] as? String ?? "", PickupAddress["Line2"] as? String ?? "", PickupAddress["Line3"] as? String ?? "", PickupAddress["City"] as? String ?? ""]
        
        array = array.filter({ $0 != ""})
        return array.joined(separator: ", ")
    }
    // MARK: -
    @IBAction func downloadButtonClick(_ sender: Any) {
        
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
   
    }
    
}
extension LogisticsTrackOrderViewController:UITableViewDelegate, UITableViewDataSource {
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
        
        /*
        if indexPath.row == 0 {
            if (self.orderDetailModel?.ecomOrderStatus ?? "") == "CANCELLED" {
                cell.orderStatusLabel.text = "CANCELLED".capitalized
            }else if (self.orderDetailModel?.ecomOrderStatus ?? "") == "PENDING" {
                cell.circleView.backgroundColor = UIColor(red: 0, green: 187/255.0, blue: 30/255.0, alpha: 1) //rgba(0, 187, 30, 1)
                cell.lineView.backgroundColor = UIColor(red: 216/255.0, green: 1, blue: 220/255.0, alpha: 1)
               
            }
        }
        */
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
