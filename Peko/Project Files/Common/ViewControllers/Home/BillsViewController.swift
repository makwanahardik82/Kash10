//
//  BillsViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 20/02/24.
//

import UIKit
import CodableFirebase

class BillsViewController: MainViewController {

    @IBOutlet weak var billCollectionView: UICollectionView!
    @IBOutlet weak var searchTxt: UITextField!
    
    var operatorsArray = [MobileRechargeOperatorModel]()
    var searchOperatorsArray = [MobileRechargeOperatorModel]()
    
    var isInternational = false
    
    var billPaymentArray = [
        [
            "title":"AT&T",
            "icon":"icon_AT&T",
            "productId": 8,
            "productName": "AT&T PIN US ",
            "countryCode": "US",
            "operatorId": 6,
            "operatorName": "AT&T",
            "imageUrl": "http://www.valuetopup.com/image/index/16351"
        ],
        [
            "title":"Lyca mobile",
            "icon":"icon_Lyca_mobile",
            "productId": 268,
            "productName": "Lycamobile US - PayGo",
            "countryCode": "US",
            "operatorId": 110,
            "operatorName": "Lyca Mobile",
            "imageUrl": "http://www.valuetopup.com/image/index/686"
        ],
        [
            "title":"T mobile",
            "icon":"icon_T_mobile",
            "productId": 11,
            "productName": "T-Mobile PIN US ",
            "countryCode": "US",
            "operatorId": 51,
            "operatorName": "T-Mobile",
            "imageUrl": "http://www.valuetopup.com/image/index/443"
        ],
        [
            "title":"Ultra mobile",
            "icon":"icon_Ultra_mobile",
            "productId": 230,
            "productName": "Ultra Mobile",
            "countryCode": "US",
            "operatorId": 103,
            "operatorName": "Ultra Mobile",
            "imageUrl": "http://www.valuetopup.com/image/index/3892"
        ],
        [
            "title":"Liberty mobile",
            "icon":"icon_Liberty_mobile",
            "productId": 977,
            "productName": "Liberty Mobile",
            "countryCode": "US",
            "operatorId": 303,
            "operatorName": "Liberty",
            "imageUrl": "http://www.valuetopup.com/image/index/14717"
        ],
        [
            "title":"Access Wireless",
         //   "icon":"",   /// icon
            "productId": 270,
            "productName": "Access Wireless PIN",
            "countryCode": "US",
            "operatorId": 130,
            "operatorName": "Access",
            "imageUrl": "http://www.valuetopup.com/image/index/865"
        ],
        [
            "title":"H20 wireless",
            "icon":"icon_H20_wireless",
            "productId": 804,
            "productName": "H2O Paygo",
            "countryCode": "US",
            "operatorId": 20,
            "operatorName": "H2O",
            "imageUrl": "http://www.valuetopup.com/image/index/13011"
        ],
        [
            "title":"Net10 Wireless",
            "icon":"icon_net1o_mobile",
            "productId": 414,
            "productName": "Net10 RTR",
            "countryCode": "US",
            "operatorId": 32,
            "operatorName": "Net 10",
            "imageUrl": "http://www.valuetopup.com/image/index/4113"
        ],
        [
            "productId": 172, // icon
            "productName": "Simple Mobile RTR",
            "countryCode": "US",
            "operatorId": 46,
            "operatorName": "Simple Mobile",
            "imageUrl": "http://www.valuetopup.com/image/index/451"
        ],
        [
            "title":"Go smart mobile",
            "icon":"icon_Go_smart_mobile",
            "productId": 954, // icon
            "productName": "Go-Smart",
            "countryCode": "US",
            "operatorId": 262,
            "operatorName": "Gosmart",
            "imageUrl": "http://www.valuetopup.com/image/index/14610"
        ],
        
        [
            "title":"Cricket wireless",
            "icon":"icon_Cricket_wireless",
            "productId": 762,
            "productName": "Cricket ",
            "countryCode": "US",
            "operatorId": 13,
            "operatorName": "Cricket",
            "imageUrl": "http://www.valuetopup.com/image/index/11264"
        ],
        [
            "title":"Good2go mobile",
            "icon":"icon_Good2go_mobile",
            "productId": 208,
            "productName": "Good2go PIN Mobile",
            "countryCode": "US",
            "operatorId": 97,
            "operatorName": "Good2GO",
            "imageUrl": "http://www.valuetopup.com/image/index/429"
        ],
        [
            "productId": 13,
            "productName": "Airvoice PIN US",
            "countryCode": "US",
            "operatorId": 3,
            "operatorName": "Airvoice",
            "imageUrl": "http://www.valuetopup.com/image/index/7947"
        ],
        [
            "title":"Life wireless",
            "icon":"icon_Life_wireless",
            "productId": 262,
            "productName": "Life Wireless/Pure Prepaid PIN",
            "countryCode": "US",
            "operatorId": 122,
            "operatorName": "Pure/Life Wireless",
            "imageUrl": "http://www.valuetopup.com/image/index/651"
        ],
        
        [
            "title":"Pageplus",
            "icon":"icon_Pageplus",
            "productId": 19,
            "productName": "Page Plus PIN US - Refill Only",
            "countryCode": "US",
            "operatorId": 35,
            "operatorName": "Page Plus",
            "imageUrl": "http://www.valuetopup.com/image/index/436"
        ],
        [
            "title":"Redpocket",
            "icon":"icon_Redpocket",
            "productId": 840,
            "productName": "Red Pocket RTR - Monthly plan",
            "countryCode": "US",
            "operatorId": 42,
            "operatorName": "Red Pocket",
            "imageUrl": "http://www.valuetopup.com/image/index/13550"
        ],
        [
            "title":"Verizon",
            "icon":"icon_Verizon",
            "productId": 45,
            "productName": "Verizon US ",
            "countryCode": "US",
            "operatorId": 62,
            "operatorName": "Verizon",
            "imageUrl": "http://www.valuetopup.com/image/index/16509"
        ],
        [
            "productId": 716,
            "productName": "SafeLink Wireless ",
            "countryCode": "US",
            "operatorId": 269,
            "operatorName": "safelink",
            "imageUrl": "http://www.valuetopup.com/image/index/10356"
        ],
        [
            "title":"Tracfone",
            "icon":"icon_Tracfone",
            "productId": 803,
            "productName": "Tracfone",
            "countryCode": "US",
            "operatorId": 58,
            "operatorName": "Tracfone",
            "imageUrl": "http://www.valuetopup.com/image/index/"
        ],
        [
            "title":"MetroPCS",
            "icon":"icon_MetroPCS",
            "productId": 760,
            "productName": "Metropcs",
            "countryCode": "US",
            "operatorId": 274,
            "operatorName": "Metro",
            "imageUrl": "http://www.valuetopup.com/image/index/11262"
        ],
        [
            "productId": 761,
            "productName": "Boost Mobile",
            "countryCode": "US",
            "operatorId": 8,
            "operatorName": "Boost",
            "imageUrl": "http://www.valuetopup.com/image/index/11263"
        ]
    ]
    
