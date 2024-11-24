//
//  PekoStoreAddressListViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 08/03/24.
//

import UIKit
import SkeletonView
class PekoStoreAddressListViewController: MainViewController {

    @IBOutlet var footerView: UIView!
    @IBOutlet weak var addreessTableView: UITableView!
    
    var isSkeletonView = true
    var addressArray = [AddressModel]()
    
    var selectedAddressIndex = -1
    
    static func storyboardInstance() -> PekoStoreAddressListViewController? {
        return AppStoryboards.PekoStore.instantiateViewController(identifier: "PekoStoreAddressListViewController") as? PekoStoreAddressListViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isBackNavigationBarView = true
        self.setTitle(title: "Address")
        self.view.backgroundColor = .white
        
        
        self.addreessTableView.delegate = self
        self.addreessTableView.dataSource = self
        self.addreessTableView.separatorStyle = .none
        self.addreessTableView.register(UINib(nibName: "AddressListTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressListTableViewCell")
        
       // self.addreessTableView.tableFooterView = self.footerView
        self.addreessTableView.isUserInteractionEnabled = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getAddress()
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
                    
                    self.addressArray = response.data?.data ?? [AddressModel]()
                    self.addreessTableView.tableFooterView = self.footerView
                    self.addreessTableView.isUserInteractionEnabled = true
                    self.isSkeletonView = false
                    self.addreessTableView.reloadData()
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
    
    // MARK: -
    @IBAction func addNewAddressButtonClick(_ sender: Any) {
        if let addVC = AddAddressViewController.storyboardInstance() {
            self.navigationController?.pushViewController(addVC, animated: true)
        }
    }
    
    
    // MARK: -
    @IBAction func continueButtonClick(_ sender: Any) {
        if self.selectedAddressIndex == -1 {
            self.showAlert(title: "", message: "Please select address")
        }else{
            objPekoStoreManager?.selectedAddress = self.addressArray[self.selectedAddressIndex]
            if let paymentVC = PaymentReviewViewController.storyboardInstance() {
                paymentVC.paymentPayNow = .PekoStore
                self.navigationController?.pushViewController(paymentVC, animated: true)
            }
        }
    }
    
}

// MARK: - TableView
extension PekoStoreAddressListViewController:UITableViewDelegate, UITableViewDataSource {
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
}
