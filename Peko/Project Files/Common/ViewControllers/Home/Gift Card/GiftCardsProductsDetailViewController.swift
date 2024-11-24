//
//  GiftCardsProductsDetailViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 10/05/23.
//

import UIKit

import KMPlaceholderTextView
import WDScrollableSegmentedControl
//import /*DGSegmentedControl*/

class GiftCardsProductsDetailViewController: MainViewController {

    @IBOutlet weak var amountLabel: PekoLabel!
   // @IBOutlet weak var buyButtonContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
  
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var redemptionInstructionsLabel: UILabel!
    @IBOutlet weak var termConditionLabel: PekoLabel!
    
  //  @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewContainerView: UIView!
    @IBOutlet weak var amountTxtContainerView: UIView!
  
    @IBOutlet weak var collectionContainerViewheightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var amountTxt: PekoFloatingTextFieldView!
    //@IBOutlet weak var amountTxt: UITextField!
   // @IBOutlet weak var segmentControl: WDScrollableSegmentedControl!
    @IBOutlet weak var segmentControl: WDScrollableSegmentedControl!
    
    @IBOutlet weak var qtyView: PekoFloatingTextFieldView!
    @IBOutlet weak var minMaxAmountLabel: UILabel!
    
    @IBOutlet weak var buyNowButton: UIButton!
    @IBOutlet weak var amountStackView: UIStackView!
    /*
    @IBOutlet weak var buyProductTitleLabel: UILabel!
    
    @IBOutlet weak var recFirstNameTxt: UITextField!
    
    @IBOutlet weak var recLastNameTxt: UITextField!
    @IBOutlet weak var genderTxt: UITextField!
   
    @IBOutlet weak var recMobileNoTxt: UITextField!
    @IBOutlet weak var recEmailTxt: UITextField!
    
    @IBOutlet weak var recPOBoxTxt: UITextField!
    @IBOutlet weak var senderNameTxt: UITextField!
    @IBOutlet weak var msgTxt: KMPlaceholderTextView!
    */
    @IBOutlet weak var buyForSelfButton: UIButton!
    @IBOutlet weak var GiftFriendButton: UIButton!
    
    
    
    //   var product:GiftCardProductModel?
    // var sku:String = ""
   // var selectedIndex = 0
    
    static func storyboardInstance() -> GiftCardsProductsDetailViewController? {
        return AppStoryboards.GiftCards.instantiateViewController(identifier: "GiftCardsProductsDetailViewController") as? GiftCardsProductsDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Gift Cards")
        self.view.backgroundColor = .white
        objGiftCardManager = GiftCardManager.sharedInstance
        
       // self.getProductDetail()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .clear
        
        segmentControl.delegate = self
        segmentControl.font = AppFonts.Medium.size(size: 16)
        segmentControl.buttonSelectedColor = .redButtonColor
        segmentControl.buttonHighlightColor = .redButtonColor
        segmentControl.buttonColor = .grayTextColor // UIColor(named: "999999")!
        segmentControl.indicatorColor = .redButtonColor
        //segmentControl.normalIndicatorColor = UIColor(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1.0)
        segmentControl.indicatorHeight = 3
        segmentControl.buttons = ["About", "Redemption Instructions", "Terms & Conditions"]
        segmentControl.leftAlign = true
       // segmentControl.backgroundColor = .red
        
      ////  self.amountTxt.delegate = self
//        self.recMobileNoTxt.delegate = self
//        self.recPOBoxTxt.delegate = self
//
        objGiftCardManager?.amount = 0
      //  self.amountStackView.isHidden = false
        
        DispatchQueue.main.async {
            self.setData()
        }
        self.buyForSelfButtonClick(self.buyForSelfButton)
        
        amountTxt.delegate = self
        qtyView.delegate = self
        
    }
    
    //MARK:- Actions
//    @objc func segmentValueChanged(segmentControl: DGSegmentedControl){
//       
//    }

    
    // MARK: - Radio Button
    @IBAction func buyForSelfButtonClick(_ sender: Any) {
     
        self.buyForSelfButton.isSelected = true
        self.GiftFriendButton.isSelected = false
        
    }
    @IBAction func giftFriendButtonClick(_ sender: Any) {
        
        self.buyForSelfButton.isSelected = false
        self.GiftFriendButton.isSelected = true
        
    }
   
    // MARK: -
    func setData(){
      
        self.qtyView.text = "\(objGiftCardManager?.quality ?? 1)"
      
        self.redemptionInstructionsLabel.isHidden = true
        self.descriptionLabel.isHidden = false
        self.termConditionLabel.isHidden = false
      //  self.buyProductTitleLabel.text = "Buy " + (objGiftCardManager?.productModel?.name ?? "")//
        let color = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0)
        
        self.productImgView.sd_setImage(with: URL(string: (objGiftCardManager?.productUAEModel?.image ?? "")), placeholderImage: nil)
        
