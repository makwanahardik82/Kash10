//
//  ElectricityDashboardViewController.swift
//  Peko India
//
//  Created by Hardik Makwana on 12/12/23.
//

import UIKit


class UtilityServiceProviderViewController: MainViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var segmentControl: PekoIndiaSegmentControl!
   
    @IBOutlet weak var providerTableView: UITableView!
   
    @IBOutlet weak var beneficiaryView: PekoFloatingTextFieldView!
    @IBOutlet weak var beneficiaryContainerStackView: UIStackView!
    
    @IBOutlet weak var searchView: PekoFloatingTextFieldView!
    @IBOutlet weak var stateView: PekoFloatingTextFieldView!
    @IBOutlet var headerView: UIView!
   
    @IBOutlet weak var beneficiaryNameLabel: UILabel!
    @IBOutlet weak var beneficiaryNumberLabel: UILabel!
    @IBOutlet weak var beneficiarySwitchButton: UIButton!
  
    
    var filter_BBPS_BillersArray = [BBPS_BillersModel]()
   
    
    var beneficiaryArray = [BeneficiaryDataModel]()
    var selectedBeneficiary :BeneficiaryDataModel?
  
    var categoryName = ""
    
    static func storyboardInstance() -> UtilityServiceProviderViewController? {
        return AppStoryboards.Utility.instantiateViewController(identifier: "UtilityServiceProviderViewController") as? UtilityServiceProviderViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: objUtilityBillsManager!.selectedUtilityBillName ?? "")
        self.view.backgroundColor = .white
        self.backNavigationView?.bharatBillPayImgView.isHidden = false

        
        self.setData()
        
        self.segmentControl.delegate = self
        
        self.providerTableView.delegate = self
        self.providerTableView.dataSource = self
        self.providerTableView.register(UINib(nibName: "ElectricityProviderTableViewCell", bundle: nil), forCellReuseIdentifier: "ElectricityProviderTableViewCell")
        self.providerTableView.separatorStyle = .none
        
        self.beneficiaryContainerStackView.isHidden = true
        
        self.searchView.delegate = self
        // Do any additional setup after loading the view.
    }
    // MARK: - SCREEN DATA
    func setData(){
        
        self.stateView.isHidden = true
        self.headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 91)
        
        switch objUtilityBillsManager!.selectedUtilityBillType {
        case .Electricity:
            self.setTitle(title: "Electricity")
            categoryName = "Electricity"
            self.stateView.isHidden = false
            self.headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 160)
         
            break
        case .Broadband:
            self.setTitle(title: "Broadband")
            categoryName = "Broadband Postpaid"
            break
        case .LPGCylinder:
            self.setTitle(title: "LPG Cylinder")
            categoryName = "LPG Gas"
            break
        case .PipedGas:
            self.setTitle(title: "Piped Gas")
            categoryName = "Gas"
            break
        case .Water:
            self.setTitle(title: "Water")
            categoryName = "Water"
            break
        case .EducationFee:
            self.setTitle(title: "Education Fee")
            categoryName = "Education Fees"
            break
        case .Landline:
            self.setTitle(title: "Landline")
            categoryName = "Landline Postpaid"
            break
        case .none:
            break
        }
        self.providerTableView.tableHeaderView = self.headerView
        
        if self.stateView.isHidden {
            self.getBBPS_BillersList()
        }
    }
    func getBBPS_BillersList(){
        HPProgressHUD.show()
        UtilityBillsViewModel().getBBPS_BillersList(categoryName: self.categoryName, state: self.stateView.text!) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    print(response?.data)
                    objUtilityBillsManager!.all_BBPS_BillersArray = response?.data ?? [BBPS_BillersModel]()
                    self.filter_BBPS_BillersArray = objUtilityBillsManager!.all_BBPS_BillersArray
             
                    self.providerTableView.reloadData()
                }
            }else{
                var msg = ""
                if response?.message != nil {
                    msg = response?.message ?? ""
                }
                self.showAlert(title: "", message: msg)
                HPProgressHUD.hide()
            }
        }
    }
    
    // MARK: - Beneficiary Button Click
    @IBAction func addBeneficiaryButtonClick(_ sender: Any) {
        if let addBeneficiaryVC = UItilityAddBeneficiaryViewController.storyboardInstance() {
          //  addBeneficiaryVC.isPostpaid = self.isPostpaid
           // addBeneficiaryVC.isUpdateBeneficiary = false
            addBeneficiaryVC.modalPresentationStyle = .overCurrentContext
            addBeneficiaryVC.modalTransitionStyle = .crossDissolve
            
            addBeneficiaryVC.completionBlock = { beneficiary, success in
                if success {
                    self.selectedBeneficiary = beneficiary
                    self.setSelectedBeneficiary()
                    self.getBeneficiary()
                }
            }
    
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController!.present(addBeneficiaryVC, animated: false)
        }
    }
    
    // MARK: -
    @IBAction func stateButtonClick(_ sender: Any) {
        let pickerVC = PickerListWithImageViewController.storyboardInstance()
        pickerVC?.titleArray = Constants.statesOfIndiaArray
        pickerVC?.selectedString = self.stateView.text ?? ""
        pickerVC?.titleString = "State"
        pickerVC?.completionBlock = { string in
            self.stateView.text = string
            self.getBBPS_BillersList()
        }
        self.present(pickerVC!, animated: true)
    }
    
    
    // MARK: - Beneficiary Drop Down
    @IBAction func beneficiaryDropdownButtonClick(_ sender: Any) {
   
        if self.beneficiaryArray.count == 0 {
            self.showAlert(title: "", message: "No beneficiary")
        }else{
            
            let nameArray = self.beneficiaryArray.compactMap { ($0.name ?? "") + " - " + self.getMobileNumberFromBeneficiaryModel(beneficiary: $0)}
            
            let pickerVC = PickerListWithImageViewController.storyboardInstance()
            pickerVC?.titleArray = nameArray
            pickerVC?.selectedString = self.beneficiaryView.text ?? ""
            pickerVC?.titleString = "Beneficiary"
            pickerVC?.completionIndexBlock = { index in
               // let strTitle = nameArray[index]
               
                self.selectedBeneficiary = self.beneficiaryArray[index]
                self.setSelectedBeneficiary()
            }
            self.present(pickerVC!, animated: true)
        }
    }
    // MARK: -
    func setSelectedBeneficiary(){
        if self.selectedBeneficiary == nil {
            self.beneficiaryContainerStackView.isHidden = true
            self.beneficiaryView.text = ""
            
        }else{
            self.beneficiaryNameLabel.text = self.selectedBeneficiary?.name ?? ""
            self.beneficiaryNumberLabel.text = self.getMobileNumberFromBeneficiaryModel(beneficiary: self.selectedBeneficiary!)
            
            self.beneficiarySwitchButton.isSelected = self.selectedBeneficiary?.isActive?.value ?? false
            self.beneficiaryContainerStackView.isHidden = false
            
            self.beneficiaryView.text = self.beneficiaryNameLabel.text! + " - " + self.beneficiaryNumberLabel.text!
           
        }
    }
    func getMobileNumberFromBeneficiaryModel(beneficiary:BeneficiaryDataModel) -> String {
        
        var str = ""
        if beneficiary.customerParams?.value.count != 0 {
            let dic = beneficiary.customerParams?.value.first
            
            if let s = dic?.value {
                str = s
            }
        }
       
        return str
    }
    
    // MARK: - get Beneficiary
    func getBeneficiary(){
        HPProgressHUD.show()
        UtilityBillsViewModel().getBeneficiary() { response, error in
//            print(response)
            HPProgressHUD.hide()
            self.beneficiaryArray = response?.data ?? [BeneficiaryDataModel]()
        }
    }
    
    @IBAction func deleteBeneficiaryButtonClick(_ sender: Any) {
        let action = UIAlertController(title: "Delete Beneficiary", message: "Are you sure to want to delete this beneficiary?", preferredStyle: .actionSheet)
        action.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            self.deleteBeneficiary()
        }))
        action.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(action, animated: true)
    }
    // MARK: - Delete deleteBeneficiary
    func deleteBeneficiary(){
        HPProgressHUD.show()
        MobilePrepaidViewModel().deleteBeneficiary(beneficiary_id: "\(self.selectedBeneficiary?.id ?? 0)") {  response, error  in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    self.selectedBeneficiary = nil
                    self.setSelectedBeneficiary()
                    self.getBeneficiary()
                    self.showAlert(title: "Success", message: response?.message ?? "")
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
    // MARK: - EDIT
    @IBAction func editBeneficiaryButtonClick(_ sender: Any) {
        
        if let addBeneficiaryVC = UItilityAddBeneficiaryViewController.storyboardInstance() {
            addBeneficiaryVC.isUpdateBeneficiary = true
            addBeneficiaryVC.modalPresentationStyle = .overCurrentContext
            addBeneficiaryVC.modalTransitionStyle = .crossDissolve
            addBeneficiaryVC.beneficiaryModel = self.selectedBeneficiary
            addBeneficiaryVC.completionBlock = { beneficiary, success in
                if success {
                    self.selectedBeneficiary = beneficiary
                    self.setSelectedBeneficiary()
                    self.getBeneficiary()
                }
            }
    
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController!.present(addBeneficiaryVC, animated: false)
        }
    }
    
    // MARK: - Continue Button Click
    @IBAction func continueButtonClick(_ sender: Any) {
        objUtilityBillsManager?.bbpsBillerID = self.selectedBeneficiary?.billerId ?? ""
        objUtilityBillsManager?.serviceProvideName = self.selectedBeneficiary?.serviceProvider ?? ""
        objUtilityBillsManager?.consumerNumber = self.selectedBeneficiary?.customerParams?.value.first?.value ?? ""
        self.goToFetchBill()
    }
    
}
// MARK: -
extension UtilityServiceProviderViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        view.backgroundColor = .clear
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: screenWidth - 40, height: 30))
        label.font = AppFonts.Regular.size(size: 14)
        label.textColor = UIColor(named: "999999")
        
        view.addSubview(label)
        
        label.text = "Gujarat"
