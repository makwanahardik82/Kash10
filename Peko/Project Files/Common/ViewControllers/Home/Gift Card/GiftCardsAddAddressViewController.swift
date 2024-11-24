//
//  GiftCardsAddAddressViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 23/02/24.
//

import UIKit

class GiftCardsAddAddressViewController: MainViewController {

    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
   
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var addTableView: UITableView!
    @IBOutlet var headerView: UIView!
    
    
    @IBOutlet weak var receiverNameView: PekoFloatingTextFieldView!
    @IBOutlet weak var receiverEmailView: PekoFloatingTextFieldView!
    @IBOutlet weak var receiverMobileView: PekoFloatingTextFieldView!
    @IBOutlet weak var receiverPoBoxView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var senderNameView: PekoFloatingTextFieldView!
    @IBOutlet weak var senderEmailView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var msgView: PekoFloatingTextFieldView!
    
    
    
    static func storyboardInstance() -> GiftCardsAddAddressViewController? {
        return AppStoryboards.GiftCards.instantiateViewController(identifier: "GiftCardsAddAddressViewController") as? GiftCardsAddAddressViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Gift Cards")
        self.view.backgroundColor = .white
        
        self.addTableView.tableHeaderView = self.headerView
      //  self.addTableView.tableFooterView = self.footerView
        self.addTableView.backgroundColor = .clear
        self.addTableView.separatorStyle = .none
        
      //  self.addressTableView.register(UINib(nibName: "AddressListTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressListTableViewCell")
      //  self.addressTableView.delegate = self
      //  self.addressTableView.dataSource = self
        
        self.setData()
        
        // Do any additional setup after loading the view.
    }
    
    func setData() {
        /*
        self.productNameLabel.text = objGiftCardManager?.productModel?.name ?? ""
       
        self.descriptionLabel.text = "\(objGiftCardManager?.quality ?? 0) Gift Cards | \(objUserSession.currency) \((objGiftCardManager?.amount ?? 0.0 ).withCommas()) each"
        
        if objGiftCardManager?.productModel?.image != nil {
            self.productImgView.sd_setImage(with: URL(string: (objGiftCardManager?.productModel?.image ?? "")), placeholderImage: nil)
        }else{
            self.productImgView.sd_setImage(with: URL(string: objGiftCardManager?.productModel?.images?.small ?? ""), placeholderImage: nil)
        }
        */
        self.descriptionLabel.text = "\(objGiftCardManager?.quality ?? 0) Gift Cards | \(objUserSession.currency) \((objGiftCardManager?.amount ?? 0.0 ).withCommas()) each"
        
        self.productNameLabel.text = objGiftCardManager?.productUAEModel?.name ?? ""
       
        if objGiftCardManager?.productUAEModel?.image != nil {
            self.productImgView.sd_setImage(with: URL(string: (objGiftCardManager?.productUAEModel?.image ?? "")), placeholderImage: nil)
        }else{
            self.productImgView.sd_setImage(with: URL(string: objGiftCardManager?.productUAEModel?.image ?? ""), placeholderImage: nil)
        }
        
    }
    // MARK: - Save Address
    @IBAction func saveAddressButtonClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    // MARK: - Buy Now
    
    
    // MARK: - Navigation
    @IBAction func buyNowButtonClick(_ sender: Any) {
       
        let request = GiftCardRequest(firstName: self.receiverNameView.text!, email: self.receiverEmailView.text!, mobileNumber: self.receiverMobileView.text!, message: self.msgView.text!)
        
        let validationResult = GiftCardValidation().Validate(request: request)

        if validationResult.success {
            objGiftCardManager?.addressRequest = request
            
             if let paymentReviewVC = PaymentReviewViewController.storyboardInstance() {
                 paymentReviewVC.paymentPayNow = .GiftCard
                 self.navigationController?.pushViewController(paymentReviewVC, animated: true)
             }
        }else{
            self.showAlert(title: "", message: validationResult.error!)
        }
    }
    
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
