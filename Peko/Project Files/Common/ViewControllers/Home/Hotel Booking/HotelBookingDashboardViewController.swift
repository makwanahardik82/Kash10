//
//  HotelBookingDashboardViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 13/08/23.
//

import UIKit
import KMPlaceholderTextView


class HotelBookingDashboardViewController: MainViewController {

    @IBOutlet weak var cityTxt: KMPlaceholderTextView!
   
    @IBOutlet weak var checkInDateTxt: UITextField!
    
    @IBOutlet weak var checkOutDateTxt: UITextField!
    @IBOutlet weak var noOfTravellerTxt: UITextField!
    @IBOutlet weak var noOfRoomsTxt: UITextField!
    
    var checkInDate:Date?
    var checkOutDate:Date?
    var roomArray = [Dictionary<String, Any>]()
    
    static func storyboardInstance() -> HotelBookingDashboardViewController? {
        return AppStoryboards.HotelBooking.instantiateViewController(identifier: "HotelBookingDashboardViewController") as? HotelBookingDashboardViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objHotelBookingManager = HotelBookingManager.sharedInstance
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    // MARK: - City
    
    @IBAction func cityButtonClick(_ sender: Any) {
        let pickerVC = PickerListViewController.storyboardInstance()
        pickerVC?.array = Constants.cityArray
        pickerVC?.selectedString = self.cityTxt.text!
        pickerVC?.titleString = "City"
        pickerVC?.completionBlock = { string in
            self.cityTxt.text = string
        }
        let nav = UINavigationController(rootViewController: pickerVC!)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    // MARK: - Check In
    @IBAction func calendarButtonClick(_ sender: UIButton) {
        
        var minimumDate = Date()
        if sender.tag == 2 {
            if self.checkInDate == nil {
                self.showAlert(title: "", message: "Please select check in date")
                return
            }
            minimumDate = self.checkInDate!
        }
        DispatchQueue.main.async {
            if let calPopupVC = CalendarPopupViewController.storyboardInstance() {
                calPopupVC.modalPresentationStyle = .overCurrentContext
                calPopupVC.minimumDate = minimumDate //.addDays(day: 1)
                calPopupVC.completionBlock = { selectedDate in
                    DispatchQueue.main.async {
                        
                        if sender.tag == 1 {
                            self.checkInDateTxt.text = selectedDate.formate(format: "dd, MMMM, yyyy")
                            self.checkInDate = selectedDate
                         //   self.requestModel.departure_date = selectedDate
                        }else{
                            self.checkOutDateTxt.text = selectedDate.formate(format: "dd, MMMM, yyyy")
                            self.checkOutDate = selectedDate
                          //  self.requestModel.return_date = selectedDate
                        }
                    }
                }
                self.present(calPopupVC, animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func noOfTravellerButtonClick(_ sender: Any) {
        
        if self.noOfRoomsTxt.text?.count == 0{
                self.showAlert(title: "", message: "Please select room")
                return
        }
        if let pickerVC = HotelBookingSelectTravellerViewController.storyboardInstance() {
            pickerVC.roomArray = self.roomArray
            pickerVC.completionBlock = { array in
                self.roomArray = array
                self.setTraveller()
            }
          //  let nav = UINavigationController(rootViewController: pickerVC)
           // nav.modalPresentationStyle = .fullScreen
            self.present(pickerVC, animated: true)
        }
    }
    func setTraveller(){
        
        let total_adult = self.roomArray.compactMap { $0["adult"] as? Int }.reduce(0, +)
        let total_child = self.roomArray.compactMap { $0["child"] as? Int }.reduce(0, +)
        
        var str = "\(total_adult) Adult"
        if total_child > 0 {
            str.append(", \(total_child) child")
        }
        self.noOfTravellerTxt.text = str
        
    }
    // MARK: -
    @IBAction func noOfRoomsButtonClick(_ sender: Any) {
        let pickerVC = PickerListViewController.storyboardInstance()
        pickerVC?.array = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
        pickerVC?.selectedString = self.noOfRoomsTxt.text!
        pickerVC?.titleString = "Rooms"
        pickerVC?.completionBlock = { string in
            self.noOfRoomsTxt.text = string
            
            let strInt = Int(string) ?? 0
           
            if self.roomArray.count == 0 {
                for x in 1...strInt {
                    let dic = [
                        "adult": 1,
                        "child": 0,
                        "roomIndex": x
                    ]
                    self.roomArray.append(dic)
                }
               
            }else{
                if strInt > self.roomArray.count {
                   //  let dif = strInt - self.roomArray.count
                    
                    for x in (self.roomArray.count + 1)...strInt {
                        let dic = [
                            "adult": 1,
                            "child": 0,
                            "roomIndex": x
                        ]
                        self.roomArray.append(dic)
                    }
                }else{
                    let dif = self.roomArray.count - strInt
                    self.roomArray.removeLast(dif)
                }
            }
            self.setTraveller()
        }
        let nav = UINavigationController(rootViewController: pickerVC!)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    // MARK: - Search Button
    @IBAction func searchButtonClick(_ sender: Any) {
       
        let request = HotelBookingSearchRequest(city: self.cityTxt.text!, checkInDate: self.checkInDate, checkOutDate: self.checkOutDate, noOfRooms: self.noOfRoomsTxt.text!, noOfTravellers: self.noOfTravellerTxt.text!, travellersArray: self.roomArray)
        
        let validationResult = HotelBookingValidation().ValidateSearch(request: request)

        if validationResult.success {
            self.view.endEditing(true)
            DispatchQueue.main.async {
                objHotelBookingManager?.searchRequest = request
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
    // MARK: -
//    @IBAction func manageBokingButtonClick(_ sender: Any) {
//        if let manageVC = HotelManageBookingViewController.storyboardInstance() {
//            self.navigationController?.pushViewController(manageVC, animated: true)
//        }
////        if let successVC = HotelBookingRoomDetailViewController.storyboardInstance() {
////            self.navigationController?.pushViewController(successVC, animated: true)
////        }
//    }
    
    // MARK: - Status
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }

}