    var countryArray = [CountryModel]()
    
    static func storyboardInstance() -> BillsViewController? {
        return AppStoryboards.Bills.instantiateViewController(identifier: "BillsViewController") as? BillsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        
        self.setTitle(title: "Mobile Top-Up")
      
        self.billCollectionView.delegate = self
        self.billCollectionView.dataSource = self
       
        self.billCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        
        objPhoneBillsManager = PhoneBillsManager.sharedInstance
        objUtilityPaymentManager = UtilityPaymentManager.sharedInstance
     
        
        objMobileRechargeManager = MobileRechargeManager.sharedInstance
        
        self.searchTxt.addTarget(self, action: #selector(textFieldDidChangeSelection), for: .editingChanged)
      
        if self.isInternational {
            self.getOperators()
        }else{
            
            do {
                let model = try FirebaseDecoder().decode([MobileRechargeOperatorModel].self, from: self.billPaymentArray)
                self.operatorsArray = model
                self.searchOperatorsArray = model
                self.billCollectionView.reloadData()
            } catch let error {
                print(error)
            }
            
        }
       
        if let url = Bundle.main.url(forResource: "Countries", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                self.countryArray = try decoder.decode([CountryModel].self, from: data)
               
            } catch {
                print("error:\(error)")
            }
        }
        
        // Do any additional setup after loading the view.
    }
    @objc func textFieldDidChangeSelection() {
        let searchText = self.searchTxt.text!.lowercased()
        
        let array1  = self.operatorsArray.filter { ($0.operatorName ?? "").lowercased().contains(searchText) }
        
        if array1.count == 0 {
            self.searchOperatorsArray = self.operatorsArray
        }else{
            self.searchOperatorsArray = array1
        }
        
        self.billCollectionView.reloadData()
    }
    
