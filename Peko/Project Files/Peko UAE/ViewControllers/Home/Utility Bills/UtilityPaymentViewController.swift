//
//  UtilityPaymentViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 01/02/23.
//

import UIKit


class UtilityPaymentViewController: MainViewController {

    @IBOutlet weak var utilityCollectionView: UICollectionView!
    
    static func storyboardInstance() -> UtilityPaymentViewController? {
        return AppStoryboards.Utility.instantiateViewController(identifier: "UtilityPaymentViewController") as? UtilityPaymentViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        
        self.setTitle(title: "Utility Bills")
        
        self.utilityCollectionView.delegate = self
        self.utilityCollectionView.dataSource = self

        self.utilityCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
//
        objUtilityPaymentManager = UtilityPaymentManager.sharedInstance
     
        // Do any additional setup after loading the view.
    }
    // MARK: -
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
}
extension UtilityPaymentViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.utilityPaymentArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenWidth - 30) / 4
        return CGSize(width: width, height: 125)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        let dic = Constants.utilityPaymentArray[indexPath.row]
        
        cell.titleLabel.text = dic["title"]
        cell.iconImgView.image = UIImage(named: dic["icon"]!)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.getLimitData(index: indexPath.row)
       // self.goToBeneficiaryVC()
    }
    
    func getLimitData(index:Int){
       
        let type = UtilityPaymentType(rawValue: index)!
        
//        if type == .MAWAQiF {
//            self.showAlert(title: "", message: "Comming soon")
//            return
//        }
        
        HPProgressHUD.show()
        UtilityPaymentViewModel().getLimitData(type: type) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                print("\n\n\n NEW OTP is ", response?.data)
              //  signupRequest.otp = response?.data!
                DispatchQueue.main.async {
                    
                    objUtilityPaymentManager?.utilityPaymentType = type
                    objUtilityPaymentManager?.limitDataModel = response?.data!
                    
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
        
        if let beneficiaryVC = UtilityBeneficiaryViewController.storyboardInstance() {
            self.navigationController?.pushViewController(beneficiaryVC, animated: true)
        }
    }
}
