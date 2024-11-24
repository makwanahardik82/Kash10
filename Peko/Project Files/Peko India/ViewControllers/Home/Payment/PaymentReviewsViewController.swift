//
//  PaymentReviewViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 11/12/23.
//

import UIKit


class PaymentReviewsViewController: MainViewController {

    @IBOutlet var headerView: UIView!
    @IBOutlet var footerView: UIView!
    
    @IBOutlet weak var walletBalanceLabel: UILabel!
    
    @IBOutlet weak var reviewTableView: UITableView!
   
    @IBOutlet weak var pekoWalletRadioImgView: UIImageView!
    @IBOutlet weak var bankAccountRadioImgView: UIImageView!
    @IBOutlet weak var debitCardRadioImgView: UIImageView!
    
    var selectedPaymentType = SelectedPaymentType(rawValue: 0)
   
    var amount = 0.0
    var discount = 0.0
    var charges = 0.0
    var gst = 0.0
    var total_amount = 0.0
    
    static func storyboardInstance() -> PaymentReviewsViewController? {
        return AppStoryboards.Payment.instantiateViewController(identifier: "PaymentReviewsViewController") as? PaymentReviewsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isBackNavigationBarView = true
      
        self.view.backgroundColor = .white
        self.setTitle(title: objPaymentManager!.screenTitle)
       
        self.setPaymentData()
        
        self.reviewTableView.delegate = self
        self.reviewTableView.dataSource = self
        self.reviewTableView.separatorStyle = .none
        self.reviewTableView.backgroundColor = .clear
        
        self.reviewTableView.tableHeaderView = self.headerView
        self.reviewTableView.tableFooterView = self.footerView
       
        self.walletBalanceLabel.attributedText = NSMutableAttributedString().color(AppColors.blackThemeColor!, "Peko Wallet Balance ", font: AppFonts.Regular.size(size: 12)).color(AppColors.blackThemeColor!, objUserSession.currency + objUserSession.balance.withCommas(), font: AppFonts.SemiBold.size(size: 12))
        // Do any additional setup after loading the view.
    }
    func setPaymentData(){
        
        
        switch objPaymentManager!.reviewPaymentType {
        case .MobilePrepaidRecharge:
            self.amount = objPaymentManager?.price ?? 0.0
            break
            
        case .MobilePostpaidRecharge:
           
            self.amount = Double(objMobilePrepaidManager?.postpaidBillDataModel?.bill?.amount?.value ?? "0.0")!
            
            
            
            break
        case .UtilityBills:
            self.amount = Double(objUtilityBillsManager!.billDataModel?.bill?.amount?.value ?? "0.0")!
            break
             /*
//        case .none:
//            break
        case .UtilityElectricity:
            self.amount = Double(objMobilePrepaidManager?.postpaidBillDataModel?.bill?.amount?.value ?? "0.0")!
        //    self.setTitle(title:"Electricity")
            break
            */
        default:
           
            break
        }
        
        self.total_amount = (self.amount + self.charges + self.gst) - self.discount
    }
    
    // MARK: - Payment Options
    @IBAction func paymentOptionButtonClick(_ sender: UIButton) {
        self.selectedPaymentType = SelectedPaymentType(rawValue: sender.tag)
        
        //icon_payment_radio_unselected
        // icon_payment_radio_selected
        
        self.pekoWalletRadioImgView.image = UIImage(named: "icon_payment_radio_unselected")
        self.bankAccountRadioImgView.image = UIImage(named: "icon_payment_radio_unselected")
        self.debitCardRadioImgView.image = UIImage(named: "icon_payment_radio_unselected")
        
        if sender.tag == 1 {
            self.pekoWalletRadioImgView.image = UIImage(named: "icon_payment_radio_selected")
        }else if sender.tag == 2 {
            self.bankAccountRadioImgView.image = UIImage(named: "icon_payment_radio_selected")
        }else if sender.tag == 3 {
            self.debitCardRadioImgView.image = UIImage(named: "icon_payment_radio_selected")
        }
    }
    
    // MARK: - PayNow Button Click
    @IBAction func payNowButtonClick(_ sender: Any) {
   
        if self.selectedPaymentType == .None {
            self.showAlert(title: "", message: "Please select payment option")
        }else{
            if self.selectedPaymentType == .PekoWallet {
                self.makePaymentFromWallet()
            }else if self.selectedPaymentType == .BankAccount {
                self.makePaymentFromBank()
            }else if self.selectedPaymentType == .Card {
               // self.createOrder()
            }
        }
    }
    
    // MARK: - Wallet
    func makePaymentFromWallet(){
        switch objPaymentManager!.reviewPaymentType {
        case .MobilePrepaidRecharge:
            self.makeMobilePrepaidRechargePayment()
            break
        case .MobilePostpaidRecharge:
            self.makeMobilePostpaidRechargePayment()
            break
        case .UtilityBills:
            self.makeUtilityBills()
            break
       case .none:
            break
        }
    }
    // MARK: - Wallet
    func makePaymentFromBank(){
        self.showAlert(title: "", message: "Coming soon")
    }
    
