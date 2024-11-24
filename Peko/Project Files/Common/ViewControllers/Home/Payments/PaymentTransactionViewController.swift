//
//  PaymentTransactionViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 25/03/24.
//

import UIKit
import Lottie

class PaymentTransactionViewController: MainViewController {

  //  @IBOutlet weak var animationView: LottieAnimationView!
   
    @IBOutlet weak var totalPaymentLabel: PekoLabel!
    
    @IBOutlet weak var totalCashbackLabel: PekoLabel!
    
    @IBOutlet weak var cashbackStackView: UIStackView!
    
    @IBOutlet weak var transactionIdLabel: PekoLabel!
    @IBOutlet weak var dateLabel: PekoLabel!
    @IBOutlet weak var timeLabel: PekoLabel!
    @IBOutlet weak var serviceLabel: PekoLabel!
    @IBOutlet weak var servicePorviderLabel: PekoLabel!
    @IBOutlet weak var numberLabel: PekoLabel!
    @IBOutlet weak var goToBackButton: PekoButton!
  
  //  var screenTitle:String = ""
    var paymentPayNow:PaymentPayNow = .PekoStore
    
    var stripeOrderResponse:StripeOrderResponseModel?
    
    static func storyboardInstance() -> PaymentTransactionViewController? {
        return AppStoryboards.Payment.instantiateViewController(identifier: "PaymentTransactionViewController") as? PaymentTransactionViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.view.backgroundColor = .white
        DispatchQueue.main.async {
            
            if self.stripeOrderResponse == nil {
                self.setWalletPaymentData()
            }else{
                self.setStripePaymentData()
            }
        }
       
    }
    // MARK: -
    func setWalletPaymentData(){
        var titleString = ""
        var bill_amount = 0.0
        var cashback_amount = 0.0
        var transactionID = ""
        
        var date = ""
        var time = ""
        var servicePorvider = ""
        var accountNumber = ""
        
        if self.paymentPayNow == .MobileRecharge {
            
            titleString = "Bill Payments"
            
            bill_amount = objMobileRechargeManager?.paymentResponseModel?.invoiceAmount?.value ?? 0.0
            
            cashback_amount = 0.0
          
            transactionID = "\(objMobileRechargeManager?.paymentResponseModel?.transactionId ?? 0)"
           
            date = objMobileRechargeManager?.paymentResponseModel?.date.formate(format: "dd MMMM’yy") ?? ""
            time = objMobileRechargeManager?.paymentResponseModel?.date.formate(format: "hh:mm a") ?? ""
          
            servicePorvider = objMobileRechargeManager?.selectedOperatorModel?.operatorName ?? ""
           
            accountNumber = objUserSession.mobileCountryCode + (objMobileRechargeManager?.mobileNumber ?? "")
            
        }else if self.paymentPayNow == .PhoneBill {
            
            titleString = "Bill Payments"
            
            bill_amount = (objPhoneBillsManager?.paymentTransactionModel?.amount?.value ?? "0.0").toDouble()
            cashback_amount = (objPhoneBillsManager?.paymentTransactionModel?.corporateCashback?.toDouble()) ?? 0.0
          
            transactionID = "\(objPhoneBillsManager?.paymentTransactionModel?.corporateTxnId?.value ?? 0)"
           
            date = objPhoneBillsManager?.paymentTransactionModel?.date.formate(format: "dd MMMM’yy") ?? ""
            time = objPhoneBillsManager?.paymentTransactionModel?.date.formate(format: "hh:mm a") ?? ""
          
            servicePorvider = objPhoneBillsManager?.paymentTransactionModel?.serviceProvider ?? ""
           
            accountNumber = objPhoneBillsManager?.phoneBillRequest?.number ?? ""
            
        }else if self.paymentPayNow == .UtilityBill {
            
            titleString = "Bill Payments"
            
            bill_amount = (objUtilityPaymentManager?.paymentTransactionModel?.amount?.value ?? "0.0").toDouble()
            cashback_amount = ((objPhoneBillsManager?.paymentTransactionModel?.corporateCashback ?? "0.0").toDouble())
          
            transactionID = "\(objUtilityPaymentManager?.paymentTransactionModel?.corporateTxnId?.value ?? 0)"
           
            date = objUtilityPaymentManager?.paymentTransactionModel?.date.formate(format: "dd MMMM’yy") ?? ""
            time = objUtilityPaymentManager?.paymentTransactionModel?.date.formate(format: "hh:mm a") ?? ""
          
            servicePorvider = objUtilityPaymentManager?.paymentTransactionModel?.serviceProvider ?? ""
           
            accountNumber = objUtilityPaymentManager?.utilityPaymentRequest?.acoountNumber ?? ""
            
        }else if self.paymentPayNow == .ZeroCarbon {
           
            titleString = "Zero Carbon"
        
             bill_amount = objCarbonManager?.co2AmountInAED ?? 0.0
            
            cashback_amount = (objCarbonManager?.paymentResponseModel?.corporateCashback?.toDouble()) ?? 0.0
            
            transactionID = "\(objCarbonManager?.paymentResponseModel?.corporateTxnId.value ?? 0)"
           
            date = objCarbonManager?.paymentResponseModel?.resultData!.date.formate(format: "dd MMMM’yy") ?? ""
            time = objCarbonManager?.paymentResponseModel?.resultData!.date.formate(format: "hh:mm a") ?? ""
          
            servicePorvider = titleString
           
            accountNumber = "-"  //objPhoneBillsManager?.phoneBillRequest?.number ?? ""
           
        }else if self.paymentPayNow == .License {
            
            titleString = "License Renewal"
        
            bill_amount = objLicenseRenewalManager?.paymentModel?.paidAmountInAed ?? 0.0
            
            cashback_amount = (objLicenseRenewalManager?.paymentModel?.corporateCashback?.toDouble()) ?? 0.0
            
            transactionID = "\(objLicenseRenewalManager?.paymentModel?.corporateTxnId?.value ?? 0)"
           
            date = objLicenseRenewalManager?.paymentModel!.date.formate(format: "dd MMMM’yy") ?? ""
            time = objLicenseRenewalManager?.paymentModel!.date.formate(format: "hh:mm a") ?? ""
          
            servicePorvider = "DED"
           
            accountNumber = objLicenseRenewalManager?.balanceDataModel?.VoucherNumber ?? ""
       
        }else if self.paymentPayNow == .SubscriptionPayment {
            
            titleString = "Subscriptions"
        
            bill_amount = objSubscriptionPaymentManager?.paymentResponseModel?.amount?.value ?? 0.0
            
            cashback_amount = (objSubscriptionPaymentManager?.paymentResponseModel?.corporateCashback?.toDouble()) ?? 0.0
            
            transactionID = "\(objSubscriptionPaymentManager?.paymentResponseModel?.corporateTxnId?.value ?? 0)"
           
            date = objSubscriptionPaymentManager?.paymentResponseModel!.date.formate(format: "dd MMMM’yy") ?? ""
            time = objSubscriptionPaymentManager?.paymentResponseModel!.date.formate(format: "hh:mm a") ?? ""
          
            servicePorvider = titleString
           
            accountNumber = "-"
        }else if self.paymentPayNow == .PekoStore {
            
            titleString = "Office Supplies"
        
            bill_amount = objPekoStoreManager?.paymentResponseModel?.amount?.value ?? 0.0
            
            cashback_amount = (objPekoStoreManager?.paymentResponseModel?.corporateCashback?.toDouble()) ?? 0.0
            
            transactionID = "\(objPekoStoreManager?.paymentResponseModel?.corporateTxnId?.value ?? 0)"
           
            date = objPekoStoreManager?.paymentResponseModel!.date.formate(format: "dd MMMM’yy") ?? ""
            time = objPekoStoreManager?.paymentResponseModel!.date.formate(format: "hh:mm a") ?? ""
          
            servicePorvider = titleString
           
            accountNumber = "-"
        }else if self.paymentPayNow == .eSIM {
            
            titleString = "Travel eSIM"
        
        //    bill_amount = ((objeSIMManager?.selectedeSimPackage?.price?.value ?? 0.0) * (objeSIMManager?.usdToAed ?? 0.0))
            bill_amount = (objeSIMManager?.selectedeSimPackage?.price?.value ?? 0.0)
           
            cashback_amount = (objeSIMManager?.paymentResponseModel?.corporateCashback?.toDouble()) ?? 0.0
            
            transactionID = "\(objeSIMManager?.paymentResponseModel?.customerTxnId?.value ?? 0)"
           
            let d = Date()
            date = d.formate(format: "dd MMMM’yy")
            time = d.formate(format: "hh:mm a")
          
            servicePorvider = "-"
            accountNumber =  "-"
       
        }
        /*
        else if self.paymentPayNow == .DocumentAttestation {
            
            titleString = "Document Attestation"
        
            bill_amount = objDocumentAttestationManager?.paymentResponseModel?.amount?.value ?? 0.0
            
            cashback_amount = (objDocumentAttestationManager?.paymentResponseModel?.corporateCashback?.value.toDouble()) ?? 0.0
            
            transactionID = "\(objDocumentAttestationManager?.paymentResponseModel?.corporateTxnId?.value ?? 0)"
           
            let d = objDocumentAttestationManager?.paymentResponseModel?.date ?? Date()
            date = d.formate(format: "dd MMMM’yy")
            time = d.formate(format: "hh:mm a")
          
            servicePorvider = "-"
            accountNumber =  "-"
       
        }
        */
        self.setTitle(title:  titleString)
        self.serviceLabel.text = titleString
        self.goToBackButton.setTitle("Go to \(titleString)", for: .normal)
      
        if cashback_amount == 0.0 {
            self.cashbackStackView.isHidden = true
        }else{
            self.cashbackStackView.isHidden = false
            self.totalCashbackLabel.text = objUserSession.currency + "+ " + (cashback_amount.decimalPoints())
        }
        self.totalPaymentLabel.text = objUserSession.currency + (bill_amount.withCommas() )
        
        self.transactionIdLabel.text = transactionID
       
        self.dateLabel.text = date
        self.timeLabel.text = time
      
        self.servicePorviderLabel.text = servicePorvider
        self.numberLabel.text = accountNumber
    }
    // MARK: -
    @IBAction func goToBackButtonClick(_ sender: Any) {
        
        let viewControllers = self.navigationController?.viewControllers
        
        for view in viewControllers! {
            if view.isKind(of: HomeViewController.self) {
                print("Home")
            }else if view.isKind(of: MoreServiceViewController.self) {
                print("More Service")
            }else{
                self.navigationController?.popToViewController(view, animated: false)
                break
            }
        }
    }
    
    
    func setStripePaymentData(){

        var titleString = ""
        let bill_amount = (self.stripeOrderResponse?.order?.baseAmount?.value ?? "0.0").toDouble()
        let cashback_amount = (self.stripeOrderResponse?.customerCashback?.value ?? "0.0").toDouble()
        let transactionID = "\(self.stripeOrderResponse?.customerTxnId?.value ?? "0")"
        
        let date = self.stripeOrderResponse?.date.formate(format: "dd MMMM’yy") ?? ""
        let time = self.stripeOrderResponse?.date.formate(format: "hh:mm a") ?? ""
        var servicePorvider = ""
        var accountNumber = ""
        
        if self.paymentPayNow == .MobileRecharge {
            
            titleString = "Bill Payments"
            servicePorvider = objMobileRechargeManager?.selectedOperatorModel?.operatorName ?? ""
            accountNumber = objUserSession.mobileCountryCode + (objMobileRechargeManager?.mobileNumber ?? "")
            
        }else if self.paymentPayNow == .eSIM {
            
            titleString = "Travel eSIM"
            servicePorvider = "-"
            accountNumber =  "-"
       
        }
        
        self.setTitle(title:  titleString)
        self.serviceLabel.text = titleString
        self.goToBackButton.setTitle("Go to \(titleString)", for: .normal)
      
        if cashback_amount == 0.0 {
            self.cashbackStackView.isHidden = true
        }else{
            self.cashbackStackView.isHidden = false
            self.totalCashbackLabel.text = objUserSession.currency + "+ " + (cashback_amount.decimalPoints())
        }
        self.totalPaymentLabel.text = objUserSession.currency + (bill_amount.withCommas() )
        
        self.transactionIdLabel.text = transactionID
       
        self.dateLabel.text = date
        self.timeLabel.text = time
      
        self.servicePorviderLabel.text = servicePorvider
        self.numberLabel.text = accountNumber
    }
 
    // MARK: - Support Mail
    @IBAction func needHelpButtonClick(_ sender: Any) {
        self.supportMail()
    }
    
}
