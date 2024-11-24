//
//  MoreServiceViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 08/01/23.
//

import UIKit

class MoreServiceViewController: MainViewController {

    @IBOutlet weak var serviceCollectionView: UICollectionView!
    @IBOutlet var searchView: UIView!
    
    static func storyboardInstance() -> MoreServiceViewController? {
        return AppStoryboards.Home.instantiateViewController(identifier: "MoreServiceViewController") as? MoreServiceViewController
    }
    /*
    var paymentArray = [
        [
            "title":"Payments",
            "payment":[
                [
                    "title":"Corporate Cards",
                    "icon":"icon_corporate_cards"
                ],
                [
                    "title":"Invoicing",
                    "icon":"icon_invoicing "
                ],
                [
                    "title":"Vendor Payout",
                    "icon":"icon_vendor_payout"
                ],
                [
                    "title":"Cheque Management",
                    "icon":"icon_cheque_management"
                ],
                [
                    "title":"Payment Links",
                    "icon":"icon_payment_links"
                ]
                
            ]
        ],
        [
            "title":"Purchase",
            "payment":[
                [
                    "title":"Gift Cards",
                    "icon":"icon_gift_cards"
                ],
                [
                    "title":"Email/Domain",
                    "icon":"icon_email_domain"
                ],
                [
                    "title":"Capital",
                    "icon":"icon_capital"
                ],
                [
                    "title":"Payment Terminal",
                    "icon":"icon_payment_terminal"
                ],
                [
                    "title":"Forex Cards",
                    "icon":"icon_forex_cards"
                ],
                [
                    "title":"Remote Hiring",
                    "icon":"icon_remote_hiring"
                ],
                [
                    "title":"Carbon Footprint",
                    "icon":"icon_carbon_footprint"
                ]
            ]
        ],
        [
            "title":"Office & Business",
            "payment":[
                [
                    "title":"Business Docs",
                    "icon":"icon_business_docs"
                ],
                [
                    "title":"License Renewal",
                    "icon":"icon_license_renewal"
                ],
                [
                    "title":"Office Space",
                    "icon":"icon_office_space"
                ],
                [
                    "title":"Document Attestation",
                    "icon":"icon_document_attestation"
                ],
                [
                    "title":"WhatsApp for Business ",
                    "icon":"icon_whatsApp_business "
                ],
                [
                    "title":"Peko Club",
                    "icon":"icon_peko_cub"
                ],
                [
                    "title":"Accounting & Tax",
                    "icon":"icon_accounting _tax"
                ],
                [
                    "title":"Connect",
                    "icon":"icon_connect"
                ],
                [
                    "title":"Works",
                    "icon":"icon_works"
                ],
                [
                    "title":"Peko AI",
                    "icon":"icon_peko_ai"
                ]
            ]
        ]
    ]
    */
    var paymentArray = [
        [
            "title":"Mobile & Bill Payments",
            "payment":[
                [
                    "title":"Mobile Top-Up",
                    "icon":"icon_mobile_top_up"
                ],
                [
                    "title":"International Mobile Top-up",
                    "icon":"icon_International_mobile_top-up"
                ],
                [
                    "title":"Bill Payments",
                    "icon":"icon_bill_payments"
                ]
            ]
        ],
        [
            "title":"Travel",
            "payment":[
                [
                    "title":"Air Tickets",
                    "icon":"icon_air_ticket"
                ],
                [
                    "title":"Hotels",
                    "icon":"icon_hotels"
                ],
                [
                    "title":"eSIM",
                    "icon":"icon_eSIM"
                ]
            ]
        ],
        [
            "title":"Others",
            "payment":[
                [
                    "title":"Gift Cards",
                    "icon":"icon_gift_cards"
                ],
                [
                    "title":"Zero Carbon",
                    "icon":"icon_zero_carbon"
                ],
                [
                    "title":"Rewards",
                    "icon":"icon_rewards"
                ],
                [
                    "title":"Vouchers",
                    "icon":"icon_voucher"
                ],
                [
                    "title":"Rent Payments",
                    "icon":"icon_rent_payment"
                ],
                [
                    "title":"Events",
                    "icon":"icon_events"
                ],
                [
                    "title":"Tax Filing",
                    "icon":"icon_tax_filing"
                ],
                [
                    "title":"Money Transfer",
                    "icon":"icon_money_transfer"
                ],
                [
                    "title":"Gaming",
                    "icon":"icon_gaming"
                ]
                
            ]
        ]
    ]
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.serviceCollectionView.delegate = self
        self.serviceCollectionView.dataSource = self
      
