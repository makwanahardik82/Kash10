//
//  UtilityPaymentChoosePaymentVC.swift
//  Peko
//
//  Created by Hardik Makwana on 18/01/23.
//

import UIKit

import DapiSDK

class UtilityPaymentChoosePaymentVC: MainViewController {

    @IBOutlet weak var pekoWalletButton: UIButton!
    @IBOutlet weak var dapiAccountButton: UIButton!
    
    @IBOutlet weak var beneficiaryNameLabel: UILabel!
    @IBOutlet weak var beneficiaryNumberLabel: UILabel!
  
    //@IBOutlet weak var beneficiaryAmountLabel: UILabel!
   
    @IBOutlet weak var amoutTxt: UITextField!
  
    @IBOutlet weak var walletBalanceLabel: UILabel!
    
    @IBOutlet weak var pekoWalletContentView: UIView!
    @IBOutlet weak var insufficientContentView: UIView!
    @IBOutlet weak var bankAccountContentView: UIView!
    @IBOutlet weak var checkBoxContentView: UIView!
    
    @IBOutlet weak var usePekoBalanceLabel: UILabel!
    
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var payBillButton: UIButton!
  
    @IBOutlet weak var denominationsLabel: UILabel!
  
    var isFromWallet = true
    
    static func storyboardInstance() -> UtilityPaymentChoosePaymentVC? {
        return AppStoryboards.Utility.instantiateViewController(identifier: "UtilityPaymentChoosePaymentVC") as? UtilityPaymentChoosePaymentVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        
        self.setTitle(title: "Choose a payment method")
       // self.setTitle(title:  objUtilityPaymentManager?.limitDataModel?.serviceProvider ?? "")
        // Do any additional setup after loading the view.
        
        self.pekoWalletButton.backgroundColor = AppColors.backgroundThemeColor
        self.dapiAccountButton.backgroundColor = .clear
        
        
        self.beneficiaryNameLabel.text = objUtilityPaymentManager?.utilityPaymentRequest?.holder_name
        self.beneficiaryNumberLabel.text = objUtilityPaymentManager?.utilityPaymentRequest?.acoountNumber ?? ""
      
        objShareManager.initializeDapiSDK()
        
        self.walletBalanceLabel.text = "AED " + objUserSession.balance.withCommas() //
        
        self.insufficientContentView.isHidden = true
        self.checkBoxContentView.isHidden = true
        
        self.usePekoBalanceLabel.attributedText = NSMutableAttributedString().color(.black, "Use your Peko Balance ", font: AppFonts.Regular.size(size: 10)).color(.black, " AED \(objUserSession.balance.withCommas())", font: AppFonts.Bold.size(size: 10))
        
//        if objUtilityPaymentManager?.utilityPaymentType == .FEWA {
//         //   self.amoutTxt.text = objUtilityPaymentManager?.balanceDataModel?.Balance?.value
//        }else if objUtilityPaymentManager?.utilityPaymentType == .AADC {
//            self.amoutTxt.text = objUtilityPaymentManager?.balanceDataModel?.dueBalanceInAed
//        }else if objUtilityPaymentManager?.utilityPaymentType == .ADDC {
//
//        }
        
        if objUtilityPaymentManager?.utilityPaymentType == .Salik || objUtilityPaymentManager?.utilityPaymentType == .Nol_Card{
            self.amoutTxt.text = objUtilityPaymentManager?.utilityPaymentRequest?.amount ?? ""
        }else{
            self.amoutTxt.text = objUtilityPaymentManager?.balanceDataModel?.dueBalanceInAed
        }
       
        self.denominationsLabel.text = "Min: \(objUtilityPaymentManager?.limitDataModel?.minDenomination ?? 0) AED and Max: \(objUtilityPaymentManager?.limitDataModel?.maxDenomination ?? 0) AED"
        self.pekoWalletButtonClick(UIButton())
        
        self.amoutTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
// MARK: - Choose Payment
    // MARK: - Peko Wallet
    @IBAction func pekoWalletButtonClick(_ sender: Any) {
        let color = UIColor(red: 251/255, green: 251/255, blue: 1, alpha: 1.0)
        
        self.pekoWalletButton.backgroundColor = color // AppColors.backgroundThemeColor
        self.dapiAccountButton.backgroundColor = .clear
        self.isFromWallet = true
        
        self.pekoWalletContentView.borderColor = .black
        self.bankAccountContentView.borderColor = AppColors.borderThemeColor
        
        let amount = Double(self.amoutTxt.text ?? "0.0") ?? 0
        if amount > objUserSession.balance {
            self.insufficientContentView.isHidden = false
            self.payBillButton.isEnabled = false
            self.payBillButton.backgroundColor = .lightGray
        }else{
            self.insufficientContentView.isHidden = true
            self.payBillButton.isEnabled = true
            self.payBillButton.backgroundColor = .black
        }
        self.checkBoxContentView.isHidden = true
    }
    // MARK: - Bank Account
    @IBAction func dapiAccountButtonClick(_ sender: Any) {
        let color = UIColor(red: 251/255, green: 251/255, blue: 1, alpha: 1.0)
       
        self.pekoWalletButton.backgroundColor = .clear
        self.dapiAccountButton.backgroundColor = color //AppColors.backgroundThemeColor
        self.isFromWallet = false
        
        self.pekoWalletContentView.borderColor = AppColors.borderThemeColor
        self.bankAccountContentView.borderColor = .black
        
        let amount = Double(self.amoutTxt.text ?? "0.0") ?? 0
       
        if amount > objUserSession.balance {
            self.checkBoxContentView.isHidden = false
        }else{
            self.checkBoxContentView.isHidden = true
        }
        self.payBillButton.isEnabled = true
        self.payBillButton.backgroundColor = .black
        self.insufficientContentView.isHidden = true
    }
    // MARK: -
    @IBAction func payButtonClick(_ sender: Any) {
        
        let amount = Double(self.amoutTxt.text ?? "0.0")
        let min = Double(objUtilityPaymentManager?.limitDataModel?.minDenomination ?? 0)
        let max = Double(objUtilityPaymentManager?.limitDataModel?.maxDenomination ?? 0)
        
        if(amount! < min || amount! > max)
        {
            self.showAlert(title: "", message: "Please enter an amount between min and max denominations")
        }else{
            if self.isFromWallet {
                objUtilityPaymentManager?.utilityPaymentRequest?.amount = self.amoutTxt.text
                
                self.makeQuickPayment()
            }else{
                
                let connections = Dapi.shared.bankConnections // to get cashed accounts

                if connections.count == 0 {
                    let connectVC = DAPIConnectVC()
                    connectVC.delegate = self
                    present(connectVC, animated: true, completion: nil)
                }else{
                    self.selectDapiAccount(bankConnection: connections.first!)
                }
            }
        }
    }
    func selectDapiAccount(bankConnection: DapiSDK.DAPIBankConnection){
        let bankAccountsVC = DAPIBankAccountsVC(bankConnection: bankConnection)
        bankAccountsVC.accountDidSelect = { account in
         
            print(account)
            
            var amount:Float = 0.0
            if self.checkButton.isSelected {
                amount = Float(objUtilityPaymentManager!.utilityPaymentRequest?.amount ?? "0.0")! - Float(objUserSession.balance)
            }else{
                amount = Float(objUtilityPaymentManager!.utilityPaymentRequest?.amount ?? "0.0")!
            }
            
            Dapi.shared.createTransfer(bankConnection: bankConnection,
                                       senderBankAccount: account,
                                       receiverBeneficiary:objShareManager.dapiReceiverBeneficiary,
                                       amount: amount,
                                       remark: "Test") { results in
                switch results {
                case .success(let response):
                  print(response)
                    
                    objUtilityPaymentManager!.dapiPaymentResponse = [
                        "operationID":response.operationID ?? "",
                        "referenceNumber":response.referenceNumber ?? "",
                        "statusCode":response.statusCode ?? 0,
                        "message":response.message ?? "",
                        "remark":response.remark ?? "",
                        "senderAccountID":response.senderAccountID ?? ""
                        ]
                    objUtilityPaymentManager!.utilityPaymentRequest?.dapiAmount = "\(amount)"
                    
                    self.makeQuickPayment()
                case .failure(let error):
                  print(error.dapiErrorMessage)
                    self.showAlert(title: "ERROR - Dapi Create Transfer", message: error.localizedDescription)
                }
            }
            
        }
        bankAccountsVC.accountSelectionFailed = { error in
            print(error)
            self.showAlert(title: "ERROR - DAPIBankAccountsVC", message: error?.localizedDescription ?? "")
        }
        self.present(bankAccountsVC, animated: true)
    }
    // MARK: - Quick Payment
    func makeQuickPayment(){
        HPProgressHUD.show()
        UtilityPaymentChooseViewModel().getPaymentData(finalAmount: 0.0) {  response, error  in
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
                    self.goToReceipt()
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
    func goToReceipt() {
        if let recipeVC = PaymentReceiptViewController.storyboardInstance() {
            recipeVC.isFrom = .UtilityPayment
            self.navigationController?.pushViewController(recipeVC, animated: true)
        }
    }
    
    // MARK: - Check Button Click
    @IBAction func checkButtonClick(_ sender: UIButton) {
        self.checkButton.isSelected = !self.checkButton.isSelected
    }
    
    
    // MARK: - Cancel
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if self.isFromWallet {
            self.pekoWalletButtonClick(UIButton())
        }else{
            self.dapiAccountButtonClick(UIButton())
        }
    }
    
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }
}
extension UtilityPaymentChoosePaymentVC:DAPIConnectDelegate{
    func dapiConnect(_ dapiConnect: DapiSDK.DAPIConnectVC, didSuccessfullyConnectTo bankID: String?, bankConnection: DapiSDK.DAPIBankConnection) {
        self.selectDapiAccount(bankConnection: bankConnection)
    }
    func dapiConnect(_ dapiConnect: DapiSDK.DAPIConnectVC, didFailConnectingWith error: String) {
        print(error)
    }
    func dapiConnectUserDidCancel(_ dapiConnect: DapiSDK.DAPIConnectVC) {
        print("Cancel")
    }
}
