//
//  UtilityBillsDashboardViewController.swift
//  Peko India
//
//  Created by Hardik Makwana on 12/12/23.
//

import UIKit

enum UtilityBillsType: Int {
    case Electricity = 0
    case Broadband
    case LPGCylinder
    case PipedGas
    case Water
    case EducationFee
    case Landline
    
}

class UtilityBillsDashboardViewController: MainViewController {

    @IBOutlet weak var utilityCollectionView: UICollectionView!
   
    var paymentArray = [
        [
            "title":"All Utility Bills",
            "payment":[
                [
                    "title":"Electricity",
                    "icon":"icon_utility_electricity"
                ],
                [
                    "title":"Broadband",
                    "icon":"icon_utility_broadband"
                ],
                [
                    "title":"LPG Cylinder",
                    "icon":"icon_utility_lpg_cylinder"
                ],
                [
                    "title":"Piped Gas",
                    "icon":"icon_utility_piped_gas"
                ],
                [
                    "title":"Water",
                    "icon":"icon_utility_water"
                ],
                [
                    "title":"Education Fee",
                    "icon":"icon_utility_education_fee"
                ],
                [
                    "title":"Landline",
                    "icon":"icon_utility_landline"
                ],
               
            ]
        ]
    ]
    static func storyboardInstance() -> UtilityBillsDashboardViewController? {
        return AppStoryboards.Utility.instantiateViewController(identifier: "UtilityBillsDashboardViewController") as? UtilityBillsDashboardViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.isBackNavigationBarView = true
        self.setTitle(title: "TITLE_ALL_ULTILITY_BILLS")
        self.view.backgroundColor = .white

        self.utilityCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        self.utilityCollectionView.delegate = self
        self.utilityCollectionView.dataSource = self
        
     
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        objUtilityBillsManager = nil
    }
   
    // MARK: -
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .darkContent
    }
    
}
extension UtilityBillsDashboardViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.paymentArray.count
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader{
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeHeaderCollectionReusableView", for: indexPath) as! HomeHeaderCollectionReusableView
            headerView.backgroundColor = UIColor.clear
            
            let dic = self.paymentArray[indexPath.section]
            if let title = dic["title"] as? String{
                headerView.titleLabel.textKey = title
            }
            headerView.titleLabel.textAlignment = .left
            
            return headerView
        }else if kind == UICollectionView.elementKindSectionFooter{
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MoreFooterCollectionReusableView", for: indexPath) as! MoreFooterCollectionReusableView
            headerView.backgroundColor = UIColor.clear
            
            return headerView
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if (self.paymentArray.count - 1) == section {
            return CGSize(width: screenWidth, height: (screenWidth * 0.43) + 20)
        }
        return CGSize.zero // (width: screenWidth, height: screenWidth * 0.46)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dic = self.paymentArray[section]
        if let array = dic["payment"] as? [Dictionary<String, String>]{
            return array.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenWidth - 30) / 4
        return CGSize(width: width, height: 125)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.titleLabel.font = AppFonts.SemiBold.size(size: 12)
        
        let dic = self.paymentArray[indexPath.section]
        if let array = dic["payment"] as? [Dictionary<String, String>]{
            let dic1 = array[indexPath.row]
            cell.titleLabel.text = dic1["title"]
            cell.iconImgView.image = UIImage(named: dic1["icon"]!)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dic = self.paymentArray[indexPath.section]
        if let array = dic["payment"] as? [Dictionary<String, String>]{
            let dic1 = array[indexPath.row]
           
            objUtilityBillsManager = UtilityBillsManager.sharedInstance
            objUtilityBillsManager!.selectedUtilityBillType  = UtilityBillsType(rawValue: indexPath.row)!
            objUtilityBillsManager!.selectedUtilityBillName = dic1["title"]
            if let UtilityServiceProviderVC = UtilityServiceProviderViewController.storyboardInstance() {
                self.navigationController?.pushViewController(UtilityServiceProviderVC, animated: true)
            }
        }
    }
}
