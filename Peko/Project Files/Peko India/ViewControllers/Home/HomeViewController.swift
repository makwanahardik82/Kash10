//
//  HomeViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 04/01/23.
//

import UIKit


class HomeViewController: MainViewController {

    @IBOutlet weak var totalBalanceLabel: PekoLabel!
    @IBOutlet weak var totalCashbackLabel: PekoLabel!
    @IBOutlet weak var monthlySpendLabel: PekoLabel!
   
    //    @IBOutlet weak var companyNameLabel: UILabel!
//    @IBOutlet weak var userNameLabel: UILabel!
//    @IBOutlet weak var cashbackLabel: UILabel!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var upcomingPaymentCollectionView: UICollectionView!
  
    @IBOutlet weak var upcomingPaymentPageControl: UIPageControl!
   
    var paymentArray = [Dictionary<String, String>]()
        
//    @IBOutlet weak var zoomContainerView: UIView!
   // var upComingCollectionView: UICollectionView?

    var upcomingPaymentcurrentIndex = 0
    var upcomingPaymentTimer : Timer?
    
    
    static func storyboardInstance() -> HomeViewController? {
        return AppStoryboards.Home.instantiateViewController(identifier: "HomeViewController") as? HomeViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let dic = [
            "title":"View All",
            "icon":"icon_more_services"
        ]
        
        self.paymentArray.append(contentsOf: Constants.paymentServicesArray.prefix(upTo: 7))
        self.paymentArray.append(dic)
        
        self.homeCollectionView.delegate = self
        self.homeCollectionView.dataSource = self
       
        self.homeCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        
        self.upcomingPaymentCollectionView.delegate = self
        self.upcomingPaymentCollectionView.dataSource = self
        self.upcomingPaymentCollectionView.backgroundColor = .clear
        self.upcomingPaymentCollectionView.register(UINib(nibName: "UpcomingPaymentsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UpcomingPaymentsCollectionViewCell")
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        self.getProfileDetails()
        
        objPhoneBillsManager = nil
        objUtilityPaymentManager = nil
        objLicenseRenewalManager = nil
        objGiftCardManager = nil
        objAirTicketManager = nil
        objOfficeAddressManager = nil
        
        self.upcomingPaymentStartTimer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.upcomingPaymentStopTimer()
        
    }
    // MARK: - Profile
    func getProfileDetails(){
        HPProgressHUD.show()
        DashboardViewModel().getDashboardDetails() { response, error in
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
                    HPProgressHUD.hide()
                    objUserSession.balance = response?.data?.walletData?.balance?.toDouble() ?? 0.0
                    
                    self.totalCashbackLabel.text = objUserSession.currency + (response?.data?.totalCashback ?? 0.0).withCommas()
                    self.totalBalanceLabel.text = objUserSession.currency + (Double(response?.data?.walletData?.balance ?? "0.0")?.withCommas())!
                    self.monthlySpendLabel.text = objUserSession.currency + (response?.data?.totalRevenue ?? 0.0).withCommas()
                }
            }else{
                var msg = ""
                if response?.message != nil {
                    msg = response?.message ?? ""
                }else if response?.error?.count != nil {
                    msg = response?.error ?? ""
                }
                self.showAlert(title: "", message: msg)
                HPProgressHUD.hide()
            }
        }
        DashboardViewModel().getProfileDetails() { response, error  in
            
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
                  //  self.refreshData()
                }
            }else{
                
                self.showAlertWithCompletion(title: "", message: "Your session has expired, please login again.") { action in
                   
                    DispatchQueue.main.async {
                        objUserSession.logout()
                        objShareManager.navigateToViewController = .LoginVC
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeViewController"), object: nil)
                    }
                    
                }
//                var msg = ""
//                if response?.message != nil {
//                    msg = response?.message ?? ""
//                }else if response?.error?.count != nil {
//                    msg = response?.error ?? ""
//                }
//                self.showAlert(title: "", message: msg)
            }
        }
        
      
        
    }
//    func refreshData(){
//        
////        self.userNameLabel.text = objUserSession.profileDetail?.firstName
////        self.companyNameLabel.text = objUserSession.profileDetail?.name
////        self.homeCollectionView.reloadData()
//        
//    }
    // MARK: - Search Button CLick
    @IBAction func searchButtonClick(_ sender: UIButton) {
        
        if let serachVC = MoreServiceViewController.storyboardInstance() {
            self.navigationController?.pushViewController(serachVC, animated:true)
        }
    }
    
