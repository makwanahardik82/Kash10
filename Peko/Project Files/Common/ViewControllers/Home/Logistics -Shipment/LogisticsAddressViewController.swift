//
//  LogisticsAddressViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 09/03/24.
//

import UIKit

class LogisticsAddressViewController: MainViewController {

    @IBOutlet weak var addreessTableView: UITableView!
  
    var completionBlock:((_ address: AddressModel) -> Void)?
  
    var isReceiver = false
    
  
    var isSkeletonView = true
    var addressArray = [AddressModel]()
    var selectedAddressIndex = -1
    
    static func storyboardInstance() -> LogisticsAddressViewController? {
        return AppStoryboards.Logistics.instantiateViewController(identifier: "LogisticsAddressViewController") as? LogisticsAddressViewController
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
      //  self.addreessTableView.isUserInteractionEnabled = false
        DispatchQueue.main.async {
            self.getSavedAddress()
        }
        // Do any additional setup after loading the view.
    }
    func getSavedAddress() {
        LogisticsViewModel().getSavedAddress(isReceiver: isReceiver) { response, error in
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif
            }else if let status = response?.status, status == true{
                DispatchQueue.main.async {
                    if let arr = response?.data?.addresses as? [AddressModel]{
                        self.addressArray = arr
                    }
                    self.isSkeletonView = false
                    self.addreessTableView.reloadData()
                }
            } else{
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
    
    @IBAction func selectButtonClick(_ sender: Any) {
        if self.selectedAddressIndex == -1 {
            self.showAlert(title: "", message: "Please select address")
        }else{
            if completionBlock != nil {
                self.completionBlock!(self.addressArray[self.selectedAddressIndex])
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - TableView
extension LogisticsAddressViewController:UITableViewDelegate, UITableViewDataSource {
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
