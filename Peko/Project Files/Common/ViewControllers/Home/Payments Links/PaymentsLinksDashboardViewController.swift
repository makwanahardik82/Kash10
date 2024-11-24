//
//  PaymentsLinksDashboardViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 21/05/23.
//

import UIKit

import Fastis

class PaymentsLinksDashboardViewController: MainViewController {

    @IBOutlet weak var paymentLinkTableView: UITableView!
    @IBOutlet weak var searchTxt: UITextField!
    
    var fromDate = Date()// .last30Day()
    var toDate = Date()
    
    var paymentLinkHistoryArray = [PaymentLinkHistoryModel]()
    var searchArray = [PaymentLinkHistoryModel]()
    
    static func storyboardInstance() -> PaymentsLinksDashboardViewController? {
        return AppStoryboards.PaymentsLinks.instantiateViewController(identifier: "PaymentsLinksDashboardViewController") as? PaymentsLinksDashboardViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Payments Links")
       
        self.paymentLinkTableView.delegate = self
        self.paymentLinkTableView.dataSource = self
        self.paymentLinkTableView.backgroundColor = .clear
        self.paymentLinkTableView.separatorStyle = .none
   //     self.paymentLinkTableView.register(UINib(nibName: "PaymentsLinksHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentsLinksHistoryTableViewCell")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getTransaction()
    }
   
    // MARK: - Filter Button Click
    @IBAction func filterButtonClick(_ sender: Any) {
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
              //  self.filterLabel.text = "Clear\nFilter"
                self.getTransaction()
                break
            case .cancel:
                
                break
            }
        }
        fastisController.present(above: self)
    }
    
    // MARK: - Create link 
    @IBAction func createLinkButtonClick(_ sender: Any) {
        if let createLinkVC = PaymentsLinksCreateViewController.storyboardInstance(){
            self.navigationController?.pushViewController(createLinkVC, animated: true)
        }
    }
    
    // MARK: - Get Transaction
    func getTransaction() {
        
        HPProgressHUD.show()
        PaymentLinkViewModel().getHistory(fromDate: self.fromDate, toDate: self.toDate) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.success, status == true {
                DispatchQueue.main.async {
                    self.paymentLinkHistoryArray = response?.data ?? [PaymentLinkHistoryModel]()
                    self.searchArray = self.paymentLinkHistoryArray//.reversed()
                    self.paymentLinkTableView.reloadData()
                }
            }else{
//                var msg = ""
//                if response?.message != nil {
//                    msg = response?.message ?? ""
//                }else if response?.error?.count != nil {
//                    msg = response?.error ?? ""
//                }
//                self.showAlert(title: "", message: msg)
            }
        }
    }
    
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }
}
extension PaymentsLinksDashboardViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentsLinksHistoryTableViewCell") as! PaymentsLinksHistoryTableViewCell
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let dic = self.searchArray[indexPath.row]
        cell.dateLabel.text = dic.date.shortDate
       
        if let responseDic = dic.responseDictionary["QuickLinkResponse"] as? [String:Any] {
            if let status = responseDic["Status"] as? String{
                
                if status.lowercased() == "success" {
                    cell.statusLabel.text = "Completed"
                    cell.statusLabel.textColor = AppColors.greenThemeColor
                }else{
                    cell.statusLabel.text = "Pending"
                    cell.statusLabel.textColor = .gray
                }
                cell.statusLabel.text = status
            }
            if let URL = responseDic["URL"] as? String{
                cell.linkLabel.text = URL
            }
//            if let URL = responseDic["URL"] as? String{
//                cell.linkLabel.text = URL
//
//            }
        }else{
            cell.linkLabel.text = "-"
            cell.statusLabel.text = "-"
        }
       
       // print(dic.sentPayloadDictionary)
        
        if dic.quickLinkRequestModel != nil {
            cell.paymentIDLabel.text = "\(dic.quickLinkRequestModel?.StoreID?.value ?? "0")"
            cell.amountLabel.text = objUserSession.currency + "\(dic.quickLinkRequestModel?.Details?.Amount?.value ?? 0)" // ?? ""
        }
        
        /*
        if let sentPayloadDictionary = dic.sentPayloadDictionary["QuickLinkRequest"] as? [String:Any] {
            print(sentPayloadDictionary)
            if let StoreID = sentPayloadDictionary["StoreID"] as? String {
                cell.paymentIDLabel.text = "\(StoreID)"
            }
            if let sentPayloadDictionary = sentPayloadDictionary["Details"] as? [String:Any] {
                if let amount = sentPayloadDictionary["Amount"] as? String{
                    cell.amountLabel.text = objUserSession.currency + " " + "\(amount)"
                }
            }
        }
        */
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = self.searchArray[indexPath.row]
       
        var url = ""
        if let responseDic = dic.responseDictionary["QuickLinkResponse"] as? [String:Any] {
            if let URL = responseDic["URL"] as? String{
                url = URL
            }
        }
        guard let value = dic.quickLinkRequestModel else { return }
        
        let detail = value.Details
        let dateString = dic.createdAt?.components(separatedBy: "T").first
        let amount = "\(dic.quickLinkRequestModel?.Details?.Amount?.value ?? 0)"
        let request = PaymentsLinksRequest(amount: amount, email: detail?.Email ?? "", phoneNumber: detail?.Phone ?? "", createDate: dateString, expiryDate: "", note: "", noExpiry: true, imageBase64String: "")
      
        if let shareVC = PaymentsLinksShareViewController.storyboardInstance() {
            shareVC.request = request
            shareVC.paymentLink = url
            self.navigationController?.pushViewController(shareVC, animated: true)
        }
    }
}


class PaymentsLinksHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var paymentIDLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
