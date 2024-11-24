//
//  SavedAddressViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 21/02/24.
//

import UIKit

class SavedAddressViewController: MainViewController {

    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet var headerView: UIView!
    
    var addressArray = [AddressModel]()
    var isSkeletonView = true
    
    static func storyboardInstance() -> SavedAddressViewController? {
        return AppStoryboards.Account.instantiateViewController(identifier: "SavedAddressViewController") as? SavedAddressViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Saved Addresses")
        self.view.backgroundColor = .white
       
        self.noDataView.isHidden = true
        self.addressTableView.delegate = self
        self.addressTableView.dataSource = self
        self.addressTableView.backgroundColor = .clear
        self.addressTableView.separatorStyle = .none
        self.addressTableView.register(UINib(nibName: "SavedTableViewCell", bundle: nil), forCellReuseIdentifier: "SavedTableViewCell")
        self.addressTableView.isUserInteractionEnabled = false
        
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getAddress()
    }
    // MARK: - Address
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
                   //  self.addreessTableView.tableFooterView = self.footerView
                    self.addressTableView.isUserInteractionEnabled = true
                    self.isSkeletonView = false
                    self.addressTableView.reloadData()
                    
                    if self.addressArray.count == 0 {
                        self.noDataView.isHidden = false
                        self.addressTableView.tableHeaderView = nil
                    }else{
                        self.noDataView.isHidden = true
                        self.addressTableView.tableHeaderView = self.headerView
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
    
    // MARK: - ADD ADDRESS
    @IBAction func addAddressButtonClick(_ sender: Any) {
        if let addVC = AddAddressViewController.storyboardInstance() {
            self.navigationController?.pushViewController(addVC, animated: true)
        }
    }
}
// MARK: -
extension SavedAddressViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSkeletonView {
            return 10
        }
        return self.addressArray.count
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 93
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedTableViewCell") as! SavedTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        cell.deleteButton.removeTarget(self, action: nil, for: .allEvents)
        cell.editButton.removeTarget(self, action: nil, for: .allEvents)
        
        if self.isSkeletonView {
            cell.view_1.showAnimatedGradientSkeleton()
        }else{
            cell.view_1.hideSkeleton()
           
            let address = self.addressArray[indexPath.row]
            cell.titleLabel.text = address.name ?? ""

            var array:[String] = [(address.addressLine1 ?? ""), (address.addressLine2 ?? ""), (address.city ?? ""), (address.country ?? ""), (address.zipCode ?? "")]
            array = array.filter({ $0 != ""})
            var string = array.joined(separator: ", ")
            
            if (address.is_default?.value ?? false) {
                string = string + "\n(Default)"
            }
            
            cell.subTitleLabel.text = string
            
      
            cell.deleteButton.tag = indexPath.row
            cell.editButton.tag = indexPath.row
            
            cell.deleteButton.addTarget(self, action: #selector(deleteAddressButtonClick(sender:)), for: .touchUpInside)
            cell.editButton.addTarget(self, action: #selector(updateAddressButtonClick(sender:)), for: .touchUpInside)
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
