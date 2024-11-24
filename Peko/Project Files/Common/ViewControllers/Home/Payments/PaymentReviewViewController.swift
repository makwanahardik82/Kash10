//
//  PaymentReviewViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 12/02/24.
//

import UIKit

import StripePaymentSheet

enum PaymentPayNow: Int {
    
    case MobileRecharge = 0
    case PekoStore
    case AirTicket
    case SubscriptionPayment
    case Logistics
    case License
    case OfficeAddress
    case GiftCard
    case HotelBooking
    case PhoneBill
    case UtilityBill
    case DocumentAttestation
    case ZeroCarbon
    case eSIM
}

class PaymentReviewViewController: MainViewController {

    @IBOutlet weak var paymentTableView: UITableView!
    @IBOutlet var footerView: UIView!
    @IBOutlet var headerView: UIView!
   
    @IBOutlet var hotelHeaderView: UIView!
   
    @IBOutlet weak var pekoWalletRadioImgView: UIImageView!
    @IBOutlet weak var bankAccountRadioImgView: UIImageView!
    @IBOutlet weak var debitCardRadioImgView: UIImageView!
   
    @IBOutlet weak var usePekoBalanceButton: UIButton!
    @IBOutlet weak var useBalanceLabel: UILabel!
    @IBOutlet weak var usePekoBalanceContainerView: UIView!
    
    @IBOutlet weak var pekoWalletBalanceLabel: UILabel!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var bankInfoContainerView: UIView!
    
    @IBOutlet weak var hotelNameLabel: PekoLabel!
    
    @IBOutlet weak var hotelRoomDesclabel: PekoLabel!
    
    var selectedPaymentType = SelectedPaymentType(rawValue: 0)
   
    var paymentPayNow:PaymentPayNow = .PekoStore
    
    var titleArray = ["Subtotal", "Discount", "Tax", "Delivery", "Estimated Total" ]
    var amountArray = [String]()
    var charges = 0.0
    var total = 0.0
    var discount = 0.0
    var tax = 0.0
    var finalAmount = 0.0
    
    var accessKey = ""
  
//    var dapiPaymentResponse:[String:Any]?
//    var dapiAmount:String = "0"
//   
   
