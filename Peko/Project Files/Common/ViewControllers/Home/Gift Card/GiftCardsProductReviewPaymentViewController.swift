//
//  GiftCardsProductReviewPaymentViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 12/05/23.
//

import UIKit

import DapiSDK

enum SelectedPaymentType: Int {
    case None = 0
    case PekoWallet
    case BankAccount
    case Card
}

class GiftCardsProductReviewPaymentViewController: MainViewController {

    @IBOutlet weak var pekoWalletView: UIView!
    
    @IBOutlet weak var usePekoBalanceView: UIView!
    @IBOutlet weak var pekoWalletButton: UIButton!
    @IBOutlet weak var bankAccountButton: UIButton!
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var byNowButton: UIButton!
    
    @IBOutlet weak var usePekoBalanceButton: UIButton!
    @IBOutlet weak var useBalanceLabel: UILabel!
    
    @IBOutlet weak var walletBalanceLabel: UILabel!
   
    
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var chargesLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    
    let normalBorderColor = UIColor(named: "Border_777777")
    let bankBorderColor = UIColor(named: "Border_039800")
    let cardBorderColor = UIColor(named: "Border_6B6FAD")
    let byNowBorderColor = UIColor(named: "Border_FF4D00")
    
    var selectedPaymentType = SelectedPaymentType(rawValue: 0)
    
    static func storyboardInstance() -> GiftCardsProductReviewPaymentViewController? {
        return AppStoryboards.GiftCards.instantiateViewController(identifier: "GiftCardsProductReviewPaymentViewController") as? GiftCardsProductReviewPaymentViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Review your payment")
        
        self.useBalanceLabel.attributedText = NSMutableAttributedString().color(.black, "Use your Peko Balance ", font: AppFonts.Regular.size(size: 12)).color(.black, objUserSession.currency + "\(objUserSession.balance.withCommas())", font: AppFonts.Bold.size(size: 12))
        self.walletBalanceLabel.text = objUserSession.currency + objUserSession.balance.withCommas()
        let amount = objGiftCardManager?.amount ?? 0.0
        if amount < objUserSession.balance {
            self.usePekoBalanceView.isHidden = true
        }else{
            self.usePekoBalanceView.isHidden = false
        }
        
        let charges = 0.0
        let total = amount + charges
        
        self.subTotalLabel.text = amount.withCommas()
        self.chargesLabel.text = charges.withCommas()
        self.totalLabel.text = total.withCommas()
        
        objShareManager.initializeDapiSDK()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Payment Option
    @IBAction func paymentOptionButtonClick(_ sender: UIButton) {
   
        self.pekoWalletButton.borderColor = self.normalBorderColor
        self.bankAccountButton.borderColor = self.normalBorderColor
        self.cardButton.borderColor = self.normalBorderColor
        self.byNowButton.borderColor = self.normalBorderColor
        
        self.pekoWalletButton.borderWidth = 0.5
        self.bankAccountButton.borderWidth = 0.5
        self.cardButton.borderWidth = 0.5
        self.byNowButton.borderWidth = 0.5
        
        self.pekoWalletButton.backgroundColor = .clear
        self.bankAccountButton.backgroundColor = .clear
        self.cardButton.backgroundColor = .clear
        self.byNowButton.backgroundColor = .clear
        
        self.selectedPaymentType = SelectedPaymentType(rawValue: sender.tag)
        
        if sender.tag == 1 { // Wallet
            self.pekoWalletButton.borderColor = self.normalBorderColor
            self.pekoWalletButton.borderWidth = 1
            self.pekoWalletButton.backgroundColor = self.normalBorderColor?.withAlphaComponent(0.1)
            
        }else if sender.tag == 2 { // Bank
            self.bankAccountButton.borderColor = self.bankBorderColor
            self.bankAccountButton.borderWidth = 1
            self.bankAccountButton.backgroundColor = self.bankBorderColor?.withAlphaComponent(0.1)
        }else if sender.tag == 3 { // Card
            self.cardButton.borderColor = self.cardBorderColor
            self.cardButton.borderWidth = 1
            self.cardButton.backgroundColor = self.cardBorderColor?.withAlphaComponent(0.1)
        }else if sender.tag == 4 { // By Now
            self.byNowButton.borderColor = self.byNowBorderColor
            self.byNowButton.borderWidth = 1
            self.byNowButton.backgroundColor = self.byNowBorderColor?.withAlphaComponent(0.1)
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
    // MARK: - Quick Payment
    func makeQuickPayment(){
        
       
    }
    // MARK: -
    func selectDapiAccount(bankConnection: DapiSDK.DAPIBankConnection){
        
    }
    func goToPurchasedView() {
        if let payVc = GiftCardPurchasedViewController.storyboardInstance() {
            self.navigationController?.pushViewController(payVc, animated: true)
        }
    }
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }

}
extension GiftCardsProductReviewPaymentViewController:DAPIConnectDelegate{
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