//    // MARK: - Zoom Out
//    @IBAction func zoomOutButtonClick(_ sender: Any) {
//        DispatchQueue.main.async {
//           // self.zoomContainerView.removeFromSuperview()
//            
//            for v in self.zoomContainerView.subviews{
//               if v is PaymentCollectionViewCell{
//                 // v.removeFromSuperview()
//                   self.animateZoomforCellremove(zoomCell: v as! PaymentCollectionViewCell)
//               }
//            }
//          //  self.homeCollectionView!.reloadData()
//        }
//    }
    
    // MARK: -
    func upcomingPaymentStartTimer(){
        upcomingPaymentTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(upcomingPaymentsTimerAction), userInfo: nil, repeats: true)
    }
    func upcomingPaymentStopTimer(){
        if upcomingPaymentTimer != nil {
            upcomingPaymentTimer?.invalidate()
        }
    }
    @objc func upcomingPaymentsTimerAction(){
        
        
        if upcomingPaymentcurrentIndex < 3 {
            
            
        } else {
            upcomingPaymentcurrentIndex = 0
        }
        
        self.upcomingPaymentCollectionView.scrollToItem(at: IndexPath(item: upcomingPaymentcurrentIndex, section: 0), at: .centeredHorizontally, animated: true)
        upcomingPaymentPageControl.currentPage = upcomingPaymentcurrentIndex
        upcomingPaymentcurrentIndex += 1
        
        
  //  let desiredScrollPosition = (upcomingPaymentcurrentIndex < (3) - 1) ? upcomingPaymentcurrentIndex + 1 : 0
      
        //upcomingPaymentPageControl.currentPage =
    }
    
    // MARK: -
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .darkContent
    }
}
extension HomeViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.homeCollectionView {
            return 8
        }else if collectionView == self.upcomingPaymentCollectionView {
            return 3
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.homeCollectionView {
            let width = (screenWidth - 30) / 4
            return CGSize(width: width, height: 125)
        }else if collectionView == self.upcomingPaymentCollectionView {
            let width = (screenWidth - 0)
            return CGSize(width: width, height: 90)
            
        }
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.homeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
            
            let dic = self.paymentArray[indexPath.row]
            cell.titleLabel.font = AppFonts.SemiBold.size(size: 12)
            cell.titleLabel.text = dic["title"]
            cell.iconImgView.image = UIImage(named: dic["icon"]!)
            
            return cell
        }else if collectionView == self.upcomingPaymentCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingPaymentsCollectionViewCell", for: indexPath) as! UpcomingPaymentsCollectionViewCell
            cell.backgroundColor = .clear
            
//            let dic = self.paymentArray[indexPath.row]
//            cell.titleLabel.font = AppFonts.SemiBold.size(size: 12)
//            cell.titleLabel.text = dic["title"]
//            cell.iconImgView.image = UIImage(named: dic["icon"]!)
//            
//
            
            return cell
        }
       return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.homeCollectionView {
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
                case 3: //  QR Code
                    
                    self.showAlert(title: "", message: "Coming Soon")
                    
                    break
                case 4: // AIR TICKET
                    if let airTicketVC = AirTicketViewController.storyboardInstance() {
                        self.navigationController?.pushViewController(airTicketVC, animated: true)
                    }
                    break
                case 5: // GIFT CARD
                    if let giftCardVC = GiftCardsProductsViewController.storyboardInstance() {
                        self.navigationController?.pushViewController(giftCardVC, animated: true)
                    }
                    break
                case 6: // PAYEMNT LINK
                    if let paymentLinkVC = PaymentsLinksDashboardViewController.storyboardInstance() {
                        self.navigationController?.pushViewController(paymentLinkVC, animated: true)
                    }
                    break
                case 7:
                    self.searchButtonClick(UIButton())
                    break
                default:
                    break
                }
            }
        }else if collectionView == self.upcomingPaymentCollectionView {
            
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
        /*
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
        */
    }
    /*
    func getUtilitiesPaymentLimitData(type:UtilityPaymentType){
        objUtilityPaymentManager = UtilityPaymentManager.sharedInstance
     
        if type == .MAWAQiF {
            self.showAlert(title: "", message: "Comming soon")
            return
        }
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
                    /*
                    if let beneficiaryVC = UtilityBeneficiaryViewController.storyboardInstance() {
                        self.navigationController?.pushViewController(beneficiaryVC, animated: true)
                    }
                    */
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
    */
}


extension HomeViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.upcomingPaymentCollectionView.contentOffset, size: self.upcomingPaymentCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.upcomingPaymentCollectionView.indexPathForItem(at: visiblePoint) {
            self.upcomingPaymentPageControl.currentPage = visibleIndexPath.row
            self.upcomingPaymentcurrentIndex = visibleIndexPath.row
        }
    }
}
