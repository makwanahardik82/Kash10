//
//  CorporateTravelDashboardViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 01/03/24.
//

import UIKit


class CorporateTravelDashboardViewController: MainViewController {

    @IBOutlet weak var airTicketImgView: UIImageView!
    @IBOutlet weak var airTicketTitleLabel: PekoLabel!
    
    @IBOutlet weak var hotelBookingImgView: UIImageView!
    @IBOutlet weak var hotelBookingTitleLabel: PekoLabel!
    
    @IBOutlet weak var lineCenterXConstraint: NSLayoutConstraint!
    
    var travelType = 0 // 0 = Air 1 = Hotel
    // MARK: - Hotel
    @IBOutlet weak var hotelCityView: PekoFloatingTextFieldView!
    @IBOutlet weak var hotelCheckInDateView: PekoFloatingTextFieldView!
    @IBOutlet weak var hotelCheckOutDateView: PekoFloatingTextFieldView!
    @IBOutlet weak var hotelRoomsView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var hotelGuestView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var roomArray = [Dictionary<String, Any>]()
    var checkInDate:Date?
    var checkOutDate:Date?
    
    
    static func storyboardInstance() -> CorporateTravelDashboardViewController? {
        return AppStoryboards.CorporateTravel.instantiateViewController(identifier: "CorporateTravelDashboardViewController") as? CorporateTravelDashboardViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Hotel Booking")
        self.view.backgroundColor = .white
      
        self.backNavigationView?.orderHistoryView.isHidden = false
        self.backNavigationView?.historyButton.addTarget(self, action: #selector(bookingHistoryButtonClick), for: .touchUpInside)
       
        objHotelBookingManager = HotelBookingManager.sharedInstance
        
        self.hotelCityView.text = "Dubai"
        
        let tmpDec = [
            "adult": 1,
            "child": 0,
            "roomIndex": 1
        ]
        self.roomArray.append(tmpDec)

        self.checkInDate = Date().addDays(day: 1)
        self.hotelCheckInDateView.text = self.checkInDate!.formate(format: "dd, MMMM, yyyy")
        
        self.checkOutDate = Date().addDays(day: 3)
        self.hotelCheckOutDateView.text = self.checkOutDate!.formate(format: "dd, MMMM, yyyy")
        self.setTraveller()
        // Do any additional setup after loading the view.
    }
   // MARK: - Booking History Button
    @objc func bookingHistoryButtonClick(){
        if let historyVC = HotelBookingHistoryViewController.storyboardInstance(){
            self.navigationController?.pushViewController(historyVC, animated: true)
        }
    }
    
    // MARK: - Tab Buttons
    @IBAction func airTicketTabButtonClick(_ sender: Any) {
   
        self.airTicketImgView.tintColor = .redButtonColor
        self.airTicketTitleLabel.textColor = .redButtonColor
        self.airTicketTitleLabel.font = .bold(size: 12)
        
        self.hotelBookingImgView.tintColor = .black
        self.hotelBookingTitleLabel.textColor = .black
        self.hotelBookingTitleLabel.font = .medium(size: 12)
        
        self.lineCenterXConstraint.constant = -62
        self.scrollView.setContentOffset(CGPoint(x:0, y: 0), animated:true)
        
        self.travelType = 0
    }
    @IBAction func hotelBookingTabButtonClick(_ sender: Any) {
        
        self.hotelBookingImgView.tintColor = .redButtonColor
        self.hotelBookingTitleLabel.textColor = .redButtonColor
        self.hotelBookingTitleLabel.font = .bold(size: 12)
        
        self.airTicketImgView.tintColor = .black
        self.airTicketTitleLabel.textColor = .black
        self.airTicketTitleLabel.font = .medium(size: 12)
       
        self.lineCenterXConstraint.constant = 62
        self.scrollView.setContentOffset(CGPoint(x:screenWidth, y: 0), animated:true)
        
        self.travelType = 1
    }
    
    // MARK: - Hotel Booking
    // MARK: -
    
    @IBAction func selectDatesButtonClick(_ sender: Any) {
        if let dateVC = HotelBookingSelectDatesViewController.storyboardInstance(){
            dateVC.completionBlock = { date1, date2 in
                self.checkInDate = date1
                self.checkOutDate = date2
                
                self.hotelCheckInDateView.text = date1.formate(format: "dd MMMM, yyyy")
                self.hotelCheckOutDateView.text = date2.formate(format: "dd MMMM, yyyy")
            }
            dateVC.modalPresentationStyle = .fullScreen
            self.present(dateVC, animated: true)
        }
    }
    
    @IBAction func selectCityButtonClick(_ sender: Any) {
        if let cityVC = HotelBookingSelectCityViewController.storyboardInstance() {
            cityVC.completionBlock = { title in
                self.hotelCityView.text = title
            }
            cityVC.modalPresentationStyle = .fullScreen
            self.present(cityVC, animated: true)
        }
    }
    // MARK: -
    @IBAction func selectRoomsGuestButtonClick(_ sender: Any) {
        if let pickerVC = HotelBookingSelectTravellerViewController.storyboardInstance() {
            pickerVC.roomArray = self.roomArray
            pickerVC.completionBlock = { array in
                self.roomArray = array
                self.setTraveller()
                
            }
            pickerVC.modalPresentationStyle = .fullScreen
            self.present(pickerVC, animated: true)
        }
    }
    func setTraveller(){
        let total_adult = self.roomArray.compactMap { $0["adult"] as? Int }.reduce(0, +)
        let total_child = self.roomArray.compactMap { $0["child"] as? Int }.reduce(0, +)
      
        //let infants = self.roomArray.compactMap { $0["infants"] as? Int }.reduce(0, +)
        
        let total_guest = total_adult + total_child  // + infants
        
        self.hotelRoomsView.text = "\(self.roomArray.count)"
        self.hotelGuestView.text = "\(total_guest)"
    }
    @IBAction func searchHotelButtonClick(_ sender: Any) {
//        if let hotelListVC =
//            HotelBookingRoomDetailViewController.storyboardInstance() {
//            //  hotelListVC.searchResponseData = response?.data
//            self.navigationController?.pushViewController(hotelListVC, animated: true)
//        }
        
        let request = HotelBookingSearchRequest(city: self.hotelCityView.text!, checkInDate: self.checkInDate, checkOutDate: self.checkOutDate, noOfRooms: self.hotelRoomsView.text!, noOfTravellers: self.hotelGuestView.text!, travellersArray: self.roomArray)
        
        let validationResult = HotelBookingValidation().ValidateSearch(request: request)

        if validationResult.success {
            self.view.endEditing(true)
            DispatchQueue.main.async {
                objHotelBookingManager!.searchRequest = request
                 self.search(request: request)
//                 self.manageBokingButtonClick(UIButton())
            }
           
        }else{
            self.showAlert(title: "", message: validationResult.error!)
        }
    }
    // MARK: - Search
    func search(request:HotelBookingSearchRequest){
        HPProgressHUD.show()
        HotelBookingViewModel().searchHotel(searchRequest: request) { response, error in
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
                    
                    objHotelBookingManager?.guestArray.removeAll()
                    if let hotelListVC = HotelBookingListViewController.storyboardInstance() {
                        hotelListVC.searchResponseData = response?.data
                        self.navigationController?.pushViewController(hotelListVC, animated: true)
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

}
