//
//  PekoConnectContactViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 22/05/23.
//

import UIKit
 
import KMPlaceholderTextView
import MessageUI
import SkeletonView

class PekoConnectContactViewController: MainViewController {

    @IBOutlet weak var storeImgView: UIImageView!
    @IBOutlet weak var storeNamelabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    
  //  @IBOutlet weak var rewardsLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var offeringLabel: UILabel!
    
    @IBOutlet weak var fullNameView: PekoFloatingTextFieldView!
    @IBOutlet weak var mobileNumberView: PekoFloatingTextFieldView!
    @IBOutlet weak var emailView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var prefereedView: PekoFloatingTextFieldView!
    @IBOutlet weak var requirementView: PekoFloatingTextFieldView!
    @IBOutlet weak var descriptionView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var serviceCollectionView: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
  
    var connectModel:PekoConnectModel?
    var serviceProviderArray = [String]()
    
    static func storyboardInstance() -> PekoConnectContactViewController? {
        return AppStoryboards.PekoConnect.instantiateViewController(identifier: "PekoConnectContactViewController") as? PekoConnectContactViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Peko Connect")
        self.view.backgroundColor = .white
        
        self.storeImgView.sd_setImage(with: URL(string: (self.connectModel?.logo ?? "")), placeholderImage: nil)
        self.storeNamelabel.text = self.connectModel?.serviceProvider ?? ""
        
        self.prefereedView.delegate = self
   
        self.serviceCollectionView.delegate = self
        self.serviceCollectionView.dataSource = self
        
        let layout = TagFlowLayout()
        layout.estimatedItemSize = CGSize(width: 140, height: 36)
        self.serviceCollectionView.collectionViewLayout = layout
        
        self.getDetail()
        
        let viewController = self.navigationController?.viewControllers
        
        print(viewController)
         // Do any additional setup after loading the view.
    }
    func getDetail(){
        HPProgressHUD.show()
        PekoConnectViewModel().getServiceProviderDetail(p_id: self.connectModel?.id ?? 0) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    self.connectModel = response?.data?.data!
                    self.setData()
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
    func setData(){
        self.scrollView.isHidden = false
        self.aboutLabel.text = self.connectModel?.description ?? ""
        self.storeAddressLabel.text = self.connectModel?.address ?? ""
        self.offeringLabel.text = self.connectModel?.offerings ?? ""
       
        self.serviceCollectionView.reloadData()
    }
    
    
    // MARK: - Connect Button Click
    @IBAction func connectNowButtonClick(_ sender: Any) {
    
        self.view.endEditing(true)
        let request = PekoConnectRequest(name: self.fullNameView.text!, phoneNumber: self.mobileNumberView.text!, email: self.emailView.text!, preferredMode: self.prefereedView.text!, requirement: self.requirementView.text, note: self.descriptionView.text!)
        
        let validationResult = PekoConnectValidation().Validate(request: request)

        if validationResult.success {
            self.pekoConnect(request: request)
        }else{
            self.showAlert(title: "", message: validationResult.error!)
        }
    }
    func pekoConnect(request:PekoConnectRequest) {
        
        HPProgressHUD.show()
        
        PekoConnectViewModel().pekoConnect(request: request, serviceProvider: self.connectModel!) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                  //  print(response?.data)
                    self.goToSuccessVC()
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
    func goToSuccessVC(){
        if let successVC = PekoConnectSuccessViewController.storyboardInstance() {
            successVC.serviceProvider = self.connectModel?.serviceProvider ?? ""
            self.navigationController?.pushViewController(successVC, animated: true)
        }
    }
    
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }
}

// MARK: -
extension PekoConnectContactViewController:PekoFloatingTextFieldViewDelegate{
    func textChange(textView: PekoFloatingTextFieldView) {
        
    }
    
    func dropDownClick(textView: PekoFloatingTextFieldView) {
        if textView == self.prefereedView {
            let pickerVC = PickerListViewController.storyboardInstance()
            pickerVC?.array = ["Phone", "Email"]
            pickerVC?.selectedString = self.prefereedView.text!
            pickerVC?.titleString = "Preferred Mode"
            pickerVC?.completionBlock = { string in
                self.prefereedView.text = string
            }
            let nav = UINavigationController(rootViewController: pickerVC!)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    
}


// MARK: - UICOLLECTION VIEW
extension PekoConnectContactViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.connectModel?.services?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceTagCollectionViewCell", for: indexPath)
        cell.backgroundColor = .clear
        
        let label = cell.viewWithTag(101) as! UILabel
        label.text = self.connectModel?.services![indexPath.row]
       
        return cell
    }
}