        self.isBackNavigationBarView = true
        
        self.setTitle(title: "All Services")
   
        self.serviceCollectionView.register(UINib(nibName: "DashboardServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DashboardServiceCollectionViewCell")
       
  //      self.serviceCollectionView.register(UINib(nibName: "ApplyForCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ApplyForCardCollectionViewCell")
        
        
        // navigationController?.navigationBar.tintColor = .white
    }
    override func viewWillAppear(_ animated: Bool) {
    //    self.navigationController?.isNavigationBarHidden = true
    }
    // MARK: - Back Button Click
//    @objc func backButtonClick(){
//        self.navigationController?.popViewController(animated: true)
//    }
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }
    
}
extension MoreServiceViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.paymentArray.count // + 1
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if self.paymentArray.count == section { // Peko Expense Card
//            return CGSize.zero
//        }
        return CGSize(width: screenWidth, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader{
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeHeaderCollectionReusableView", for: indexPath) as! HomeHeaderCollectionReusableView
            headerView.backgroundColor = UIColor.clear
            
            headerView.titleLabel.textAlignment = .left
            headerView.titleLabel.font = UIFont.medium(size: 16)
            headerView.titleLabel.textColor = .black
            
            if self.paymentArray.count == indexPath.section { // Peko Expense Card
                headerView.titleLabel.text = ""
            }else{
                let dic = self.paymentArray[indexPath.section]
                if let title = dic["title"] as? String{
                    headerView.titleLabel.textKey = title
                }
            }
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
/*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if (self.paymentArray.count - 1) == section {
            return CGSize(width: screenWidth, height: screenWidth * 0.46)
        }
        return CGSize.zero // (width: screenWidth, height: screenWidth * 0.46)
    }
  */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        let dic = self.paymentArray[section]
        if let array = dic["payment"] as? [Dictionary<String, String>]{
            return array.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.paymentArray.count == indexPath.section { // Peko Expense Card
            return CGSize(width: screenWidth, height: screenWidth * 0.43)
        }
        let width = (screenWidth - 66) / 4
        let height = width * 0.91
        return CGSize(width: width, height: height + 45)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardServiceCollectionViewCell", for: indexPath) as! DashboardServiceCollectionViewCell
            cell.backgroundColor = .clear
           
            let dic = self.paymentArray[indexPath.section]
            if let array = dic["payment"] as? [Dictionary<String, String>]{
                let dic1 = array[indexPath.row]
              
                cell.titleLabel.font = UIFont.regular(size: 10)
                cell.titleLabel.text = dic1["title"]
                cell.logoImgView.image = UIImage(named: dic1["icon"]!)
                
                
            }
            return cell
      //  }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {// MobilePayments
            
            
            
            if let billsVC = BillsViewController.storyboardInstance() {
            
                if indexPath.row == 1 {
                    billsVC.isInternational = true
                }else{
                    billsVC.isInternational = false
                }
                self.navigationController?.pushViewController(billsVC, animated: true)
            }
        }else if indexPath.section == 1{
            
            if indexPath.row == 0 {
                if let airTicketVC = AirTicketViewController.storyboardInstance() {
                    self.navigationController?.pushViewController(airTicketVC, animated: true)
                }
            }else if indexPath.row == 1 {
                if let hotelVC = CorporateTravelDashboardViewController.storyboardInstance() {
                    hotelVC.travelType = 1
                    self.navigationController?.pushViewController(hotelVC, animated: true)
                }
            }else if indexPath.row == 2 {
                if let eSIMVC = eSimDashboardViewController.storyboardInstance() {
                    self.navigationController?.pushViewController(eSIMVC, animated: true)
                }
            }
        }else if indexPath.section == 2{
            if indexPath.row == 0 {
                if let giftCardVC = GiftCardsProductsViewController.storyboardInstance() {
                    self.navigationController?.pushViewController(giftCardVC, animated: true)
                }
            }else{
              //  self.showAlert(title: "", message: "Coming Soon!")
                
            }
        }
    }
}
class MoreFooterCollectionReusableView:UICollectionReusableView {
    
   // @IBOutlet weak var titleLabel: UILabel!
}