        self.productNameLabel.text = objGiftCardManager?.productUAEModel?.name ?? ""
        
        
        self.descriptionLabel.attributedText = NSMutableAttributedString().color(color, (objGiftCardManager?.productUAEModel?.description ?? ""), font: .regular(size: 14), 8)
        
        self.redemptionInstructionsLabel.attributedText = NSMutableAttributedString().color(color, (objGiftCardManager?.productUAEModel?.redemption_instructions ?? "").html2AttributedString!, font: .regular(size: 14), 8)
       
        self.termConditionLabel.attributedText = NSMutableAttributedString().color(color, (objGiftCardManager?.productUAEModel?.term_and_conditions ?? "").html2AttributedString!, font: .regular(size: 14), 8)
        
        if objGiftCardManager?.productUAEModel?.priceType?.lowercased() == "flexi" {
            self.collectionViewContainerView.isHidden = true
            self.amountTxtContainerView.isHidden = false
            
            self.minMaxAmountLabel.text = "Min: \(objUserSession.currency)\(objGiftCardManager?.productUAEModel?.minDenomination ?? "") and Max: \(objUserSession.currency)\(objGiftCardManager?.productUAEModel?.maxDenomination ?? "")"
            
            if objGiftCardManager?.productUAEModel?.image != nil {
                self.productImgView.sd_setImage(with: URL(string: (objGiftCardManager?.productUAEModel?.image ?? "")), placeholderImage: nil)
            }else{
                self.productImgView.sd_setImage(with: URL(string: objGiftCardManager?.productUAEModel?.image ?? ""), placeholderImage: nil)
            }
        }else{
            self.collectionViewContainerView.isHidden = false
            
            let number:Double = Double((objGiftCardManager?.productUAEModel?.denominations?.count ?? 0)) / 3.0
            let height = 62 * number.rounded()
            self.collectionContainerViewheightConstraint.constant = height
            
            self.amountTxtContainerView.isHidden = true
            self.collectionView.reloadData()
            
        }
        
       
        
        
        /*
        segmentControl.items = ["About", "Redemption Instructions", "Terms & Condition"]
       
        segmentControl.font = .medium(size: 14)// UIFont(name: "Avenir-Black", size: 12)
        segmentControl.borderColor = UIColor(named: "999999")
        segmentControl.selectedIndex = 0
        segmentControl.borderSize = 1
        segmentControl.thumbColor = .redButtonColor
        segmentControl.selectedLabelColor = .redButtonColor
        segmentControl.thumUnderLineSize = 4
        segmentControl.unselectedLabelColor = UIColor(named: "999999")!
     //   segmentControl.font = UIFont.systemFont(ofSize: 18)
        segmentControl.addTarget(self, action:#selector(segmentValueChanged(segmentControl:)), for: .valueChanged)
   */
        self.setAmount()
    }
    // MARK: - Buy Now
    @IBAction func buyNowButtonClick(_ sender: Any) {
        
        if objShareManager.appTarget == .PekoUAE {
            if objGiftCardManager?.productUAEModel?.priceType?.lowercased() == "flexi" {
                 if self.amountTxt.text?.count == 0 {
                    self.showAlert(title: "", message: "Please enter an amount")
                    return
                }
                
                let amount = Double(self.amountTxt.text ?? "0.0")
                let min = objGiftCardManager?.productUAEModel?.minDenomination?.toDouble() //Double(objGiftCardManager?.productUAEModel?.minDenomination ?? "0.0")
                let max = objGiftCardManager?.productUAEModel?.maxDenomination?.toDouble()// Double(objGiftCardManager?.productUAEModel?.maxDenomination ?? "0.0")
                
                if(amount! < min! || amount! > max!)
                {
                    self.showAlert(title: "", message: "Please enter an amount between min and max")
                    return
                }
                objGiftCardManager?.amount = amount ?? 0.0
                self.amountTxt.resignFirstResponder()
            }else{
                if objGiftCardManager?.amount == 0.0 {
                    self.showAlert(title: "", message: "Please select an amount")
                    return
                }
            }
        }else{
           
            if self.amountTxt.text?.count == 0 {
                self.showAlert(title: "", message: "Please enter an amount")
                return
            }
            
            let amount = Double(self.amountTxt.text ?? "0.0")
//            let min = Double(objGiftCardManager?.productIndiaModel?.min_price ?? "0.0")
//            let max = Double(objGiftCardManager?.productIndiaModel?.max_price ?? "0.0")
            
//            if(amount! < min! || amount! > max!)
//            {
//                self.showAlert(title: "", message: "Please enter an amount between min and max")
//                return
//            }
            objGiftCardManager?.amount = amount ?? 0.0
            self.amountTxt.resignFirstResponder()
            
        }
        
        objGiftCardManager?.quality = Int(self.qtyView.text!) ?? 0
        self.goToReviewVC()
       
    }
    func goToReviewVC(){
        
        if let addVC = GiftCardsAddAddressViewController.storyboardInstance() {
            self.navigationController?.pushViewController(addVC, animated: true)
        }
        
//        if let paymentReviewVC = PaymentReviewViewController.storyboardInstance() {
//            paymentReviewVC.paymentPayNow = .GiftCard
//            self.navigationController?.pushViewController(paymentReviewVC, animated: true)
//        }
      
    }
    func setAmount(){
        var amount = 0.0
        if objGiftCardManager?.productUAEModel?.priceType?.lowercased() == "flexi" {
            if self.amountTxt.text?.count == 0 {
                // self.buyButtonContainerViewHeightConstraint.constant = 0
                amount = 0.0
   
            }else{
                //  self.buyButtonContainerViewHeightConstraint.constant = 72
                amount = Double(self.amountTxt.text ?? "0.0")!
    
            }
        }else{
            amount = objGiftCardManager?.amount ?? 0.0
        }
       
        if amount == 0.0 {
            self.buyNowButton.isUserInteractionEnabled = false
            self.buyNowButton.alpha = 0.5
        }else{
            self.buyNowButton.isUserInteractionEnabled = true
            self.buyNowButton.alpha = 1.0
        }
        
        let qty = Int(self.qtyView.text!)
        amount = amount * Double(qty ?? 0)
        self.amountLabel.text = objUserSession.currency + " " + amount.withCommas()
        
    }
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }

}
extension GiftCardsProductsDetailViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if objGiftCardManager?.productUAEModel != nil {
            // HARDIK
            return objGiftCardManager?.productUAEModel?.denominations?.count ?? 0
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenWidth - 70) / 3
        return CGSize(width: width, height: 52)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftCardAmountCollectionViewCell", for: indexPath) as! GiftCardAmountCollectionViewCell
        cell.conatinerView.backgroundColor = .clear
        
        let amount = objGiftCardManager?.productUAEModel?.denominations?[indexPath.row]
        
        cell.amountLabel.text = objUserSession.currency + "\(amount?.value ?? 0)"
      //  cell.payLabel.text = "You pay \(objUserSession.currency)" + "\(amount?.value ?? 0)"
        
    
        
        if amount?.value == objGiftCardManager?.amount {
            cell.conatinerView.borderColor = .redButtonColor
            cell.amountLabel.textColor = .redButtonColor
        }else{
            
            let color = UIColor(red: 108 / 255.0, green: 108 / 255.0, blue: 108 / 255.0, alpha: 1.0)
            cell.conatinerView.borderColor = color
            cell.amountLabel.textColor = color
        }
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let amount = objGiftCardManager?.productUAEModel?.denominations?[indexPath.row]
        
        objGiftCardManager?.amount = amount?.value ?? 0.0
      //  self.buyButtonContainerViewHeightConstraint.constant = 72
        self.amountStackView.isHidden = false
       
        self.amountLabel.text = objUserSession.currency + " " + (objGiftCardManager?.amount.withCommas())!
        self.setAmount()
        collectionView.reloadData()
        
    }
}
/*
extension GiftCardsProductsDetailViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
    {
        if textField == self.amountTxt {
            return textField.decimalNumberValidation(number: string)
        }
        if textField == self.recMobileNoTxt ||  textField == self.recPOBoxTxt {
            return textField.numberValidation(number: string)
        }
        return false //textField.decimalNumberValidation(number: string)

    }
}
*/
extension GiftCardsProductsDetailViewController:PekoFloatingTextFieldViewDelegate{
    func textChange(textView: PekoFloatingTextFieldView) {
        if textView == self.amountTxt {
            self.setAmount()
        }
    }
    