    // MARK: - Mobile Prepaid
    func makeMobilePrepaidRechargePayment(){
        HPProgressHUD.show()
        MobilePrepaidViewModel().prepaidRechargePayment(amount: total_amount) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    print(response?.data)
                    
                    objPaymentManager?.transactionID = response?.data?.TransactionReference ?? ""
                    
                    let date = (response?.data?.datetime ?? "").dateFromISO8601()
                 
                    objPaymentManager?.dateString = date!.formate(format: "dd MMMM’yy")
                    objPaymentManager?.timeString = date!.formate(format: "hh:mm a")
                    
                    objPaymentManager?.service = "Prepaid Recharge "
                    objPaymentManager?.consumerNumber = objMobilePrepaidManager?.getPlanRequest?.mobileNumber ?? ""
                    objPaymentManager?.serviceProvider = objMobilePrepaidManager?.getPlanRequest?.serviceProvider ?? ""
                    
                    objPaymentManager?.price = self.total_amount
                    objPaymentManager?.voucher = 0.0
                    objPaymentManager?.totalAmount = self.total_amount
                    
                    self.goToSuccessView()
                }
            }else{
                var msg = ""
                if response?.message != nil {
                    msg = response?.message ?? ""
                }
                self.showAlert(title: "", message: msg)
                HPProgressHUD.hide()
            }
        }
    }
    // MARK: - Mobile PostPaid // 
    func makeMobilePostpaidRechargePayment() {
        HPProgressHUD.show()
        MobilePrepaidViewModel().postpaidRechargePayment(amount: total_amount) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    print(response?.data)
                    
                    objPaymentManager?.transactionID = response?.data?.data?.transactionId ?? ""
                    
                    let date = (response?.data?.datetime ?? "").dateFromISO8601()
                 
                    objPaymentManager?.dateString = date!.formate(format: "dd MMMM’yy")
                    objPaymentManager?.timeString = date!.formate(format: "hh:mm a")
                    
                    objPaymentManager?.service = "Postpaid Recharge "
                    objPaymentManager?.consumerNumber = objMobilePrepaidManager?.getPlanRequest?.mobileNumber ?? ""
                    objPaymentManager?.serviceProvider = objMobilePrepaidManager?.getPlanRequest?.serviceProvider ?? ""
                    
                    objPaymentManager?.price = self.total_amount
                    objPaymentManager?.voucher = 0.0
                    objPaymentManager?.totalAmount = self.total_amount
                    
                    self.goToSuccessView()
                }
            }else{
                var msg = ""
                if response?.message != nil {
                    msg = response?.message ?? ""
                }
                self.showAlert(title: "", message: msg)
                HPProgressHUD.hide()
            }
        }
    }
    
    // MARK: - Utility Bills
    func makeUtilityBills(){
        HPProgressHUD.show()
        UtilityBillsViewModel().paymentBill(amount: total_amount) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    print(response?.data)
                    
                    objPaymentManager?.transactionID = response?.data?.data?.transactionId ?? ""
                    
                    let date = (response?.data?.datetime ?? "").dateFromISO8601()
                 
                    objPaymentManager?.dateString = date!.formate(format: "dd MMMM’yy")
                    objPaymentManager?.timeString = date!.formate(format: "hh:mm a")
                    
                    objPaymentManager?.consumerNumber = objUtilityBillsManager!.consumerNumber ?? ""
                    objPaymentManager?.serviceProvider = objUtilityBillsManager!.serviceProvideName
                    
                    objPaymentManager?.price = self.total_amount
                    objPaymentManager?.voucher = 0.0
                    objPaymentManager?.totalAmount = self.total_amount
                    
                    self.goToSuccessView()
                }
            }else{
                var msg = ""
                if response?.message != nil {
                    msg = response?.message ?? ""
                }else if response?.error != nil {
                    msg = response?.error ?? ""
                }
                self.showAlert(title: "", message: msg)
                HPProgressHUD.hide()
            }
        }
    }
    // MARK: - Go to Success
    func goToSuccessView(){
        if let successVC = PaymentSuccessViewController.storyboardInstance() {
            
            var attr1:NSMutableAttributedString?
            var attr2:NSMutableAttributedString?
            
            switch objPaymentManager!.reviewPaymentType {
            case .MobilePrepaidRecharge:
                
                attr1 = NSMutableAttributedString().color(AppColors.blackThemeColor!, objUserSession.currency + self.total_amount.withCommas() + " Paid Successfully", font: AppFonts.Bold.size(size: 24), 5, .center)
                
                attr2 = NSMutableAttributedString().color(AppColors.blackThemeColor!, "Your top-up for ", font: AppFonts.Regular.size(size: 14), 5, .center).color(AppColors.blackThemeColor!, "+91 " + (objMobilePrepaidManager?.getPlanRequest?.mobileNumber ?? "") , font: AppFonts.SemiBold.size(size: 14), 5, .center).color(AppColors.blackThemeColor!, " is successful", font: AppFonts.Regular.size(size: 14), 5, .center)
                
                break
            case .MobilePostpaidRecharge:
                attr1 = NSMutableAttributedString().color(AppColors.blackThemeColor!, objUserSession.currency + self.total_amount.withCommas() + " Paid Successfully", font: AppFonts.Bold.size(size: 24), 5, .center)
                
                attr2 = NSMutableAttributedString().color(AppColors.blackThemeColor!, "Your top-up for ", font: AppFonts.Regular.size(size: 14), 5, .center).color(AppColors.blackThemeColor!, "+91 " + (objMobilePrepaidManager?.getPlanRequest?.mobileNumber ?? "") , font: AppFonts.SemiBold.size(size: 14), 5, .center).color(AppColors.blackThemeColor!, " is successful", font: AppFonts.Regular.size(size: 14), 5, .center)
                
                break
            case .UtilityBills:
                attr1 = NSMutableAttributedString().color(AppColors.blackThemeColor!, objUserSession.currency + self.total_amount.withCommas() + " Paid Successfully", font: AppFonts.Bold.size(size: 24), 5, .center)
                var tmp = ""
                if objUtilityBillsManager!.selectedUtilityBillType == .Electricity {
                    tmp = "Electricity Bill payment"
                    objPaymentManager?.service = "Electricity"
                }else if objUtilityBillsManager!.selectedUtilityBillType == .Broadband {
                    tmp = "Broadband Bill payment"
                    objPaymentManager?.service = "Broadband"
                    
                }else if objUtilityBillsManager!.selectedUtilityBillType == .PipedGas {
                    tmp = "Piped Gas Bill payment"
                    objPaymentManager?.service = "Piped Gas"
                    
                }else if objUtilityBillsManager!.selectedUtilityBillType == .Water {
                    tmp = "Water Bill payment"
                    objPaymentManager?.service = "Water"
                    
                }else if objUtilityBillsManager!.selectedUtilityBillType == .EducationFee {
                    tmp = "Education Fee payment"
                    objPaymentManager?.service = "Education Fee"
                    
                }else if objUtilityBillsManager!.selectedUtilityBillType == .Landline {
                    tmp = "Landline payment"
                    objPaymentManager?.service = "Landline"
                    
                }else if objUtilityBillsManager!.selectedUtilityBillType == .LPGCylinder {
                    tmp = "LPG Cylinder payment"
                    objPaymentManager?.service = "LPG Cylinder"
                    
                }
                attr2 = NSMutableAttributedString().color(AppColors.blackThemeColor!, "Your ", font: AppFonts.Regular.size(size: 14), 5, .center).color(AppColors.blackThemeColor!, tmp, font: AppFonts.SemiBold.size(size: 14), 5, .center).color(AppColors.blackThemeColor!, " is successful", font: AppFonts.Regular.size(size: 14), 5, .center)
                
                break
            case .none:
                break
            
            }
            successVC.titleAttributeString = attr1
            successVC.detailAttributeString = attr2
          //  successVC.screenTitle = self.getTitle()
            self.navigationController?.pushViewController(successVC, animated: true)
        }
    }
}
extension PaymentReviewsViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        view.backgroundColor = .clear
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: screenWidth - 40, height: 30))
        label.font = AppFonts.SemiBold.size(size: 14)
        label.textColor = AppColors.blackThemeColor!
        
        view.addSubview(label)
        
        if section == 0 {
            label.text = "TITLE_BILL_SUMMARY".localizeString()
        }else{
            label.text = "TITLE_AMOUNT_SUMMARY".localizeString()
        }
        
        return view
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return objPaymentManager!.billSummaryArray.count
        }else{
            return 4
        }
      //  return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        cell.textLabel?.font = AppFonts.Regular.size(size: 14)
        cell.detailTextLabel?.font = AppFonts.Regular.size(size: 14)
        
        if indexPath.section == 0 {
            cell.textLabel?.textColor = UIColor(named: "747474")
            cell.detailTextLabel?.textColor = UIColor(named: "747474")
           
            let dic = objPaymentManager!.billSummaryArray[indexPath.row]
            
            cell.textLabel?.text = dic["title"]
            cell.detailTextLabel?.text = dic["detail"]
            
        }else{
            cell.textLabel?.textColor = UIColor(named: "555555")
            cell.detailTextLabel?.textColor = UIColor(named: "555555")
            
            if indexPath.row == 0 {
                cell.textLabel?.text = "Amount"
                cell.detailTextLabel?.text = objUserSession.currency + self.amount.withCommas()
            }else if indexPath.row == 1 {
                cell.textLabel?.text = "Discount"
                cell.detailTextLabel?.text = objUserSession.currency + self.discount.withCommas()
            }else if indexPath.row == 2 {
                cell.textLabel?.text = "GST"
                cell.detailTextLabel?.text = objUserSession.currency + self.gst.withCommas()
            }else if indexPath.row == 3 {
                cell.textLabel?.text = "Total"
                cell.detailTextLabel?.text = objUserSession.currency + self.total_amount.withCommas()
                
                cell.textLabel?.font = AppFonts.SemiBold.size(size: 16)
                cell.detailTextLabel?.font = AppFonts.SemiBold.size(size: 16)
               
            }
        }
        
        return cell
    }
}