//        if section == 0 {
//            label.text = "TITLE_BILL_SUMMARY".localizeString()
//        }else{
//            label.text = "TITLE_AMOUNT_SUMMARY".localizeString()
//        }
        return view
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filter_BBPS_BillersArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ElectricityProviderTableViewCell") as! ElectricityProviderTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let biller = self.filter_BBPS_BillersArray[indexPath.row]
        
        cell.nameLabel.text = biller.name ?? ""
        cell.logoImgView.image = nil // UIImage(named: "")
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedBillerModel = self.filter_BBPS_BillersArray[indexPath.row]
        objUtilityBillsManager?.bbpsBillerID = selectedBillerModel.id ?? "0"
        objUtilityBillsManager?.serviceProvideName = selectedBillerModel.name ?? ""
        objUtilityBillsManager?.consumerNumber = ""
        self.goToFetchBill()
    }
    func goToFetchBill(){
        if let fetchVC = UtilityFetchBillViewController.storyboardInstance() {
            fetchVC.screenTitle = self.getTitle()
            fetchVC.stateName = self.stateView.text!
            self.navigationController?.pushViewController(fetchVC, animated: true)
        }
    }
}
// MARK: - PekoIndiaSegmentControlDelegate
extension UtilityServiceProviderViewController:PekoIndiaSegmentControlDelegate {
    func selectedSegmentIndex(index: Int) {
       
        self.scrollView.setContentOffset(CGPoint(x: Int(screenWidth) * (index - 1), y: 0), animated:true)
        if index == 2 {
            self.getBeneficiary()
        }
    }
}

// MARK: -
extension UtilityServiceProviderViewController:PekoFloatingTextFieldViewDelegate{
    func textChange(textView: PekoFloatingTextFieldView) {
        if textView.text?.count == 0 {
            self.filter_BBPS_BillersArray = objUtilityBillsManager!.all_BBPS_BillersArray
        }else{
            self.filter_BBPS_BillersArray = objUtilityBillsManager!.all_BBPS_BillersArray.filter({ ($0.name ?? "").lowercased().contains(textView.text!.lowercased())
            })
        }
        self.providerTableView.reloadData()
    }
}
