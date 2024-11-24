//
//  PekoStoreTrolleyViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 19/05/23.
//

import UIKit

import KMPlaceholderTextView

class PekoStoreTrolleyViewController: MainViewController {

    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet var footerView: UIView!
  
    
    @IBOutlet weak var pickerCOntainerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var vatChargeLabel: PekoLabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var grandTotalLabel: UILabel!
    
    @IBOutlet weak var totalItemLabel: UILabel!
    
    var pickerRowCount = 0
    
//    var cardModelArray = [PekoStoreCartModel]()
//    var :?
    
    static func storyboardInstance() -> PekoStoreTrolleyViewController? {
        return AppStoryboards.PekoStore.instantiateViewController(identifier: "PekoStoreTrolleyViewController") as? PekoStoreTrolleyViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.isBackNavigationBarView = true
        self.setTitle(title: "Trolley")
        self.view.backgroundColor = .white
        self.cartTableView.delegate = self
        self.cartTableView.dataSource = self
        
        self.cartTableView.backgroundColor = .clear
        self.cartTableView.tableFooterView = self.footerView
        self.cartTableView.register(UINib(nibName: "PekoStoreCartTableViewCell", bundle: nil), forCellReuseIdentifier: "PekoStoreCartTableViewCell")
        self.cartTableView.separatorStyle = .none
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerCOntainerView.isHidden = true
        
      //  self.phoneNumberTxt.delegate = self
        self.cartTableView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getCartDetails()
    }
    // MARK: - Get Cart Detail
    func getCartDetails(){
        HPProgressHUD.show()
        PekoStoreTrolleyViewModel().getCartDetails() { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    objPekoStoreManager?.cartDetailModel = response?.data
                    
                 //   self.cardModelArray = response?.data ?? [PekoStoreCartModel]()
                    
                    if response?.data?.count == 0 {
                        self.cartTableView.isHidden = true
                    }else{
                        self.cartTableView.isHidden = false
                    }
                    
                    self.cartTableView.reloadData()
                    
                    self.subTotalLabel.text = objUserSession.currency + Double(response?.data?.itemsTotalAmount?.value ?? 0).withCommas()
                    
                    self.vatChargeLabel.text = "Inclusive" //"AED " + Double(response?.totalVat?.value ?? 0).withCommas()
                    self.discountLabel.text = objUserSession.currency + "0"
                    let charge = response?.data?.shippingCharge?.value ?? 0.0
//                    if (response?.data?.itemsTotalAmount?.value ?? 0.0) < 350 {
//                        charge = 15.0
//                    }
                    self.deliveryLabel.text = objUserSession.currency + charge.withCommas()
                    self.grandTotalLabel.text = objUserSession.currency + Double((response?.data?.grandTotal?.value ?? 0) + charge).withCommas()
                    
                    self.totalItemLabel.text = "Total \(response?.data?.count ?? 0) Items"
                }
            }else{
                var msg = ""
                if response?.message != nil {
                    msg = response?.message ?? ""
                }
                else if response?.error != nil {
                    msg = response?.error ?? ""
                }
                objPekoStoreManager?.cartDetailModel = nil
                self.cartTableView.reloadData()
                self.cartTableView.isHidden = true
              //  self.showAlert(title: "", message: msg)
                self.showAlertWithCompletion(title: "", message: msg) { action in
                    self.navigationController?.popViewController(animated: false)
                }
            }
        }
    }
    
    // MARK: - QTY
    @objc func qtyPlusButtonClick(sender:UIButton) {
        let cart_product = objPekoStoreManager?.cartDetailModel?.items![sender.tag]
       
        let qty = (cart_product?.productQuantity ?? 0) + 1
        
        if qty < (cart_product?.productQuantityInDB ?? 0) {
            self.updateProductQTY(productID: cart_product?.id ?? 0, isAdd: true)
        }else{
            self.showAlert(title: "", message: "Product is Out of Stock")
        }
    }
    @objc func qtyMinusButtonClick(sender:UIButton) {
        let cart_product = objPekoStoreManager?.cartDetailModel?.items![sender.tag]
       
        let qty = (cart_product?.productQuantity ?? 0) - 1
        
        if qty > 0 {
            self.updateProductQTY(productID: cart_product?.id ?? 0, isAdd: false)
        }else{
            
            let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            action.addAction(UIAlertAction(title: "Remove from cart", style: .destructive, handler: { ac in
                self.deleteProduct(product: cart_product!)
            }))
            action.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(action, animated: true)
        }
    }
    // MARK: - QTY Button
    @objc func qtyButtonClick(sender:UIButton) {
        self.pickerView.tag = sender.tag
        
        let product = objPekoStoreManager?.cartDetailModel?.items![sender.tag]
        self.pickerRowCount = product?.productQuantityInDB ?? 0
        self.pickerView.reloadAllComponents()
        self.pickerView.selectRow((product?.productQuantity ?? 1) - 1, inComponent: 0, animated: true)
        self.pickerCOntainerView.isHidden = false
        
    }
    // MARK: - Remove From Cart
    @objc func removeButtonClick(sender:UIButton) {
        
        let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        action.addAction(UIAlertAction(title: "Remove from cart", style: .destructive, handler: { ac in
            let product = objPekoStoreManager?.cartDetailModel?.items![sender.tag]
            self.deleteProduct(product: product!)
        }))
        action.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(action, animated: true)
       
    }
   
    // MARK: - Picker Toolbar Buttons
    @IBAction func pickerViewCancelButtonClick(_ sender: Any) {
        self.pickerCOntainerView.isHidden = true
        
    }
    
    @IBAction func pickerViewDoneButtonClick(_ sender: Any) {
       // self.pickerCOntainerView.isHidden = true
       // let product = objPekoStoreManager?.cartDetailModel?.data![self.pickerView.tag]
       // self.updateProductQTY(product: product!)
    }
    // MARK: - Delete
    func deleteProduct(product:PekoStoreCartModel) {
        
        HPProgressHUD.show()
        PekoStoreDashboardViewModel().deleteProductFromCart(product_id: product.id ?? 0) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    
                    self.showAlertWithCompletion(title: "Success", message: response?.message ?? "") { action in
                        self.getCartDetails()
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
   
    // MARK: - Update QTY
    func updateProductQTY(productID:Int, isAdd:Bool) {
        let qty = self.pickerView.selectedRow(inComponent: 0)
        
        HPProgressHUD.show()
        PekoStoreDashboardViewModel().updateProductsQTY(product_id: productID, qty: 1, isAdd: isAdd) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    
                    self.showAlertWithCompletion(title: "Success", message: response?.message ?? "") { action in
                        self.getCartDetails()
                    }
                }
            }else{
                var msg = ""
                if response?.message != nil {
                    msg = response?.message
                    ?? ""
                }else if response?.error?.count != nil {
                    msg = response?.error ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
    }
    
    // Check Box
//    @IBAction func checkBoxButtonClick(_ sender: Any) {
//        self.checkBoxButton.isSelected = !self.checkBoxButton.isSelected
//    }
    
    // MARK : Apply Coupon
    @IBAction func applyCouponButtonClick(_ sender: Any) {
   
    }
    
    // MARK: - Select Address Button
    @IBAction func selectAddressButtonClick(_ sender: Any) {
        
    }
    
    // MARK: - Proceed to Pay Button
    @IBAction func proccedToPayButtonClick(_ sender: Any) {
  
        self.view.endEditing(true)
        if let addressVC = PekoStoreAddressListViewController.storyboardInstance() {
            self.navigationController?.pushViewController(addressVC, animated: true)
        }
       
    }
    
    // MARK: - Go to Success
//    func goToSuccessVC() {
//        if let successVC = PekoStoreOrderSuccessViewController.storyboardInstance() {
//            self.navigationController?.pushViewController(successVC, animated: true)
//        }
//    }
//
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }


}
extension PekoStoreTrolleyViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objPekoStoreManager?.cartDetailModel?.items!.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PekoStoreCartTableViewCell") as! PekoStoreCartTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let product = objPekoStoreManager?.cartDetailModel?.items![indexPath.row]
        
        cell.productNameLabel.text = product?.name ?? ""
        cell.brandNameLabel.text = (product?.brand)!
        cell.productImgView.sd_setImage(with: URL(string: (product?.productImage ?? "")), placeholderImage: nil)
        
        cell.amountLabel.text = objUserSession.currency + (product?.totalPrice?.value.withCommas())!
        cell.qtyLabel.text = "\(product?.productQuantity ?? 0)"
        
     //   cell.deliveryTimeLabel.text = "Included VAT (5%) AED \(product?.totalVat?.value.withCommas() ?? "0")"
     
        cell.minusButton.tag = indexPath.row
        cell.plusButton.tag = indexPath.row
        
        cell.minusButton.addTarget(self, action: #selector(qtyMinusButtonClick(sender: )), for: .touchUpInside)
        cell.plusButton.addTarget(self, action: #selector(qtyPlusButtonClick(sender: )), for: .touchUpInside)
        
//        cell.removeButton.tag = indexPath.row
//        cell.removeButton.addTarget(self, action: #selector(removeButtonClick(sender: )), for: .touchUpInside)
        
        return cell
    }
}

// MARK: - UiPickerView
extension PekoStoreTrolleyViewController:UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerRowCount
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
}
extension PekoStoreTrolleyViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
    {
//        if textField == self.phoneNumberTxt  {
//            return textField.numberValidation(number: string)
//        }
        return false //textField.decimalNumberValidation(number: string)
    }
}