    func dropDownClick(textView: PekoFloatingTextFieldView) {
        if qtyView == textView {
            let pickerVC = PickerListViewController.storyboardInstance()
            pickerVC?.array = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
            pickerVC?.selectedString = self.qtyView.text!
            pickerVC?.titleString = "Quantity"
            pickerVC?.completionBlock = { string in
//                DispatchQueue.main.async {
//
//                }
                self.qtyView.text = string
               
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.setAmount()
                }
            }
            let nav = UINavigationController(rootViewController: pickerVC!)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
}


// MARK: - CollectionViewCell
class GiftCardAmountCollectionViewCell:UICollectionViewCell {
    
    @IBOutlet weak var amountLabel: UILabel!
    
//    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var conatinerView: UIView!
    
}
// MARK: - Segment
extension GiftCardsProductsDetailViewController:WDScrollableSegmentedControlDelegate{
    func didSelectButton(at index: Int) {
        DispatchQueue.main.async {
            if index == 0 {
                self.redemptionInstructionsLabel.isHidden = true
                self.descriptionLabel.isHidden = false
                self.termConditionLabel.isHidden = true
            }else if index == 1 {
                self.redemptionInstructionsLabel.isHidden = false
                self.descriptionLabel.isHidden = true
                self.termConditionLabel.isHidden = true
            }else if index == 2 {
                self.redemptionInstructionsLabel.isHidden = true
                self.descriptionLabel.isHidden = true
                self.termConditionLabel.isHidden = false
            }
        }
    }
}
