//
//  MoreServiceViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 08/01/23.
//

import UIKit

class MoreServiceViewController: MainViewController {

    @IBOutlet weak var serviceCollectionView: UICollectionView!
   // @IBOutlet var searchView: UIView!
    
    static func storyboardInstance() -> MoreServiceViewController? {
        return AppStoryboards.Home.instantiateViewController(identifier: "MoreServiceViewController") as? MoreServiceViewController
    }
    
    var paymentArray = [
        [
            "title":"Office Bills & Recharges",
            "payment":[
                [
                    "title":"Mobile Recharge",
                    "icon":"icon_mobile_recharge"
                ],
                [
                    "title":"Mobile Postpaid",
                    "icon":"icon_mobile_postpaid"
                ],
                [
                    "title":"Utility Bills",
                    "icon":"icon_utility_bills"
                ],
                [
                    "title":"QR Payment",
                    "icon":"icon_qr_Payment"
                ]
            ]
        ],
        [
            "title":"Travel & Booking",
            "payment":[
                [
                    "title":"Air Tickets",
                    "icon":"icon_air_tickets"
                ],
                [
                    "title":"Hotel Booking",
                    "icon":"icon_hotel_booking"
                ],
                [
                    "title":"Shipment Services",
                    "icon":"icon_shipment_services"
                ]
            ]
        ],
        [
            "title":"Purchase",
            "payment":[
                [
                    "title":"Office Supplies",
                    "icon":"icon_office_supplies"
                ],
                [
                    "title":"Subscription Payments",
                    "icon":"icon_subscription_payments"
                ],
                [
                    "title":"Gift Cards",
                    "icon":"icon_gift_cards"
                ],
                [
                    "title":"Insurance",
                    "icon":"icon_insurance"
                ]
            ]
        ],
        [
            "title":"Office & Business",
            "payment":[
                [
                    "title":"Carbon Footprint",
                    "icon":"icon_carbon_footprint"
                ],
                [
                    "title":"Peko Connect",
                    "icon":"icon_peko_connect"
                ],
                [
                    "title":"Business Docs",
                    "icon":"icon_business_docs"
                ],
                [
                    "title":"Office Address",
                    "icon":"icon_office_address"
                ],
                [
                    "title":"Invoice",
                    "icon":"icon_invoice"
                ]
            ]
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.serviceCollectionView.delegate = self
        self.serviceCollectionView.dataSource = self
        
        self.isBackNavigationBarView = true
        self.setTitle(title: "All Payments & Expenses")
        self.view.backgroundColor = .white

        self.serviceCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        
        navigationController?.navigationBar.tintColor = .white
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
  
    // MARK: -
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .darkContent
    }
    
}
extension MoreServiceViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: // Mobile Prepaid
                if let mobileVC = MobileRechargeViewController.storyboardInstance() {
                    mobileVC.isPostpaid = false
                    self.navigationController?.pushViewController(mobileVC, animated: true)
                }
                break
            case 1: // Mobile Postpaid
                if let mobileVC = MobileRechargeViewController.storyboardInstance() {
                    mobileVC.isPostpaid = true
                    self.navigationController?.pushViewController(mobileVC, animated: true)
                }
                break
            case 2: // Utility Bills
                if let utilityVC = UtilityBillsDashboardViewController.storyboardInstance() {
                    self.navigationController?.pushViewController(utilityVC, animated: true)
                }
                break
            case 3: // Utility Bills
                self.showAlert(title: "", message: "Coming Soon")
                break
                
            default:
                break
            }
        }else if indexPath.section == 1 {
            switch indexPath.row {
            case 0: // Air Ticket
                if let airTicketVC = AirTicketViewController.storyboardInstance() {
                    self.navigationController?.pushViewController(airTicketVC, animated: true)
                }
                break
            case 1: // Hotel Booking
                if let hotelVC = HotelBookingDashboardViewController.storyboardInstance() {
                    self.navigationController?.pushViewController(hotelVC, animated: true)
                }
                break
            case 2: // Shipping
                DispatchQueue.main.async {
                    if let logisticsVC = LogisticsDashboardViewController.storyboardInstance() {
                        self.navigationController?.pushViewController(logisticsVC, animated: true)
                    }
                }
                break
            default:
                break
            }
        }else if indexPath.section == 2 {
            switch indexPath.row {
            case 0: // Office Supplies
                
                objPekoStoreManager = PekoStoreManager.sharedInstance
                if let storeVC = PekoStoreDashboardViewController.storyboardInstance() {
                    self.navigationController?.pushViewController(storeVC, animated: true)
                }
                
                break
            case 1: // Subscrition
                if let subscriptionPaymentsVC = SubscriptionPaymentsViewController.storyboardInstance() {
                    self.navigationController?.pushViewController(subscriptionPaymentsVC, animated: true)
                }
                break
            case 2: // Gift Cards
                if let giftCardVC = GiftCardsProductsViewController.storyboardInstance() {
                    self.navigationController?.pushViewController(giftCardVC, animated: true)
                }
                break
            case 3: // Utility Bills
               
                self.showAlert(title: "", message: "Coming Soon")
                break
                
            default:
                break
            }
        }else if indexPath.section == 3 {
            switch indexPath.row {
            case 0: // Carbon Neutral
                if let carbonVC = CarbonDashboardViewController.storyboardInstance() {
                    self.navigationController?.pushViewController(carbonVC, animated: true)
                }
                
                break
            case 1: //  Peko Connect
                
                if let connectVC = PekoConnectDashboardViewController.storyboardInstance() {
                    self.navigationController?.pushViewController(connectVC, animated: true)
                }
                break
            case 2: // Business Docs
                if let businessVC = BusinessDocsViewController.storyboardInstance() {
                    self.navigationController?.pushViewController(businessVC, animated: true)
                }
                break
            case 3: // Office Space
                if let workspaceVC = WorkspaceViewController.storyboardInstance() {
                    self.navigationController?.pushViewController(workspaceVC, animated: true)
                }
                break
            case 4: // Invoice
                if let invoiceVC = InvoiceGeneratorDashboardViewController.storyboardInstance() {
                    self.navigationController?.pushViewController(invoiceVC, animated: true)
                }
                break
            default:
                break
            }
        }
    
