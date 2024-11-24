//
//  PhoneBillsDashboardViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 08/01/23.
//

import UIKit


class PhoneBillsDashboardViewController: MainViewController {

    @IBOutlet weak var billCollectionView: UICollectionView!
   
    var billPaymentArray = [
        [
            "title":"Du Prepaid",
            "icon":"icon_phone_bill_du"
        ],
        [
            "title":"Du Postpaid",
            "icon":"icon_phone_bill_du"
        ],
        [
            "title":"Etisalat Prepaid",
            "icon":"icon_phone_bill_etisalat"
        ],
        [
            "title":"Etisalat Postpaid",
            "icon":"icon_phone_bill_etisalat"
        ]
    ]
    
    static func storyboardInstance() -> PhoneBillsDashboardViewController? {
        return AppStoryboards.Phone_Bill.instantiateViewController(identifier: "PhoneBillsDashboardViewController") as? PhoneBillsDashboardViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        
        self.setTitle(title: "Mobile Top-Up")
        
        self.billCollectionView.delegate = self
        self.billCollectionView.dataSource = self
       
        self.billCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        
        objPhoneBillsManager = PhoneBillsManager.sharedInstance
        // Do any additional setup after loading the view.
    }
    // MARK: -
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
}
extension PhoneBillsDashboardViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // Mobile Recharge
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.billPaymentArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenWidth - 30) / 4
        return CGSize(width: width, height: 125)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        let dic = self.billPaymentArray[indexPath.row]
        
        cell.titleLabel.text = dic["title"]
        cell.iconImgView.image = UIImage(named: dic["icon"]!)
        cell.iconImgView.contentMode = .center
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.getLimitData(index: indexPath.row)
    }
    
    func getLimitData(index:Int){
        HPProgressHUD.show()
        let type = PhoneBillType(rawValue: index)!
        PhoneBillsDashboardViewModel().getLimitData(type: type) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
         //       print("\n\n\n NEW OTP is ", response.data)
              //  signupRequest.otp = response.data!
                DispatchQueue.main.async {
                    
                    objPhoneBillsManager?.phoneBillType = type
                    objPhoneBillsManager?.limitDataModel = response?.data!
                    
                    self.goToBeneficiaryVC()
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
    func goToBeneficiaryVC(){
        
        if let beneficiaryVC = PhoneBillBeneficiaryViewController.storyboardInstance() {
            self.navigationController?.pushViewController(beneficiaryVC, animated: true)
        }
    }
}
