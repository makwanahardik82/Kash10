//
//  InvoiceGeneratorItemDetailViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 08/06/23.
//

import UIKit


class InvoiceGeneratorItemDetailViewController: MainViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var footerView: UIView!
    @IBOutlet var headerView: UIView!
  
    @IBOutlet weak var subTotalLabel: PekoLabel!
    @IBOutlet weak var vatLabel: PekoLabel!
    @IBOutlet weak var discountLabel: PekoLabel!
    @IBOutlet weak var amountDueLabel: PekoLabel!
    
    var itemDetailsArray = [InvoiceItemDetailModel]()
    var request = InvoiceGeneratorRequestModel()
    
    static func storyboardInstance() -> InvoiceGeneratorItemDetailViewController? {
        return AppStoryboards.InvoiceGenerator.instantiateViewController(identifier: "InvoiceGeneratorItemDetailViewController") as? InvoiceGeneratorItemDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isBackNavigationBarView = true
        self.view.backgroundColor = .white
        self.setTitle(title: "Create Invoice")
     
        self.tableView.backgroundColor = .clear
        self.tableView.tableHeaderView = self.headerView
        self.tableView.tableFooterView = self.footerView
        
        self.tableView.register(UINib(nibName: "InvoiceItemTableViewCell", bundle: nil), forCellReuseIdentifier: "InvoiceItemTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        
    }
    // MARK: - textFieldDidChange
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        self.updateTotalAndBalance()
   // }
    // MARK: - Add Item
    @IBAction func addItemButtonClick(_ sender: Any) {
        
        if let addVC = InvoiceItemDetailViewController.storyboardInstance() {
            addVC.completionBlock = { itemModel in
                DispatchQueue.main.async {
                    self.itemDetailsArray.append(itemModel)
                    self.tableView.reloadData()
                    self.updateTotalAndBalance()
                }
            }
            self.navigationController?.pushViewController(addVC, animated: true)
        }
    }
  
    
    // MARK: - Update Total
    func updateTotalAndBalance(){
        
        let subTotalArray = self.itemDetailsArray.compactMap { Double($0.total ?? "0.0") }
        let vatArray = self.itemDetailsArray.compactMap { Double($0.vat ?? "0.0") }
        let discountArray = self.itemDetailsArray.compactMap { Double($0.discount ?? "0.0") }
        
        let subTotal = subTotalArray.reduce(0, +)
        let vatTotal = vatArray.reduce(0, +)
        let discountTotal = discountArray.reduce(0, +)
        
        let total = (subTotal + vatTotal) - discountTotal
        
        self.subTotalLabel.text = objUserSession.currency + subTotal.withCommas()
        self.vatLabel.text = objUserSession.currency + vatTotal.withCommas()
        self.discountLabel.text = objUserSession.currency + discountTotal.withCommas()
        self.amountDueLabel.text = objUserSession.currency + total.withCommas()
       
    }
    
    // MARK: - Create Invoice Button
    @IBAction func createInvoiceButtonClick(_ sender: Any) {
        if self.itemDetailsArray.count == 0 {
            self.showAlert(title: "", message: "Please add item")
        }else{
            objInvoiceGeneratorManager?.itemDetailArray = self.itemDetailsArray
            
            objInvoiceGeneratorManager?.subTotal = self.subTotalLabel.text?.replacingOccurrences(of: objUserSession.currency, with: "")
            
            objInvoiceGeneratorManager?.total = self.amountDueLabel.text?.replacingOccurrences(of: objUserSession.currency, with: "")
            
            self.generateInvoice()
        }
    }
    
    // MARK: - Create Invoice
    func generateInvoice() {
        HPProgressHUD.show()
        InvoiceGeneratorViewModel().createInvoice() { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response??.status, status == true {
                DispatchQueue.main.async {
                    self.showAlertWithCompletion(title: "", message: response??.message ?? "") { action in
                        self.navigationController?.popToRootViewController(animated: false)
                    }
                }
            }else{
                var msg = ""
                if response??.message != nil {
                    msg = response??.message ?? ""
                }else if response??.error?.count != nil {
                    msg = response??.error ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
    }
    
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }

}
extension InvoiceGeneratorItemDetailViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemDetailsArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceItemTableViewCell") as! InvoiceItemTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let itemModel = self.itemDetailsArray[indexPath.row]
      
        cell.titleLabel.text = (itemModel.qty ?? "") + " X " + (itemModel.desc ?? "")
        
        cell.amountLabel.text = (objUserSession.currency ) + (itemModel.price ?? "")
      
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let itemModelDetail = self.itemDetailsArray[indexPath.row]
      
        if let addVC = InvoiceItemDetailViewController.storyboardInstance() {
            addVC.isEdit = true
            addVC.itemDetailModel = itemModelDetail
            addVC.completionBlock = { itemModel in
                DispatchQueue.main.async {
                    self.itemDetailsArray[indexPath.row] = itemModel
                    self.tableView.reloadData()
                    self.updateTotalAndBalance()
                }
            }
            self.navigationController?.pushViewController(addVC, animated: true)
        }
    }
}
