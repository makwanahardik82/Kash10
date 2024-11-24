//
//  GiftCardsSelectAddressViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 23/02/24.
//

import UIKit
import SkeletonView
class GiftCardsSelectAddressViewController: MainViewController {

    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
   
    @IBOutlet var headerView: UIView!
    @IBOutlet var footerView: UIView!
    
    @IBOutlet weak var addressTableView: UITableView!
 
    var selectedAddressIndex = -1
    var isSkeletonView = true
    var addressArray = [AddressModel]()
    
    static func storyboardInstance() -> GiftCardsSelectAddressViewController? {
        return AppStoryboards.GiftCards.instantiateViewController(identifier: "GiftCardsSelectAddressViewController") as? GiftCardsSelectAddressViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.isBackNavigationBarView = true
        self.setTitle(title: "Gift Cards")
        self.view.backgroundColor = .white
       
        self.addressTableView.tableHeaderView = self.headerView
        self.addressTableView.backgroundColor = .clear
        self.addressTableView.separatorStyle = .none
        
        self.addressTableView.register(UINib(nibName: "AddressListTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressListTableViewCell")
        self.addressTableView.delegate = self
        self.addressTableView.dataSource = self
        
        self.setData()
        addressTableView.isUserInteractionEnabled = false
        self.getAddress()
        // Do any additional setup after loading the view.
    }
// MARK: - Set Data
    func setData() {
        
        self.descriptionLabel.text = "\(objGiftCardManager?.quality ?? 0) Gift Cards | \(objUserSession.currency) \((objGiftCardManager?.amount ?? 0.0 ).withCommas()) each"
        
        self.productNameLabel.text = objGiftCardManager?.productUAEModel?.name ?? ""
       
        if objGiftCardManager?.productUAEModel?.image != nil {
            self.productImgView.sd_setImage(with: URL(string: (objGiftCardManager?.productUAEModel?.image ?? "")), placeholderImage: nil)
        }else{
            self.productImgView.sd_setImage(with: URL(string: objGiftCardManager?.productUAEModel?.image ?? ""), placeholderImage: nil)
        }
    }
    // MARK: - Get Address
    func getAddress(){
        ProfileViewModel().getAddreess { response, error in
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response.status, status == true {
                DispatchQueue.main.async {
                    
                    if objShareManager.appTarget == .PekoUAE {
                        self.addressArray = response.data?.data ?? [AddressModel]()
                    }else{
                        self.addressArray = response.data?.addressDetails ?? [AddressModel]()
                    }
                    self.addressTableView.tableFooterView = self.footerView
                    self.addressTableView.isUserInteractionEnabled = true
                    self.isSkeletonView = false
                    self.addressTableView.reloadData()
                }
            }else{
                var msg = ""
                if response.message != nil {
                    msg = response.message
                    ?? ""
                }else if response.error?.count != nil {
                    msg = response.error ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
    }
    // MARK: - Add Address
    @IBAction func addNewAddressButtonClick(_ sender: Any) {
        if let newAddVC = GiftCardsAddAddressViewController.storyboardInstance() {
            self.navigationController?.pushViewController(newAddVC, animated: true)
        }
    }
    
    // MARK: - Buy Now
    @IBAction func buyNowButtonClick(_ sender: Any) {
        if selectedAddressIndex == -1 {
            self.showAlert(title: "", message: "Please select the address")
        }else{
            objGiftCardManager?.address = self.addressArray[self.selectedAddressIndex]
            
            if let paymentReviewVC = PaymentReviewViewController.storyboardInstance() {
                paymentReviewVC.paymentPayNow = .GiftCard
                self.navigationController?.pushViewController(paymentReviewVC, animated: true)
            }
        }
        
    }
    
}
// MARK: - Navigation
extension GiftCardsSelectAddressViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSkeletonView {
            return 10
        }
        return self.addressArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressListTableViewCell") as! AddressListTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        if self.isSkeletonView {
            cell.view_1.showAnimatedGradientSkeleton()
        }else{
            cell.view_1.hideSkeleton()
            
            let address = self.addressArray[indexPath.row]
            
            var array:[String] = [(address.addressLine1 ?? ""), (address.addressLine2 ?? ""), (address.city ?? ""), (address.country ?? ""), (address.zipCode ?? "")]
            array = array.filter({ $0 != ""})
            cell.detailLabel.text = array.joined(separator: ", ")
            cell.emailLabel.text = address.email ?? "-"
            cell.phoneNumberLabel.text = address.phoneNumber ?? "-"
            
            if address.is_default?.value ?? false {
                cell.nameLabel.attributedText = NSMutableAttributedString().color(.black, (address.name ?? ""), font: .bold(size: 16)).color(.gray, " (Default)", font: .regular(size: 14))
            }else{
                cell.nameLabel.text = address.name ?? ""
            }
            
            if self.selectedAddressIndex == indexPath.row {
                cell.radioImgView.image = UIImage(named: "icon_radio_selected_red")
            }else{
                cell.radioImgView.image = UIImage(named: "icon_radio_unselected_red")
            }
            
            cell.deleteButton.tag = indexPath.row
            cell.editButton.tag = indexPath.row
            
            cell.deleteButton.addTarget(self, action: #selector(deleteAddressButtonClick(sender:)), for: .touchUpInside)
            cell.editButton.addTarget(self, action: #selector(updateAddressButtonClick(sender:)), for: .touchUpInside)
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isSkeletonView {
            
        }else{
            self.selectedAddressIndex = indexPath.row
            tableView.reloadData()
        }
    }
    
    // MARK: - Update
    @objc func updateAddressButtonClick(sender:UIButton) {
        if let addVC = AddAddressViewController.storyboardInstance() {
            addVC.isEdit = true
            addVC.addressModel = self.addressArray[sender.tag]
            self.navigationController?.pushViewController(addVC, animated: true)
        }
    }
    
    // MARK: - Delete
    @objc func deleteAddressButtonClick(sender:UIButton) {
        let action = UIAlertController(title: "", message: "Are you sure you want to delete this address?", preferredStyle: .actionSheet)
        
        action.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            self.deleteAddress(index: sender.tag)
        }))
        action.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
        
        self.present(action, animated: true)
    }
    
    // MARK: -
    func deleteAddress(index:Int) {
        HPProgressHUD.show()
        
        let ids = self.addressArray[index].id ?? 0
        
        ProfileViewModel().deleteAddreess(id: ids) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response.status, status == true {
                DispatchQueue.main.async {
                    self.showAlertWithCompletion(title: "", message: (response.message ?? "").capitalized) { action in
                        self.addressArray.remove(at: index)
                        self.addressTableView.reloadData()
                        
                        if self.addressArray.count == 0 {
                            self.getAddress()
                        }
                        
                    }
                }
            }else{
                var msg = ""
                if response.message != nil {
                    msg = response.message
                    ?? ""
                }else if response.error?.count != nil {
                    msg = response.error ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
    }
    
}