    static func storyboardInstance() -> PaymentReviewViewController? {
        return AppStoryboards.Payment.instantiateViewController(identifier: "PaymentReviewViewController") as? PaymentReviewViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.isBackNavigationBarView = true
      
        self.paymentTableView.tableFooterView = self.footerView
        self.paymentTableView.tableHeaderView = self.headerView
       
        self.useBalanceLabel.attributedText = NSMutableAttributedString().color(.black, "Use your Kash10 Balance ", font: AppFonts.Regular.size(size: 14)).color(.black, objUserSession.currency + "\(objUserSession.balance.withCommas())", font: AppFonts.Bold.size(size: 14))
    
        self.pekoWalletBalanceLabel.attributedText = NSMutableAttributedString().color(.black, "Wallet Balance ", font: AppFonts.Regular.size(size: 14)).color(.black, objUserSession.currency + "\(objUserSession.balance.withCommas())", font: AppFonts.Bold.size(size: 14))
        
        if self.paymentPayNow == .MobileRecharge {
            
            let currency = objMobileRechargeManager?.currencySymbol ?? objUserSession.currency
            discount = 0.0
            charges = 0.0
            tax = 0.0
            total = objMobileRechargeManager?.selectedPlanModel?.max?.faceValue?.value ?? 0.0
            
            finalAmount = (total + charges + tax) - discount
          
            titleArray = ["Subtotal", "Discount", "Taxes and fees", "Estimated Total" ]
            amountArray = [currency + total.withCommas(), currency + discount.withCommas(), currency + tax.withCommas(), currency + finalAmount.withCommas()]
            
        }else if self.paymentPayNow == .License {
            self.setTitle(title: "License Renewal")
            self.accessKey = "dubai_ded"
            
            discount = 0.0
            charges = 0.0
            tax = objLicenseRenewalManager?.limitDataModel?.surcharge?.toDouble() ?? 0.0
            total = objLicenseRenewalManager?.balanceDataModel?.Amount?.toDouble() ?? 0.0
            
            finalAmount = (total + charges + tax) - discount
          
            titleArray = ["Subtotal", "Discount", "Taxes and fees", "Estimated Total" ]
            amountArray = [objUserSession.currency + total.withCommas(), objUserSession.currency + discount.withCommas(), objUserSession.currency + tax.withCommas(), objUserSession.currency + finalAmount.withCommas()]
            
        }else {
            self.paymentTableView.isHidden = true
            
            if self.paymentPayNow == .GiftCard {
            
                self.setTitle(title: "Gift Cards")
              //  total = Double(objSubscriptionPaymentManager?.plan?.price ?? "0.0")!
                total = (objGiftCardManager?.amount ?? 0.0) * Double((objGiftCardManager?.quality ?? 0))
                self.accessKey = "youGotAGift"
                
            }else if self.paymentPayNow == .HotelBooking {
                self.setTitle(title: "Hotel Booking")
               
                let tmpArray = objHotelBookingManager?.selectedRooms.compactMap({ $0.roomRate?.netAmount ?? 0.0 })
                total = tmpArray!.reduce(0, +).toUSD().toDouble()
                self.accessKey = "hotels_api"
                
            }else if self.paymentPayNow == .PhoneBill {
                self.setTitle(title: "Bill Payments")
                
                if objPhoneBillsManager?.phoneBillType == .DU_Postpaid || objPhoneBillsManager?.phoneBillType == .Etisalat_Postpaid {
                    total = objPhoneBillsManager?.balanceDataModel?.dueBalanceInAed?.toDouble() ?? 0.0
                }else{
                    total = objPhoneBillsManager?.phoneBillRequest?.amount?.toDouble() ?? 0.0
                }
                self.accessKey = objPhoneBillsManager?.limitDataModel?.accessKey ?? ""
               
                
            }else if self.paymentPayNow == .UtilityBill {
                
                self.setTitle(title: "Bill Payments")
                
                if objUtilityPaymentManager?.utilityPaymentType == .Salik || objUtilityPaymentManager?.utilityPaymentType == .Nol_Card{
                    total = (objUtilityPaymentManager?.utilityPaymentRequest?.amount ?? "0.0").toDouble()
                }else{
                    total = ((objUtilityPaymentManager?.balanceDataModel?.dueBalanceInAed ?? "0.0")?.toDouble())!
                }
                
                self.accessKey = objUtilityPaymentManager?.limitDataModel?.accessKey ?? ""
            }else if self.paymentPayNow == .SubscriptionPayment {
            
                self.setTitle(title: "Subscription Payments")
                total = Double(objSubscriptionPaymentManager?.plan?.price ?? "0.0")!
                self.accessKey = "subscription_payments"
                
            }else if self.paymentPayNow == .OfficeAddress {
               
                self.setTitle(title: "Office Address")
                total = objOfficeAddressManager?.selectedPlanModel?.price?.toDouble() ?? 0.0
                self.accessKey = "workspace"
                
            }else if self.paymentPayNow == .DocumentAttestation {
                self.setTitle(title: "Document Attestation")
             //   total = objDocumentAttestationManager?.priceModel?.actualPrice?.value ?? 0.0
                self.accessKey = "document_attestation"
                
            }else if self.paymentPayNow == .PekoStore {
              
                self.setTitle(title: "Office Supplies")
                total = (objPekoStoreManager?.cartDetailModel?.itemsTotalAmount?.value ?? 0.0)
                self.accessKey = "ecommerce"
                
            }else if self.paymentPayNow == .ZeroCarbon {

                self.setTitle(title: "Zero Carbon")
                total = objCarbonManager?.co2AmountInAED ?? 0.0
                self.accessKey = "carbon_footprint"
                
            }else if self.paymentPayNow == .Logistics{
                self.setTitle(title: "Logistics")
                self.accessKey = "shipment_services"
                if objShareManager.appTarget == .PekoUAE {
                    charges =  objLogisticsManager?.calculateRateResponseModel?.TaxAmount ?? 0.0
                    total = objLogisticsManager?.calculateRateResponseModel?.TotalAmount ?? 0.0
                }else if objShareManager.appTarget == .PekoIndia {
                    charges = 0.0
                    total = objLogisticsManager?.calculateRateResponseIndiaModel?.charges?.value ?? 0.0
                }
            }else if self.paymentPayNow == .AirTicket {
                self.setTitle(title: "Air Tickets")
                self.accessKey = "travelApi_airline"
                
                let fare = objAirTicketManager?.selectedAirlinesDataModel?.fare
                total = (fare?.baseFare?.value ?? 0.0) + (fare?.customerAdditionalFareInfo?.transactionFeeEarned?.value ?? 0.0)
    
            }
            else if self.paymentPayNow == .eSIM {
                self.setTitle(title: "Travel eSIM")
                self.accessKey = "e_sim"
                
              //  total = ((objeSIMManager?.selectedeSimPackage?.price?.value ?? 0.0) * (objeSIMManager?.usdToAed ?? 0.0))
                total = (objeSIMManager?.selectedeSimPackage?.price?.value ?? 0.0) 
              
            }
            self.getSurCharges()
        }
        
      
        self.paymentTableView.delegate = self
        self.paymentTableView.dataSource = self
        self.paymentTableView.backgroundColor = .clear
        self.paymentTableView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    func getSurCharges(){
        self.calculateTotal(surAmount:0.0)
        /*
        HPProgressHUD.show()
        
        CommonViewModel().getSurcharge(amount: total, accessKey: self.accessKey) { response, error in
            HPProgressHUD.hide()
            print(response)
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                self.calculateTotal(surAmount:0.0)
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    self.calculateTotal(surAmount: response?.data?.surcharge?.value.toDouble() ?? 0.0)
                }
            }else{
                var msg = ""
                if response?.message != nil {
                    msg = response?.message ?? ""
                }else if response?.error?.count != nil {
                    msg = response?.error ?? ""
                }
                self.showAlert(title: "", message: msg)
                self.calculateTotal(surAmount:0.0)
            }
        }
        */
    }
    
    func calculateTotal(surAmount:Double){
        tax = surAmount // sur.surcharge?.value.toDouble() ?? 0.0
        charges = 0.0
        discount = 0.0
        finalAmount = (total + charges + tax) - discount
        
        if self.paymentPayNow == .PhoneBill {
           
             var service = ""
             if objPhoneBillsManager?.phoneBillType == .DU_Postpaid || objPhoneBillsManager?.phoneBillType == .Etisalat_Postpaid {
                 service = "Postpaid Recharge"
             }else{
                 service = "Prepaid Recharge"
             }
            
             titleArray = ["Bill Summary", "Service Provider", "Mobile Number", "Service", "Amount Summary", "Amount", "Discount", "VAT", "Total"]
             self.amountArray = ["", objPhoneBillsManager?.limitDataModel?.serviceProvider ?? "", objPhoneBillsManager?.phoneBillRequest?.number ?? "", service, "", objUserSession.currency + (total.withCommas()), objUserSession.currency + discount.withCommas(), objUserSession.currency + tax.withCommas(), objUserSession.currency + finalAmount.withCommas()]
             
         }else if self.paymentPayNow == .UtilityBill {
           
             let service = "Utility Bill"
           
             let dic = Constants.utilityPaymentArray[objUtilityPaymentManager?.utilityPaymentType?.rawValue ?? 0]
             let servicePorvider = dic["title"]!
            
             titleArray = ["Bill Summary", "Service Provider", "Account Number", "Service", "Amount Summary", "Amount", "Discount", "VAT", "Total"]
            
             self.amountArray = ["", servicePorvider, objUtilityPaymentManager?.utilityPaymentRequest?.acoountNumber ?? "", service, "", objUserSession.currency + (total.withCommas()), objUserSession.currency + discount.withCommas(), objUserSession.currency + tax.withCommas(), objUserSession.currency + finalAmount.withCommas()]
             
         }else if self.paymentPayNow == .SubscriptionPayment {
            
            self.amountArray = [objUserSession.currency + total.withCommas(), objUserSession.currency + discount.withCommas(), objUserSession.currency + tax.withCommas(), objUserSession.currency + charges.withCommas(), objUserSession.currency + finalAmount.withCommas()]
            
        }else if self.paymentPayNow == .GiftCard {
          
            self.amountArray = [objUserSession.currency + total.withCommas(), objUserSession.currency + discount.withCommas(), objUserSession.currency + tax.withCommas(), objUserSession.currency + charges.withCommas(), objUserSession.currency + finalAmount.withCommas()]
            
        }else if self.paymentPayNow == .HotelBooking {
            self.setTitle(title: "Hotel Booking")
           
            titleArray = ["Subtotal", "Discount", "Taxes and fees", "Estimated Total" ]
            
            amountArray = [objUserSession.currency + (total.withCommas()), objUserSession.currency + (discount.withCommas()), objUserSession.currency + (tax.withCommas()), objUserSession.currency + (finalAmount.withCommas())]
           
            self.paymentTableView.tableHeaderView = self.hotelHeaderView
            
            let hotelInfo = objHotelBookingManager!.hotelListData?.propertyInfo
            
            self.hotelNameLabel.text = hotelInfo?.hotelName ?? ""
            self.hotelRoomDesclabel.text = "" //
            
        }else if self.paymentPayNow == .OfficeAddress {
            self.setTitle(title: "Office Address")
          
            titleArray = ["Subtotal", "Discount", "Taxes and fees", "Estimated Total" ]
            amountArray = [objUserSession.currency + total.withCommas(), objUserSession.currency + discount.withCommas(), objUserSession.currency + tax.withCommas(), objUserSession.currency + finalAmount.withCommas()]
            
        }else if self.paymentPayNow == .DocumentAttestation {
            self.setTitle(title: "Document Attestation")
          
            titleArray = ["Subtotal", "Discount", "Taxes and fees", "Estimated Total" ]
            amountArray = [objUserSession.currency + total.withCommas(), objUserSession.currency + discount.withCommas(), objUserSession.currency + tax.withCommas(), objUserSession.currency + finalAmount.withCommas()]
            
        }else if self.paymentPayNow == .PekoStore {
            self.setTitle(title: "Office Supplies")
           
            charges =  (objPekoStoreManager?.cartDetailModel?.shippingCharge?.value ?? 0.0)
         
            finalAmount = (total + charges + tax) - discount
          
            titleArray = ["Subtotal", "Discount", "Taxes and fees", "Shipping Charge", "Estimated Total" ]
            
            amountArray = [objUserSession.currency + total.withCommas(), objUserSession.currency + discount.withCommas(), objUserSession.currency + tax.withCommas(), objUserSession.currency + charges.withCommas(), objUserSession.currency + finalAmount.withCommas()]
            
        }else if self.paymentPayNow == .ZeroCarbon {
            self.setTitle(title: "Zero Carbon")
            
            finalAmount = (total + charges + tax
                           + (objAirTicketManager?.addOnsAmount ?? 0.0)) - discount
          
            titleArray = ["Project Name", "CO₂ Offset", "Subtotal", "Discount", "Taxes and fees", "Add-ons", "Estimated Total" ]
         
            amountArray = [objCarbonManager?.selectedProjectModel?.name ?? "", "\((objCarbonManager?.co2Tons ?? 0.0).rounded().decimalPoints(point: 1)) tons" , objUserSession.currency + total.withCommas(), objUserSession.currency + discount.withCommas(), objUserSession.currency + tax.withCommas(), objUserSession.currency +  ((objAirTicketManager?.addOnsAmount ?? 0.0)?.withCommas())!, objUserSession.currency + finalAmount.withCommas()]
            
        }else if self.paymentPayNow == .Logistics{
           
            if objShareManager.appTarget == .PekoUAE {
                charges =  objLogisticsManager?.calculateRateResponseModel?.TaxAmount ?? 0.0
                // total = objLogisticsManager?.calculateRateResponseModel?.TotalAmount ?? 0.0
            }else if objShareManager.appTarget == .PekoIndia {
                charges = 0.0
            }
       
            finalAmount = (total + charges + tax) - discount
          
            titleArray = ["Subtotal", "Discount", "Taxes and fees", "Estimated Total" ]
            
            amountArray = [objUserSession.currency + total.withCommas(), objUserSession.currency + discount.withCommas(), objUserSession.currency + tax.withCommas(), objUserSession.currency + finalAmount.withCommas()]
            
        }else if self.paymentPayNow == .AirTicket {
            let fare = objAirTicketManager?.selectedAirlinesDataModel?.fare
          
            charges = (fare?.totalTax?.value ?? 0.0)
            
            discount = (fare?.customerAdditionalFareInfo?.discount?.value ?? 0.0)
           
            finalAmount = (total + charges + tax
                           + (objAirTicketManager?.addOnsAmount ?? 0.0)) - discount
          
            titleArray = ["Subtotal", "Discount", "Taxes and fees", "Add-ons", "Estimated Total" ]
         
            amountArray = [objUserSession.currency + total.withCommas(), objUserSession.currency + discount.withCommas(), objUserSession.currency + tax.withCommas(), objUserSession.currency +  ((objAirTicketManager?.addOnsAmount ?? 0.0)?.withCommas())!, objUserSession.currency + finalAmount.withCommas()]
       
        }
        else if self.paymentPayNow == .eSIM {
            
            finalAmount = total + charges + tax
         
            titleArray = ["Subtotal", "Discount", "Taxes and fees", "Estimated Total" ]
         
            amountArray = [objUserSession.currency + total.withCommas(), objUserSession.currency + discount.withCommas(), objUserSession.currency + tax.withCommas(), objUserSession.currency + finalAmount.withCommas()]
            
        }
        
        self.paymentTableView.isHidden = false
        self.paymentTableView.reloadData()
    }
    // MARK: - Payment Options
    @IBAction func paymentOptionButtonClick(_ sender: UIButton) {
        self.selectedPaymentType = SelectedPaymentType(rawValue: sender.tag)
        
        self.pekoWalletRadioImgView.image = UIImage(named: "icon_payment_radio_unselected")
        self.bankAccountRadioImgView.image = UIImage(named: "icon_payment_radio_unselected")
        self.debitCardRadioImgView.image = UIImage(named: "icon_payment_radio_unselected")
        
        if sender.tag == 1 {
            if self.finalAmount <= objUserSession.balance {
                self.pekoWalletRadioImgView.image = UIImage(named: "icon_payment_radio_selected")
            }else{
                self.showAlert(title: "", message: "Your Kash10 Wallet has insufficient funds.") //Please top-up or use internet banking with existing Kash10 Wallet balance
                self.usePekoBalanceContainerView.isHidden = false
            }
        }else if sender.tag == 2 {
            self.bankAccountRadioImgView.image = UIImage(named: "icon_payment_radio_selected")
        }else if sender.tag == 3 {
            
            self.debitCardRadioImgView.image = UIImage(named: "icon_payment_radio_selected")
        }
    }
    // MARK: - Use Peko Balance
    @IBAction func usePekoBalanceButtonClick(_ sender: Any) {
        self.usePekoBalanceButton.isSelected = !self.usePekoBalanceButton.isSelected
    }
    // MARK: - PayNow Button Click
    @IBAction func payNowButtonClick(_ sender: Any) {
   
        if self.selectedPaymentType == .None {
            self.showAlert(title: "", message: "Please select payment option")
        }else{
            if self.selectedPaymentType == .PekoWallet {
                self.makeQuickPayment()
            }else if self.selectedPaymentType == .BankAccount {
                if let vc = CreditCardDetailsViewController.storyboardInstance() {
                    vc.finalAmount = finalAmount
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else if self.selectedPaymentType == .Card {
                self.makeStripePayment()
            }
        }
    }
    // MARK: -
    // MARK: - Quick Payment
    func makeQuickPayment(){
        
        if self.paymentPayNow == .MobileRecharge {
            self.mobileRechargePayment()
        }else if self.paymentPayNow == .PekoStore {
            self.pekoStorePayment()
        }else if self.paymentPayNow == .AirTicket {
            self.bookAirTicket()
        }else if self.paymentPayNow == .SubscriptionPayment {
            DispatchQueue.main.async {
                self.subscriptionPayment()
            }
        }else if self.paymentPayNow == .License {
            self.licensePayment()
        }else if self.paymentPayNow == .Logistics {
            self.logisticsPayment()
        }else if self.paymentPayNow == .GiftCard {
            self.giftCardPayment()
        }else if self.paymentPayNow == .HotelBooking {
            self.hotelBooking()
        }else if self.paymentPayNow == .PhoneBill {
            self.phoneBill()
        }else if self.paymentPayNow == .UtilityBill {
            self.utilityBills()
        }else if self.paymentPayNow == .OfficeAddress {
            self.officeAddressPayment()
        }else if self.paymentPayNow == .ZeroCarbon {
            self.zeroCarbon()
        }else if self.paymentPayNow == .eSIM {
            self.eSimPayment()
        }else if self.paymentPayNow == .DocumentAttestation {
            self.documentAttestation()
        }
    }
    
    // MARK: - Mobile Recharge
    func mobileRechargePayment(){
        
        HPProgressHUD.show()
        MobileRechargeModelView().paymentMobileRecharge(amount: finalAmount) { response, error in
            HPProgressHUD.hide()
            print(response)
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.success, status == true {
                DispatchQueue.main.async {
                    objMobileRechargeManager?.paymentResponseModel = response?.OrderReceipt
                    self.goToTransactionView()
                }
            }else{
                var msg = ""
                if response?.message != nil {
                    msg = response?.message ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
        
    }
    
    
    // MARK: - GIFT CARD
    func giftCardPayment(){
        HPProgressHUD.show()
        GiftCardsProductsViewModel().orderGiftCard(amount: finalAmount) { response, error  in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status as? Bool, status == true {
                DispatchQueue.main.async {
                    self.goToSuccessVC()
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
    
    
    
    
    // MARK: - SubscriptionPayment
    func subscriptionPayment(){
       
        HPProgressHUD.show()
        SubscriptionPaymentsViewModel().subscriptionPayment(amount:finalAmount) { response, error in
            HPProgressHUD.hide()
            print(response)
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response??.status, status == true {
                DispatchQueue.main.async {
                    objSubscriptionPaymentManager?.paymentResponseModel = response??.data!
                    self.goToTransactionView()
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
    
    // MARK: - Phone BIll
    func phoneBill(){
        HPProgressHUD.show()
        PhoneBillChoosePaymentViewModel().getPaymentData() {  response, error  in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
              //  print("\n\n\n Payment is ", response?.data)
                //  signupRequest.otp = response?.data!
                DispatchQueue.main.async {
                    objPhoneBillsManager?.paymentTransactionModel = (response?.data)!
                    self.goToTransactionView()
                }
            }else{
                var msg = ""
                if response?.message != nil {
                    msg = response?.message ?? ""
                }else if response?.error?.count != nil {
                    msg = response?.error ?? ""
                }else if response?.data?.errordesc != nil {
                    msg = response?.data?.errordesc ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
    }
    // MARK: - utility
    func utilityBills(){
        HPProgressHUD.show()
        UtilityPaymentChooseViewModel().getPaymentData(finalAmount: finalAmount) {  response, error  in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                print("\n\n\n Payment is ", response?.data)
                //  signupRequest.otp = response?.data!
                DispatchQueue.main.async {
                    objUtilityPaymentManager?.paymentTransactionModel = (response?.data)!
                    self.goToTransactionView()
//                    self.goToSuccessVC()
                }
            }else{
                var msg = ""
                if response?.message != nil {
                    msg = response?.message ?? ""
                }else if response?.error?.count != nil {
                    msg = response?.error ?? ""
                }else if response?.data?.errordesc != nil {
                    msg = response?.data?.errordesc ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
    }
    // MARK: -
    // MARK: - Hotel Booking
    func hotelBooking(){
        
        HPProgressHUD.show()
        HotelBookingViewModel().bookHotel(amount: finalAmount) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                print("\n\n\n Payment is ", response?.data)
                //  signupRequest.otp = response?.data!
                DispatchQueue.main.async {
                    
                    if let successVC = HotelBookingSuccessViewController.storyboardInstance() {
                        successVC.orderResponse = response?.data
                        self.navigationController?.pushViewController(successVC, animated: true)
                    }
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
    
    // MARK: - self.licensePayment()
    func licensePayment() {
        HPProgressHUD.show()
        LicenseRenewalViewModel().payment(amount: finalAmount) { response, error in
            
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
                    objLicenseRenewalManager?.paymentModel = response?.data
                    self.goToTransactionView()
                }
            }else{
                var msg = ""
                if response?.data?.errordesc != nil {
                    msg = response?.data?.errordesc ?? ""
                }else if response?.message != nil {
                    msg = response?.message ?? ""
                }else if response?.error?.count != nil {
                    msg = response?.error ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
    }
    
    // MARK: - PekoStore Payment
    func pekoStorePayment() {
        
        HPProgressHUD.show()
        PekoStoreDashboardViewModel().payment(total: finalAmount) { response, error in
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
                    
                    objPekoStoreManager?.paymentResponseModel = response?.data!
                    self.goToTransactionView()
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
    
    // MARK: -
    func logisticsPayment(){
        HPProgressHUD.show()
        LogisticsViewModel().createShipment(finalAmount: finalAmount) { response, error in
            
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    if let successVC = LogisticsSuccessViewController.storyboardInstance() {
                        successVC.trakingID = "\(response?.data?.corporateTxnId?.value ?? 0)"
                        self.navigationController?.pushViewController(successVC, animated: true)
                    }
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
    func officeAddressPayment(){
        HPProgressHUD.show()
        WorkspaceViewModel().workspacePayment(amount: finalAmount) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response??.status, status == true {
                DispatchQueue.main.async {
                    
                    print(response)
                    self.goToSuccessVC()
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
    
    // MARK: -
    func bookAirTicket(){
        HPProgressHUD.show()
        AirTicketViewModel().bookTicket(finalAmount:finalAmount) { response, error in
            HPProgressHUD.hide()
            print(response)
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    print(response)
                    
                    objAirTicketManager!.bookResponseModel = response?.data
                    
                    if let successVC = BookingConfirmedViewController.storyboardInstance() {
                        self.navigationController?.pushViewController(successVC, animated: true)
                    }
                   
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
    // MARK: -
    // MARK: - ZeroCarbon
    func zeroCarbon(){
        HPProgressHUD.show()
        CarbonViewModel().payment(finalAmount: self.finalAmount) { response, error in
            HPProgressHUD.hide()
            print(response)
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    objCarbonManager!.paymentResponseModel = response?.data
                    print(response)
                    self.goToTransactionView()
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
    // MARK: - eSIM Payment
    func eSimPayment(){
        HPProgressHUD.show()
        eSimViewModel().payment(finalAmount: self.finalAmount) { response, error in
            HPProgressHUD.hide()
            print(response)
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    objeSIMManager!.paymentResponseModel = response?.data
                    print(response)
                    self.goToTransactionView()
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
    
    
    
    // MARK: - DocumentAttestationManager
    func documentAttestation(){
     /*
        HPProgressHUD.show()
        DocumentAttestationViewModel().payment(finalAmount: self.finalAmount) { response, error in
            HPProgressHUD.hide()
            print(response)
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    objDocumentAttestationManager!.paymentResponseModel = response?.data
                    self.goToTransactionView()
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
        */
    }
    // MARK: -
    // MARK: - Success
    func goToTransactionView(){
        if let vc = PaymentTransactionViewController.storyboardInstance() {
            vc.paymentPayNow = self.paymentPayNow
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: -
    // MARK: - Success
    func goToSuccessVC(){
        
        var attr1:NSMutableAttributedString?
        var attr2:NSMutableAttributedString?
      
        attr1 = NSMutableAttributedString().color(AppColors.blackThemeColor!, "Order Placed Successfully", font: AppFonts.Bold.size(size: 24), 5, .center)
        
        attr2 = NSMutableAttributedString().color(AppColors.blackThemeColor!, "", font: AppFonts.Regular.size(size: 14), 5, .center)
        
        if self.paymentPayNow == .GiftCard {
            attr1 = NSMutableAttributedString().color(AppColors.blackThemeColor!, "Gift Card is Purchased", font: AppFonts.Bold.size(size: 24), 5, .center)
            
            attr2 = NSMutableAttributedString().color(AppColors.blackThemeColor!, "You will receive a confirmation email once the payment process is completed.", font: AppFonts.Regular.size(size: 14), 5, .center)
        }
        /*
        else if self.paymentPayNow == .UtilityBill {
            
            attr1 = NSMutableAttributedString().color(AppColors.blackThemeColor!, objUserSession.currency + "\(finalAmount.withCommas()) Paid Successfully", font: AppFonts.Bold.size(size: 24), 5, .center)
            
            let dic = Constants.utilityPaymentArray[objUtilityPaymentManager?.utilityPaymentType?.rawValue ?? 0]
            let servicePorvider = dic["title"]!
           
            
            attr2 = NSMutableAttributedString().color(AppColors.blackThemeColor!, "Your \(servicePorvider) bill for ", font: AppFonts.Regular.size(size: 14), 5, .center).color(AppColors.blackThemeColor!, "\(objUtilityPaymentManager!.utilityPaymentRequest?.amount ?? "")", font: AppFonts.Regular.size(size: 14), 5, .center).color(AppColors.blackThemeColor!, " is successful.", font: AppFonts.Regular.size(size: 14), 5, .center)
            
        }
       
        else if self.paymentPayNow == .License {
             attr1 = NSMutableAttributedString().color(AppColors.blackThemeColor!, "Your DED license renewal has been successfully processed", font: AppFonts.Bold.size(size: 24), 5, .center)
            
             attr2 = NSMutableAttributedString().color(AppColors.blackThemeColor!, "We are pleased to inform you that your DED license renewal has been successfully processed. You will soon be receiving a confirmation email from the respective authority, along  with a copy of your renewed license.", font: AppFonts.Regular.size(size: 14), 5, .center)
       
        }
         else if self.paymentPayNow == .OfficeAddress {
             attr1 = NSMutableAttributedString().color(AppColors.blackThemeColor!, "Order Placed Successfully", font: AppFonts.Bold.size(size: 24), 5, .center)
            
             attr2 = NSMutableAttributedString().color(AppColors.blackThemeColor!, "", font: AppFonts.Regular.size(size: 14), 5, .center)
       
        }
         */
       
        
        else if self.paymentPayNow == .DocumentAttestation {
             attr1 = NSMutableAttributedString().color(AppColors.blackThemeColor!, "Your payment is done", font: AppFonts.Bold.size(size: 24), 5, .center)
            
             attr2 = NSMutableAttributedString().color(AppColors.blackThemeColor!, "Your order for Document attestation service has been successfully placed. Our representative will be dispatched to collect the document from the provided address.", font: AppFonts.Regular.size(size: 14), 5, .center)
       
        }
//        else if self.paymentPayNow == .SubscriptionPayment {
//            
//        }
        
        if let paymentSuccessVC = PaymentSuccessViewController.storyboardInstance(){
            paymentSuccessVC.screenTitle = self.getTitle()
            
            paymentSuccessVC.titleAttributeString = attr1
            paymentSuccessVC.detailAttributeString = attr2
            self.navigationController?.pushViewController(paymentSuccessVC, animated: true)
        }
        
    }
    // MARK: - Stripe Payment
    func makeStripePayment(){
       
        HPProgressHUD.show()
        var parameters = [String:Any]()
        
        if self.paymentPayNow == .MobileRecharge {
            parameters = MobileRechargeModelView().getParametersForCreateOrder(amount: finalAmount)
        }else if self.paymentPayNow == .GiftCard {
            parameters = GiftCardsProductsViewModel().getParametersForCreateOrder(amount: finalAmount)
        }else if self.paymentPayNow == .eSIM {
            parameters = eSimViewModel().getParametersForCreateOrder(amount: finalAmount)
        }
        
        
        CommonViewModel().createStripeOrder(param: parameters) { response, error in
            print(response)
            HPProgressHUD.hide()
            if error != nil {
#if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    //intentCreationCallback(.success(response?.data?.paymentIntent ?? ""))
                    
                    print("\n\n\n+++++++++++++++++++++++++++++++++++++++")
                    print("\n Payment Ref ID => ", response?.data?.paymentRefId?.value ?? "")
                    print("\n\n\n+++++++++++++++++++++++++++++++++++++++")
                    
                    self.presentStripUI(response: (response?.data)!)
                  
                }
            }else{
                //intentCreationCallback(.failure(error ?? Error()))
                var msg = ""
                if response?.message != nil {
                    msg = response?.message ?? ""
                }else if response?.error?.count != nil {
                    msg = response?.error ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
        
        /*
        let intentConfig = PaymentSheet.IntentConfiguration(
            mode: .payment(amount: Int(finalAmount) * 100, currency: "USD", captureMethod: .automatic)
        ) { [weak self] _, _, intentCreationCallback in
            
            self?.handleConfirm(intentCreationCallback)
            
        }
        
        // payment(amount: Int(finalAmount), currency: "USD")
       
        var configuration = PaymentSheet.Configuration()
        configuration.returnURL = "kash10app://stripe-redirect" // Use the return url you set up in the previous step
        let paymentSheet = PaymentSheet(intentConfiguration: intentConfig, configuration: configuration)

        paymentSheet.present(from: self) { result in
            switch result {
            case .completed:
                print(result)
                // Payment completed - show a confirmation screen.
                break
            case .failed(let error):
                print(error)
                // PaymentSheet encountered an unrecoverable error. You can display the error to the user, log it, etc.
                break
            case .canceled:
                // Customer canceled - you should probably do nothing.
                break
            }
        }
        */
    }
    func presentStripUI(response:StripeCreateTokenModel){
        
        
        let paymentRefId = "\(response.paymentRefId?.value ?? 0)"
            
        let paymentIntent = response.paymentIntent ?? ""
                
        let ephemeralKey = response.ephemeralKey ?? ""
        
        let customer = response.customer ?? ""
        
        let publishableKey = response.publishableKey ?? ""
        
        STPAPIClient.shared.publishableKey = publishableKey
        var configuration = PaymentSheet.Configuration()
      //  configuration.merchantDisplayName = "Example, Inc."
       
        configuration.customer = .init(id: customer, ephemeralKeySecret: ephemeralKey)
   
        configuration.allowsDelayedPaymentMethods = true
        let paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntent, configuration: configuration)
        
        paymentSheet.present(from: self) { paymentResult in
            // MARK: Handle the payment result
            switch paymentResult {
            case .completed:
                print("Your order is confirmed")
                HPProgressHUD.show()
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    self.getPaymentDetails(paymentRefID: paymentRefId)
                }
            case .canceled:
                print("Canceled!")
                self.showAlert(title: "", message: "Canceled!")
            case .failed(let error):
                print("Payment failed: \(error)")
                self.showAlert(title: "Payment failed", message: error.localizedDescription)
            }
        }
    }
    func getPaymentDetails(paymentRefID:String){
      
        CommonViewModel().getPaymentDetails(paymentRefId: paymentRefID) { response, error in
            HPProgressHUD.hide()
            if error != nil {
#if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                 
                    print(response)
                    
                    if self.paymentPayNow == .GiftCard {
                        self.goToSuccessVC()
                    }else{
                        if let vc = PaymentTransactionViewController.storyboardInstance() {
                            vc.paymentPayNow = self.paymentPayNow
                            vc.stripeOrderResponse = response?.data
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }else{
                //intentCreationCallback(.failure(error ?? Error()))
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
    /*
    func handleConfirm(_ intentCreationCallback: @escaping (Result<String, Error>) -> Void) {
        // ...explained later
        print("")
        
        var parameters = [String:Any]()
        
        if self.paymentPayNow == .MobileRecharge {
            parameters = MobileRechargeModelView().getParametersForCreateOrder(amount: finalAmount)
        }else if self.paymentPayNow == .GiftCard {
            parameters = GiftCardsProductsViewModel().getParametersForCreateOrder(amount: finalAmount)
        }
        
        
        CommonViewModel().createStripeOrder(param: parameters) { response, error in
            print(response)
            
            if error != nil {
#if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    intentCreationCallback(.success(response?.data?.paymentIntent ?? ""))
                    /*
                    let myServerResponse: Result<String, Error> = ...
                    switch myServerResponse {
                    case .success(let clientSecret):
                        // Call the `intentCreationCallback` with the client secret
                        
                        break
                    case .failure(let error):
                        // Call the `intentCreationCallback` with the error
                        intentCreationCallback(.failure(error))
                        break
                    }
                    
                    */
                }
            }else{
                //intentCreationCallback(.failure(error ?? Error()))
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
    */
}
extension PaymentReviewViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return amountArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
       
        if self.paymentPayNow == .PhoneBill || self.paymentPayNow == .UtilityBill{
            if indexPath.row % 4 == 0 {
                cell.textLabel?.font = AppFonts.Bold.size(size: 14)
                cell.detailTextLabel?.font = AppFonts.Bold.size(size: 14)
                
                let color = UIColor.black
                cell.textLabel?.textColor = color
                cell.detailTextLabel?.textColor = color
            }else{
                cell.textLabel?.font = AppFonts.Regular.size(size: 14)
                cell.detailTextLabel?.font = AppFonts.Regular.size(size: 14)
                
                let color = UIColor(red: 118/255.0, green: 118/255.0, blue: 118/255.0, alpha: 1.0)
                cell.textLabel?.textColor = color
                cell.detailTextLabel?.textColor = color
            }
        }else{
            if indexPath.row == self.titleArray.count - 1 {
                cell.textLabel?.font = AppFonts.Bold.size(size: 14)
                cell.detailTextLabel?.font = AppFonts.Bold.size(size: 14)
                
                let color = UIColor.black
                cell.textLabel?.textColor = color
                cell.detailTextLabel?.textColor = color
            }else{
                cell.textLabel?.font = AppFonts.Regular.size(size: 14)
                cell.detailTextLabel?.font = AppFonts.Regular.size(size: 14)
                
                let color = UIColor(red: 118/255.0, green: 118/255.0, blue: 118/255.0, alpha: 1.0)
                cell.textLabel?.textColor = color
                cell.detailTextLabel?.textColor = color
             
            }
        }
        
        let title = self.titleArray[indexPath.row]
        let amount = self.amountArray[indexPath.row]
        
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = amount
        
        return cell
    }
}
