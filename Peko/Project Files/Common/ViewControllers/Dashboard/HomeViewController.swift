//
//  HomeViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 04/01/23.
//

import UIKit

import ParallaxHeader
import SkeletonView

class HomeViewController: MainViewController {
    
    //    @IBOutlet weak var companyNameLabel: UILabel!
    //    @IBOutlet weak var userNameLabel: UILabel!
    //    @IBOutlet weak var cashbackLabel: UILabel!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet var headerView: UIView!
    
    var bannerCollectionView: UICollectionView?
    var bannerPageControl: UIPageControl?
    var bannerTimer:Timer?
    var bannerCurrentIndex = 0
    
    var dashboardModel:DashboardModel?
    
    
    var alertCollectionView: UICollectionView?
    var alertPageControl: UIPageControl?
    //var bannerTimer:Timer?
    var alertCurrentIndex = 0
    
    
    // var bannerArray = ["dashboard_banner_1.png", "dashboard_banner_2.png", "dashboard_banner_3.png"]
    
    var isShowSkeletonView = false
    var offerBannerArray = ["banner_mobile_top-up", "banner_flight_booking", "banner_carbon_footprint"]
    
    static func storyboardInstance() -> HomeViewController? {
        return AppStoryboards.Home.instantiateViewController(identifier: "HomeViewController") as? HomeViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            
            //  self.homeCollectionView.isHidden = true
            self.homeCollectionView.isUserInteractionEnabled = false
            self.homeCollectionView.delegate = self
            self.homeCollectionView.dataSource = self
            
            self.homeCollectionView.register(UINib(nibName: "DashboardServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DashboardServiceCollectionViewCell")
            self.homeCollectionView.register(UINib(nibName: "UpcomingPaymentsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UpcomingPaymentsCollectionViewCell")
            self.homeCollectionView.register(UINib(nibName: "ApplyForCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ApplyForCardCollectionViewCell")
            self.homeCollectionView.register(UINib(nibName: "PaymentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PaymentCollectionViewCell")
            self.homeCollectionView.reloadData()
            self.homeCollectionView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        //   self.getProfileDetails()
        self.homeCollectionView.isHidden = false
        
        DispatchQueue.main.async {
            self.getDashboardData()
            
        }
        
        objPhoneBillsManager = nil
        objUtilityPaymentManager = nil
        objLicenseRenewalManager = nil
        objGiftCardManager = nil
        objAirTicketManager = nil
        objOfficeAddressManager = nil
        
        if self.bannerTimer != nil {
            self.bannersStartTimer()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        //  self.homeCollectionView.reloadData()
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        if self.bannerTimer != nil {
            self.bannersStopTimer()
        }
    }
    // MARK: - Get Dahboard
    func getDashboardData(){
        HPProgressHUD.show()
        DashboardViewModel().getDashboardDetails() { response, error in
            HPProgressHUD.hide()
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                self.homeCollectionView.isUserInteractionEnabled = true
                self.isShowSkeletonView = false
                self.homeCollectionView.reloadData()
                
            }else if let status = response?.status, status == true {
                
                DispatchQueue.main.async { //After(deadline: .now() + 0.0) {
                    self.dashboardModel = response?.data
                    objUserSession.balance = response?.data?.balance?.value ?? 0.0
                    self.homeCollectionView.isUserInteractionEnabled = true
                    self.isShowSkeletonView = false
                    self.homeCollectionView.reloadData()
                    self.homeCollectionView.isHidden = false
                }
                
            }else{
                if let code = response?.responseCode, code == "002"{
                    self.showAlertWithCompletion(title: "", message: "Your session has expired, please login again.") { action in
                        
                        DispatchQueue.main.async {
                            objUserSession.logout()
                            objShareManager.navigateToViewController = .LoginVC
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeViewController"), object: nil)
                        }
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
        
        // MARK: - Profile Data
        DashboardViewModel().getProfileDetails(){ response, error  in
            //   HPProgressHUD.hide()
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    print(response)
                    objUserSession.profileDetail = response?.data
                    // self.homeCollectionView.reloadData()
                }
            }else{
                
//                self.showAlertWithCompletion(title: "", message: "Your session has expired, please login again.") { action in
//                    
//                    DispatchQueue.main.async {
//                        objUserSession.logout()
//                        objShareManager.navigateToViewController = .LoginVC
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeViewController"), object: nil)
//                    }
//                }
            }
        }
        
        
    }
  
    // MARK: - Search Button CLick
    @IBAction func searchButtonClick(_ sender: UIButton) {
        if let serachVC = MoreServiceViewController.storyboardInstance() {
            self.navigationController?.pushViewController(serachVC, animated:true)
        }
    }
}

// MARK: - UICollectionView
extension HomeViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.homeCollectionView {
            return 8
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if collectionView == self.homeCollectionView {
            if kind == UICollectionView.elementKindSectionHeader{
                
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeHeaderCollectionReusableView", for: indexPath) as! HomeHeaderCollectionReusableView
                headerView.backgroundColor = UIColor.clear
                /*
                if indexPath.section == 4 {
                    headerView.titleLabel.textKey = "Alerts"
                    if self.isShowSkeletonView {
                        headerView.titleLabel.isSkeletonable = true
                        headerView.titleLabel.showAnimatedGradientSkeleton()
                    }else{
                        headerView.titleLabel.hideSkeleton()
                    }
                }else{
                    headerView.titleLabel.textKey = ""
                    //  headerView.titleLabel.isSkeletonable = false
                    headerView.titleLabel.hideSkeleton()
                }
                */
                headerView.titleLabel.textKey = ""
                //  headerView.titleLabel.isSkeletonable = false
                headerView.titleLabel.hideSkeleton()
            
                
                headerView.titleLabel.textAlignment = .left
                headerView.titleLabel.font = UIFont.bold(size: 13)
                headerView.titleLabel.textColor = .black
                return headerView
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == self.homeCollectionView {
//            if section == 4 {
//                return CGSize(width: screenWidth, height: 50)
//            }
            return CGSize(width: screenWidth, height: 20)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.homeCollectionView {
            if section == 0 { //
                return 1
            }else if section == 1 { //
                return Constants.paymentServicesArray.count
            }else if section == 3 {
                return Constants.paymentServices2Array.count // Baners
            }else if section == 4 { // Up Coming Payment
               return 0
                /*
                if self.isShowSkeletonView {
                    return 1
                }
                if self.dashboardModel?.alerts?.count == 0 {
                    return 1
                }else{
                    return self.dashboardModel?.alerts!.count ?? 0
                }
                */
                //return 1
            }else if section == 5 { // // Apply for Card
                return 1
            }else if section == 2 { // 2 5 // Offers
                return 1
            }else if section == 6 {
                return 1
            }else if section == 7 {
                return 1
            }
        } else if collectionView.tag == 100 {
            return self.dashboardModel?.allBanners?.count ?? 0
        }else if collectionView.tag == 200 {
            return self.offerBannerArray.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.homeCollectionView {
            
            if indexPath.section == 0 { // CARDS
             //   let height = screenWidth * 0.336//(screenWidth - 63) / 4
                return CGSize(width: screenWidth - 36, height: 75)
            }else if indexPath.section == 1 { // Options
                let width = (screenWidth - 66) / 4
               // let height = width * 0.91
                return CGSize(width: width, height: width + 30)
            }else if indexPath.section == 3 { // Banners
                let width = (screenWidth - 66) / 4
               // let height = width * 0.91
                return CGSize(width: width, height: width + 30)
            } else if indexPath.section == 4 {
                if self.isShowSkeletonView {
                    return CGSize(width: screenWidth - 36, height: 60)
                }else{
                    if self.dashboardModel?.alerts?.count == 0 {
                        return CGSize(width: screenWidth - 36, height: 130)
                    }else{
//                        if self.dashboardModel?.alerts?.count == 1 {
//                            return CGSize(width: screenWidth - 36, height: 67)
//                        }
                        return CGSize(width: screenWidth - 36, height: 67)
                    }
                }
                //  return CGSize(width: screenWidth - 36, height: 60) // Yes Upcoming
                // return CGSize(width: screenWidth - 36, height: 130) // No Upcoming
            }else if indexPath.section == 5 { // Peko Expense Card
                let height = 0.41 * screenWidth
                return CGSize(width: screenWidth - 36, height: height)
            }else if indexPath.section == 2 {  // 2 5//  Offers
                return CGSize(width: screenWidth - 36, height: 50)
            }else if indexPath.section == 6 { // Gift Card
                let width = screenWidth - 36
                let height = 0.51 * screenWidth
                return CGSize(width: width, height: height)
            }else if indexPath.section == 7 { // REWARD
                let height = screenWidth * 0.62
                return CGSize(width: screenWidth, height: height + 100)
            }
        }else if collectionView.tag == 100 {
            return CGSize(width: screenWidth - 36, height: screenWidth * 0.41)
        }else if collectionView.tag == 200 {
            let height = 0.41 * screenWidth
            let width = height * 1.0312
            return CGSize(width: width, height: height)
        }
        return CGSize.zero
    }
    /*
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView.tag == 200 {
            return 12
        }else if section == 4 {
            return 10
        }
        
        return 0
    }
    */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.homeCollectionView {
            
            if indexPath.section == 0 {  // CARDS
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCardCollectionViewCell", for: indexPath) as! DashboardCardCollectionViewCell
                cell.backgroundColor = .clear
                
                if self.isShowSkeletonView {
                    cell.view_1.showAnimatedGradientSkeleton()
                 //   cell.view_2.showAnimatedGradientSkeleton()
                }else{
                    cell.view_1.hideSkeleton()
              //      cell.view_2.hideSkeleton()
                    
                    cell.nameLabel.text = "Hello " + (objUserSession.profileDetail?.name ?? "")
                    cell.totalCashbackLabel.text =  (self.dashboardModel?.totalCashback?.value ?? 0.0).withCommas(decimalPoint: 0)
                    
                  //  cell.monthlySpendLabel.text = objUserSession.currency + (self.dashboardModel?.totalSpendCurrentMonth?.value ?? 0.0).withCommas(decimalPoint: 0)
                    
                }
                return cell
            }else if indexPath.section == 1 { // SERVICE OPTION
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardServiceCollectionViewCell", for: indexPath) as! DashboardServiceCollectionViewCell
                cell.backgroundColor = .clear
                
                if self.isShowSkeletonView {
                    cell.showAnimatedGradientSkeleton()
                }else{
                    cell.hideSkeleton()
                    
                    let dic = Constants.paymentServicesArray[indexPath.row]
                    cell.titleLabel.font = UIFont.regular(size: 10)
                    cell.titleLabel.text = dic["title"]
                    cell.logoImgView.image = UIImage(named: dic["icon"]!)
                    
                }
                return cell
            }else if indexPath.section == 3 { // Banners
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardServiceCollectionViewCell", for: indexPath) as! DashboardServiceCollectionViewCell
                cell.backgroundColor = .clear
                
                if self.isShowSkeletonView {
                    cell.showAnimatedGradientSkeleton()
                }else{
                    cell.hideSkeleton()
                    
                    let dic = Constants.paymentServices2Array[indexPath.row]
                    cell.titleLabel.font = UIFont.regular(size: 10)
                    cell.titleLabel.text = dic["title"]
                    cell.logoImgView.image = UIImage(named: dic["icon"]!)
                    
                }
                return cell
                
            }else if indexPath.section == 4 { // Up Coming
                //DashboardBannerCell
                
                if self.isShowSkeletonView {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingPaymentsCollectionViewCell", for: indexPath) as! UpcomingPaymentsCollectionViewCell
                    cell.backgroundColor = .clear
                    cell.clipsToBounds = false
                    cell.contentView.clipsToBounds = false
                    cell.view_1.showAnimatedGradientSkeleton()
                    return cell
                }else{
                    
                    if self.dashboardModel?.alerts?.count == 0 {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardNoUpcomingPaymentCollectionViewCell", for: indexPath)
                        cell.backgroundColor = .clear
                        
                        return cell
                    }else{
                        
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingPaymentsCollectionViewCell", for: indexPath) as! UpcomingPaymentsCollectionViewCell
                        cell.backgroundColor = .clear
                        cell.clipsToBounds = false
                        cell.contentView.clipsToBounds = false
                        cell.view_1.hideSkeleton()
                        
                        let model = self.dashboardModel?.alerts![indexPath.row]
                        
                        cell.titleLabel.text = model?.message ?? ""
                        cell.detailLabel.text = model?.type ?? ""
                        
                        if model?.providerImage == nil {
                            cell.logoImgView.image = nil
                        }else{
                            cell.logoImgView.sd_setImage(with: URL(string: model?.providerImage ?? ""))
                        }
                        return cell
                    }
                        /*
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardBannerCollectionViewCell", for: indexPath) as! DashboardBannerCollectionViewCell
                        cell.backgroundColor = .clear
                        
                        if self.isShowSkeletonView {
                            cell.view_1.isSkeletonable = true
                            cell.view_1.showAnimatedGradientSkeleton()
                        }else{
                            cell.view_1.hideSkeleton()
                            
                            cell.bannerCollectionView.delegate = self
                            cell.bannerCollectionView.dataSource = self
                            cell.bannerCollectionView.backgroundColor = .clear
                            cell.bannerCollectionView.tag = 300
                            cell.bannerCollectionView.register(UINib(nibName: "UpcomingPaymentsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UpcomingPaymentsCollectionViewCell")
                            cell.pageControl.numberOfPages = self.dashboardModel?.allBanners?.count ?? 0
                            
                            self.alertPageControl = cell.pageControl
                            self.alertCollectionView = cell.bannerCollectionView
                            
                        }
                        return cell
                        
                        */
                   // }
                }
            }else if indexPath.section == 5 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardOfferContainerCollectionViewCell", for: indexPath) // as! DashboardBannerCollectionViewCell
                cell.backgroundColor = .clear
                
                let offerCollectionView = cell.viewWithTag(200) as! UICollectionView
                
                offerCollectionView.register(UINib(nibName: "ApplyForCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ApplyForCardCollectionViewCell")
                offerCollectionView.delegate = self
                offerCollectionView.dataSource = self
                offerCollectionView.backgroundColor = .clear
                //cell.bannerCollectionView.tag = 200
                offerCollectionView.reloadData()
                
                return cell
                
            }else if indexPath.section == 6 {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplyForCardCollectionViewCell", for: indexPath) as! ApplyForCardCollectionViewCell
                cell.backgroundColor = .clear
                cell.bannerImgView.backgroundColor = .clear
                cell.bannerImgView.cornerRadius = 10
                cell.bannerImgView.contentMode = .scaleAspectFill
                
                if self.isShowSkeletonView {
                    cell.view_1.showAnimatedGradientSkeleton()
                }else{
                    cell.view_1.hideSkeleton()
                    cell.bannerImgView.image = UIImage(named: "banner_kash10_card_2")
                    cell.bannerImgView.contentMode = .scaleAspectFit
                }
                return cell
            }else if indexPath.section == 7 {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardRewardCollectionViewCell", for: indexPath)
                cell.backgroundColor = .clear
                
                return cell
                
            }else{ // Offer SECTION - 2
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardOfferCollectionViewCell", for: indexPath) as! DashboardOfferCollectionViewCell
                cell.backgroundColor = .clear
                
                if self.isShowSkeletonView {
                    cell.iconImgView.isHidden = true
                    cell.view_1.showAnimatedGradientSkeleton()
                }else{
                    cell.view_1.hideSkeleton()
                    cell.titleLabel.text = "Get instant cashback on every transaction"
                  //  cell.view_1.backgroundColor = UIColor(red: 255.0/255.0, green: 250/255.0, blue: 246/255.0, alpha: 1.0)
               //     cell.iconImgView.image = UIImage(named: "icon_50_off")
                    cell.iconImgView.isHidden = false
                    cell.applyColor1()
                }
                return cell
            }
        }else if collectionView.tag == 100 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardBannerCell", for: indexPath) // as! UpcomingPaymentsCollectionViewCell
            cell.backgroundColor = .clear
            
            if let model = self.dashboardModel?.allBanners![indexPath.row] as? BannersDataModel{
                let imgview = cell.viewWithTag(301) as! UIImageView
                imgview.sd_setImage(with: URL(string: model.bannerImage ?? ""))
            }
            return cell
        }else if collectionView.tag == 200 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplyForCardCollectionViewCell", for: indexPath) as! ApplyForCardCollectionViewCell
            cell.backgroundColor = .clear
            cell.bannerImgView.backgroundColor = .clear
            cell.bannerImgView.cornerRadius = 13
            cell.bannerImgView.contentMode = .scaleAspectFill
            
            if self.isShowSkeletonView {
                cell.view_1.showAnimatedGradientSkeleton()
            }else{
                cell.view_1.hideSkeleton()
                cell.bannerImgView.image = UIImage(named: self.offerBannerArray[indexPath.row])
            }
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isShowSkeletonView {
            return
        }
        if collectionView == self.homeCollectionView {
            if indexPath.section == 1 {
                
                switch indexPath.row {
                case 0: // Bills
                    if let billsVC = BillsViewController.storyboardInstance() {
                        billsVC.isInternational = false
                        self.navigationController?.pushViewController(billsVC, animated: true)
                    }
                    break
                case 1: // Office Supplies
                    if let billsVC = BillsViewController.storyboardInstance() {
                        billsVC.isInternational = false
                        self.navigationController?.pushViewController(billsVC, animated: true)
                    }
//                    objPekoStoreManager = PekoStoreManager.sharedInstance
//                    if let storeVC = PekoStoreDashboardViewController.storyboardInstance() {
//                        self.navigationController?.pushViewController(storeVC, animated: true)
//                    }
                    break
                case 2: 
                    if let airTicketVC = AirTicketViewController.storyboardInstance() {
                        self.navigationController?.pushViewController(airTicketVC, animated: true)
                    }
                    // SubscriptionPayments
//                    if let subscriptionPaymentsVC = SubscriptionPaymentsViewController.storyboardInstance() {
//                        self.navigationController?.pushViewController(subscriptionPaymentsVC, animated: true)
//                    }
                    break
                case 3: // Hotels
                    if let hotelVC = CorporateTravelDashboardViewController.storyboardInstance() {
                        hotelVC.travelType = 1
                        self.navigationController?.pushViewController(hotelVC, animated: true)
                    }
                    
//                    // Logistics
//                    DispatchQueue.main.async {
//                        if let logisticsVC = LogisticsDashboardViewController.storyboardInstance() {
//                            self.navigationController?.pushViewController(logisticsVC, animated: true)
//                        }
//                    }
                    break
                case 4: 
//                    if let carbonVC = CarbonDashboardViewController.storyboardInstance() {
//                        self.navigationController?.pushViewController(carbonVC, animated: true)
//                    }
                  //  self.showAlert(title: "", message: "Coming soon!")
                    break
                case 5:
                    if let giftCardVC = GiftCardsProductsViewController.storyboardInstance() {
                        self.navigationController?.pushViewController(giftCardVC, animated: true)
                    }
                    
                    break
                case 6: // Payroll
                 //   self.showAlert(title: "Reward", message: "Coming Soon!")
                    
                    break
                case 7: // More
                    
               //     self.showAlert(title: "Voucher", message: "Coming Soon!")
                   
                   // self.searchButtonClick(UIButton())
                    break
                default:
                    break
                }
            
            }else if indexPath.section == 3 { // Upcomming Payments
                switch indexPath.row {
                case 0:
               //     self.showAlert(title: "", message: "Coming soon!")
                    break
                case 1:
             //       self.showAlert(title: "", message: "Coming soon!")
                    break
                case 2:
                 //   self.showAlert(title: "", message: "Coming soon!")
                    break
                case 3: // Hotels
                //    self.searchButtonClick(UIButton())
                    if let eSIMVC = eSimDashboardViewController.storyboardInstance() {
                        self.navigationController?.pushViewController(eSIMVC, animated: true)
                    }
                    break
                default:
                    break
                }
            }else if indexPath.section == 4 {
               // self.openWhatsapp()
            }else if indexPath.section == 2 {
             //   self.showAlert(title: "", message: "Coming soon!")
            }else if indexPath.section == 6 {
            //    self.showAlert(title: "", message: "Coming soon!")
               
//                if let giftCardVC = GiftCardsProductsViewController.storyboardInstance() {
//                    self.navigationController?.pushViewController(giftCardVC, animated: true)
//                }
            }else if indexPath.section == 7 {
               // self.showAlert(title: "", message: "Coming soon!")
            }
        }else if collectionView.tag == 100 {
            if let model = self.dashboardModel?.allBanners![indexPath.row] as? BannersDataModel{
                self.openURL(urlString: model.bannerLink ?? "", inSideApp: true)
            }
        }else if collectionView.tag == 200 {
            if indexPath.row == 2 {
//                if let carbonVC = CarbonDashboardViewController.storyboardInstance() {
//                    self.navigationController?.pushViewController(carbonVC, animated: true)
//                }
            }else{
//                self.showAlert(title: "", message: "Coming soon!")
            }
        }
    }
    
    // MARK: - Open Whats App
    func openWhatsapp(){
        let urlWhats = "whatsapp://send?phone=\(Constants.WhatsAppHelpNumber)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }
                else {
                    print("Install Whatsapp")
                    
                    //  UIApplication.shared.open(URL(string: "https://api.whatsapp.com/send?phone=\(Constants.WhatsAppHelpNumber)")!, options: [:], completionHandler: nil)
                    // &text=Invitation
                }
            }
        }
    }
    /*
     // MARK: -
     func animateZoomforCell(zoomCell: PaymentCollectionViewCell) {
     UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {() -> Void in
     let x = 2.0//zoomCell.frame.size.width / 2
     let y = 2.0//zoomCell.frame.size.height / 1.5
     zoomCell.transform = CGAffineTransformMakeScale(x, y)
     }, completion: {(finished: Bool) -> Void in
     //  self.animateZoomforCellremove(zoomCell)
     })
     }
     func animateZoomforCellremove(zoomCell: PaymentCollectionViewCell) {
     UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {() -> Void in
     zoomCell.transform = CGAffineTransform.identity
     }, completion: {(finished: Bool) -> Void in
     zoomCell.removeFromSuperview()
     
     self.zoomContainerView.removeFromSuperview()
     self.homeCollectionView.reloadData()
     //  self.zoomContainerView.removeFromSuperview()
     //  self.DemoCollectionview.reloadData()
     
     })
     }
     */
    // MARK: - Upcoming Payments
    func getPhoneBillsLimitData(type:PhoneBillType){
        HPProgressHUD.show()
        objPhoneBillsManager = PhoneBillsManager.sharedInstance
        //    let type = PhoneBillType(rawValue: index)!
        PhoneBillsDashboardViewModel().getLimitData(type: type) { response, error in
            HPProgressHUD.hide()
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    objPhoneBillsManager?.phoneBillType = type
                    objPhoneBillsManager?.limitDataModel = response?.data!
                    if let beneficiaryVC = PhoneBillBeneficiaryViewController.storyboardInstance() {
                        self.navigationController?.pushViewController(beneficiaryVC, animated: true)
                    }
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
    func getUtilitiesPaymentLimitData(type:UtilityPaymentType){
        objUtilityPaymentManager = UtilityPaymentManager.sharedInstance
        
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
                //     print("\n\n\n NEW OTP is ", response?.data)
                //  signupRequest.otp = response?.data!
                DispatchQueue.main.async {
                    
                    objUtilityPaymentManager?.utilityPaymentType = type
                    objUtilityPaymentManager?.limitDataModel = response?.data!
                    
                    if let beneficiaryVC = UtilityBeneficiaryViewController.storyboardInstance() {
                        self.navigationController?.pushViewController(beneficiaryVC, animated: true)
                    }
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
    
    //MARK: -  BANNER TIMERS
    // MARK: -
    
    func bannersStartTimer(){
        if (self.dashboardModel?.allBanners?.count ?? 0) > 0 {
            self.bannerTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(bannersTimerAction), userInfo: nil, repeats: true)
        }
    }
    func bannersStopTimer(){
        if self.bannerTimer != nil {
            self.bannerTimer?.invalidate()
            // self.bannerTimer = nil
        }
    }
    @objc func bannersTimerAction(){
        
        if self.bannerCurrentIndex < (self.dashboardModel?.allBanners?.count ?? 0) {
            
        } else {
            self.bannerCurrentIndex = 0
        }
        
        self.bannerCollectionView!.scrollToItem(at: IndexPath(item: self.bannerCurrentIndex, section: 0), at: .centeredHorizontally, animated: true)
        self.bannerPageControl!.currentPage = self.bannerCurrentIndex
        self.bannerCurrentIndex += 1
        
    }
}

extension HomeViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.bannerCollectionView != nil {
            let visibleRect = CGRect(origin: self.bannerCollectionView!.contentOffset, size: self.bannerCollectionView!.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath = self.bannerCollectionView!.indexPathForItem(at: visiblePoint) {
                self.bannerPageControl!.currentPage = visibleIndexPath.row
                self.bannerCurrentIndex = visibleIndexPath.row
            }
        }
    }
}

class HomeHeaderCollectionReusableView:UICollectionReusableView {
    @IBOutlet weak var titleLabel: PekoLabel!
    
}

// MARK: -
class DashboardCardCollectionViewCell:UICollectionViewCell {
   // @IBOutlet weak var monthlySpendLabel: UILabel!
    @IBOutlet weak var totalCashbackLabel: UILabel!
    
    @IBOutlet weak var nameLabel: PekoLabel!
    @IBOutlet weak var view_1: UIView!
   // @IBOutlet weak var view_2: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //        self.view_1.isSkeletonable = true
        //        self.view_2.isSkeletonable = true
        self.layoutSubviews()
        self.layoutSkeletonIfNeeded()
    }
    
    override func layoutSubviews() {
        
    }
    
}
class DashboardBannerCollectionViewCell:UICollectionViewCell {
    
    @IBOutlet weak var view_1: UIView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    //  @IBOutlet weak var bannerImgView: UIImageView!
    override func layoutSubviews() {
        self.view_1.isSkeletonable = true
    }
    
}
class DashboardOfferCollectionViewCell:UICollectionViewCell {
    
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var view_1: UIView!
    
    @IBOutlet weak var titleLabel: PekoLabel!
    
    override func layoutSubviews() {
       // self.applyColor1()
    }
    
    func applyColor1(){
        // Auto layout, variables, and unit scale are not yet supported
        let layer0 = CAGradientLayer()
        layer0.colors = [
        UIColor(red: 0.094, green: 0.259, blue: 0.155, alpha: 1).cgColor,
        UIColor(red: 0.107, green: 0.529, blue: 0.275, alpha: 1).cgColor,
        UIColor(red: 0.121, green: 0.464, blue: 0.261, alpha: 1).cgColor
        ]
        layer0.locations = [0, 0.43, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1.23, b: 0, c: 0, d: 1.23, tx: 0, ty: -0.12))
        layer0.bounds = view_1.bounds.insetBy(dx: -0.5*view_1.bounds.size.width, dy: -0.5*view_1.bounds.size.height)
        layer0.position = view_1.center
        view_1.layer.insertSublayer(layer0, at: 0) //addSublayer(layer0)

        view_1.layer.cornerRadius = 8

        
    }
    func applyColor2(){
        // Auto layout, variables, and unit scale are not yet supported
        let layer0 = CAGradientLayer()
        
        layer0.colors = [
        UIColor(red: 0.975, green: 0.96, blue: 1, alpha: 1).cgColor,
        UIColor(red: 1, green: 0.967, blue: 0.957, alpha: 1).cgColor
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.bounds = view_1.bounds.insetBy(dx: -0.5*view_1.bounds.size.width, dy: -0.5*view_1.bounds.size.height)
        layer0.position = view_1.center
        
        view_1.layer.insertSublayer(layer0, at: 0)
        view_1.layer.cornerRadius = 8

        
    }
}