    // MARK: - Get Operators
    func getOperators(){
        HPProgressHUD.show()
        MobileRechargeModelView().getOperatorsList() { response, error in
            HPProgressHUD.hide()
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                
            }else if let status = response?.success, status == true {
                
                DispatchQueue.main.async {
                    // print(response?.products)
                    let array = response?.products ?? [MobileRechargeOperatorModel]()
                    
                    self.operatorsArray = array.filter({ $0.countryCode?.lowercased() != "us" })
                    self.searchOperatorsArray = self.operatorsArray
                    self.billCollectionView.reloadData()
                }
                
            }else{
                /*
                if let code = response?.responseCode, code == "002"{
                    self.showAlertWithCompletion(title: "", message: "Your session has expired, please login again.") { action in
                        
                        DispatchQueue.main.async {
                            objUserSession.logout()
                            objShareManager.navigateToViewController = .LoginVC
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeViewController"), object: nil)
                        }
                    }
                }
               
                else{
                 */
                    var msg = ""
                    if response?.message != nil {
                        msg = response?.message ?? ""
                    }
//                else if response?.error?.count != nil {
//                        msg = response?.error ?? ""
//                    }
                    self.showAlert(title: "", message: msg)
               // }
            }
        }
    }
}
// MARK: -
extension BillsViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader{
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeHeaderCollectionReusableView", for: indexPath) as! HomeHeaderCollectionReusableView
            headerView.backgroundColor = UIColor.clear
            
            headerView.titleLabel.textAlignment = .left
            headerView.titleLabel.font = UIFont.medium(size: 16)
            headerView.titleLabel.textColor = .black
            
            if indexPath.section == 0 { // Peko Expense Card
                headerView.titleLabel.text = "Mobile Recharge"
            }else{
                headerView.titleLabel.text = "Utility Bills"
            }
            
            return headerView
        }
        /*
        else if kind == UICollectionView.elementKindSectionFooter{
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MoreFooterCollectionReusableView", for: indexPath) as! MoreFooterCollectionReusableView
            headerView.backgroundColor = UIColor.clear
            
            return headerView
        }
         */
        return UICollectionReusableView()
    }
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.searchOperatorsArray.count
        }else{
            return Constants.utilityPaymentArray.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenWidth - 40) / 4
        return CGSize(width: width, height: 125)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        if indexPath.section == 0 {
            let dic = self.searchOperatorsArray[indexPath.row]
            
            cell.titleLabel.text = dic.operatorName ?? ""
            if dic.icon != nil {
                cell.iconImgView.image = UIImage(named: dic.icon ?? "")
            }else{
                if let url = URL(string: dic.imageUrl ?? "") {
                    cell.iconImgView.sd_setImage(with: url)
                }
                
            }
            cell.iconImgView.contentMode = .scaleAspectFit
            
        }else{
            let dic = Constants.utilityPaymentArray[indexPath.row]
            
            cell.titleLabel.text = dic["title"]
            cell.iconImgView.image = UIImage(named: dic["icon"]!)
           
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            let model = self.searchOperatorsArray[indexPath.row]
            objMobileRechargeManager?.selectedOperatorModel = model
            // objMobileRechargeManager?.isInternational = self.isInternational
          
            let countryA = self.countryArray.filter { $0.alpha2Code?.lowercased() == model.countryCode?.lowercased() }
            
            if let country = countryA.first {
                if let cur = country.currencies?.first, let symbol = cur.symbol {
                    objMobileRechargeManager?.currencySymbol = symbol + " "
                }
                if let arr = country.callingCodes, let code = arr.first {
                    objMobileRechargeManager?.phoneCode = "+" + code
                }
            }
            
            if let vc = MobileRechargeViewController.storyboardInstance() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
   
}