/*
        switch indexPath.row {
        case 0: // Phone Bill
            if let phoneBillVC = PhoneBillsDashboardViewController.storyboardInstance() {
                self.navigationController?.pushViewController(phoneBillVC, animated: true)
            }
            break
        case 1: // Utility Payments
            
            if let utilityVC = UtilityPaymentViewController.storyboardInstance() {
                self.navigationController?.pushViewController(utilityVC, animated: true)
            }
            break
        case 2: // Payment Links
            if let paymentLinkVC = PaymentsLinksDashboardViewController.storyboardInstance() {
                self.navigationController?.pushViewController(paymentLinkVC, animated: true)
            }
            break
        case 3: //  Peko Connect
            
            if let connectVC = PekoConnectDashboardViewController.storyboardInstance() {
                self.navigationController?.pushViewController(connectVC, animated: true)
            }
            break
        case 4: // Gift Cards
            if let giftCardVC = GiftCardsProductsViewController.storyboardInstance() {
                self.navigationController?.pushViewController(giftCardVC, animated: true)
            }
            break
        case 5: // PEKO STORE
            
            objPekoStoreManager = PekoStoreManager.sharedInstance
            if let storeVC = PekoStoreDashboardViewController.storyboardInstance() {
                self.navigationController?.pushViewController(storeVC, animated: true)
            }
            break
        case 6: // SubscriptionPayments
            if let subscriptionPaymentsVC = SubscriptionPaymentsViewController.storyboardInstance() {
                self.navigationController?.pushViewController(subscriptionPaymentsVC, animated: true)
            }
            break
        case 7: // Air Ticket
            if let airTicketVC = AirTicketViewController.storyboardInstance() {
                self.navigationController?.pushViewController(airTicketVC, animated: true)
            }
            break
        case 8: // Invoice Generator
            if let invoiceVC = InvoiceGeneratorDashboardViewController.storyboardInstance() {
                self.navigationController?.pushViewController(invoiceVC, animated: true)
            }
            break
        case 9: // License Renewal
            if let licenseVC = LicenseRenewalViewController.storyboardInstance() {
                self.navigationController?.pushViewController(licenseVC, animated: true)
            }
        case 10: // Business Docs
            if let businessVC = BusinessDocsViewController.storyboardInstance() {
                self.navigationController?.pushViewController(businessVC, animated: true)
            }
            break
        case 11: // Logistics
            
            DispatchQueue.main.async {
                if let logisticsVC = LogisticsDashboardViewController.storyboardInstance() {
                    self.navigationController?.pushViewController(logisticsVC, animated: true)
                }
            }
            break
        case 12: // Office Space
            if let workspaceVC = WorkspaceViewController.storyboardInstance() {
                self.navigationController?.pushViewController(workspaceVC, animated: true)
            }
            break
        case 13:// Hotel Booking
            if let hotelVC = HotelBookingDashboardViewController.storyboardInstance() {
                self.navigationController?.pushViewController(hotelVC, animated: true)
            }
            break
        case 14: // Pay Later
            if let payLaterVC = PayLaterViewController.storyboardInstance() {
                self.navigationController?.pushViewController(payLaterVC, animated: true)
            }
            break
            
        case 15: // Carbon Neutral
            if let carbonVC = CarbonDashboardViewController.storyboardInstance() {
                self.navigationController?.pushViewController(carbonVC, animated: true)
            }
            break
      
       
        default:
            break
        }
     */
    }
}
class MoreFooterCollectionReusableView:UICollectionReusableView {
    
   // @IBOutlet weak var titleLabel: UILabel!
}
class HomeHeaderCollectionReusableView:UICollectionReusableView {
    @IBOutlet weak var titleLabel: PekoLabel!
    
}
