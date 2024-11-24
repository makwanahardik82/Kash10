//
//  HotelBookingRoomDetailViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 08/01/24.
//

import UIKit

import SwiftyStarRatingView

class HotelBookingRoomDetailViewController: MainViewController {

    @IBOutlet weak var roomTableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var footerView: UIView!
    
    @IBOutlet weak var hotelNameLabel: PekoLabel!
    @IBOutlet weak var hotelPriceLabel: PekoLabel!
    @IBOutlet weak var photoImgView: UIImageView!
    @IBOutlet weak var hotelratingView: SwiftyStarRatingView!
    
    @IBOutlet weak var roomTitleLabel: PekoLabel!
    
    //@IBOutlet weak var line1View: UIView!
    @IBOutlet weak var line2View: UIView!
    
    @IBOutlet weak var checkInDateLabel: PekoLabel!
    @IBOutlet weak var checkOutDateLabel: PekoLabel!
 
    @IBOutlet weak var roomTypeLabel: PekoLabel!
    @IBOutlet weak var roomCapacityLabel: PekoLabel!
    @IBOutlet weak var totalPriceLabel: PekoLabel!
    
    @IBOutlet weak var amountLabel: PekoLabel!
    @IBOutlet weak var discountLabel: PekoLabel!
    @IBOutlet weak var taxLabel: PekoLabel!
    @IBOutlet weak var totalAmountLabel: PekoLabel!
   
    @IBOutlet weak var guestCountlabel: PekoLabel!
    @IBOutlet weak var roomColectionView: UICollectionView!
    
    var cancelPolicyResponse:HotelBookingSearchResponseModel?
  //  var guestArray = [HotelBookingGuestModel]()
    // var hotelDetails:HotelBookingSearchResponseDataModel?
   // var roomDetails:HotelBookingSearchRoomModel?
    
    static func storyboardInstance() -> HotelBookingRoomDetailViewController? {
        return AppStoryboards.HotelBooking.instantiateViewController(identifier: "HotelBookingRoomDetailViewController") as? HotelBookingRoomDetailViewController
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Hotel Booking")
        self.view.backgroundColor = .white
        
        self.roomTableView.register(UINib(nibName: "PassengerListTableViewCell", bundle: nil), forCellReuseIdentifier: "PassengerListTableViewCell")
     
        let hotelInfo = objHotelBookingManager!.hotelListData?.propertyInfo
        
        self.hotelNameLabel.text = hotelInfo?.hotelName ?? ""
        self.photoImgView.sd_setImage(with: URL(string: hotelInfo?.imageUrl ?? ""))
        self.hotelratingView.value = CGFloat(hotelInfo?.starRating?.toDouble() ?? 0.0) //hotelInfo?.starRating
        
        if let roomRates = objHotelBookingManager?.selectedRooms.first?.roomRate {
            
            let tmp = roomRates.rates?.first
            let  currency = objUserSession.currency //roomRates.currency
            let str = currency + " " + (tmp?.amount ?? 0.0).toUSD()
            
            self.hotelPriceLabel.attributedText = NSMutableAttributedString().color(.redButtonColor, str, font: .bold(size: 14)).color(.gray, "/Night", font: .regular(size: 14))
        }
      
        
        self.checkInDateLabel.text = objHotelBookingManager?.searchRequest?.checkInDate?.formate(format: "dd MMM, yyyy")
        self.checkOutDateLabel.text = objHotelBookingManager?.searchRequest?.checkOutDate?.formate(format: "dd MMM, yyyy")
     
//        self.roomTypeLabel.text = objHotelBookingManager?.selectedRoom?.roomTypeDesc ?? ""
//        self.roomCapacityLabel.text = ""
        
        let amountArray = objHotelBookingManager?.selectedRooms.compactMap({ $0.roomRate?.netAmount ?? 0.0 })
        let amount = amountArray!.reduce(0, +)
      
        
        let currency = objUserSession.currency //(objHotelBookingManager?.selectedRoom?.roomRate?.currency ?? "")
       // let amount = objHotelBookingManager?.selectedRoom?.roomRate?.netAmount ?? 0.0
        
        self.totalPriceLabel.text = currency + amount.toUSD()
        self.amountLabel.text = currency + amount.toUSD()
        self.discountLabel.text = currency + "0.0"
        self.taxLabel.text = currency + "0.0"
        self.totalAmountLabel.text = currency + amount.toUSD()
        
        
        roomColectionView.delegate = self
        roomColectionView.dataSource = self
        roomColectionView.backgroundColor = .clear
     
        self.roomTableView.isHidden = false
      
        self.roomTableView.tableHeaderView = self.headerView
        self.roomTableView.tableFooterView = self.footerView
        self.roomTableView.delegate = self
        self.roomTableView.dataSource = self
      
        self.roomTableView.backgroundColor = .clear
        
        self.roomTableView.separatorStyle = .none
      //  self.roomTableView.register(UINib(nibName: "HotelBookingPassengerTableViewCell", bundle: nil), forCellReuseIdentifier: "HotelBookingPassengerTableViewCell")
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let total_adult = objHotelBookingManager?.searchRequest?.travellersArray!.compactMap { $0["adult"] as? Int }.reduce(0, +) ?? 0
        let total_child = objHotelBookingManager?.searchRequest?.travellersArray!.compactMap { $0["child"] as? Int }.reduce(0, +) ?? 0
        let infants = objHotelBookingManager?.searchRequest?.travellersArray!.compactMap { $0["infants"] as? Int }.reduce(0, +) ?? 0
       
        let total_guest = total_adult + total_child + infants

        self.guestCountlabel.text = "\(objHotelBookingManager?.guestArray.count ?? 0)/\(total_guest )"
        self.roomTableView.reloadData()
      
     //
        
    }
    // MARK: -
    @IBAction func addGuestButtonClick(_ sender: Any) {
        
        if let addVC = HotelBookingGuestListViewController.storyboardInstance() {
            self.navigationController?.pushViewController(addVC, animated: true)
        }
        /*
        if (objHotelBookingManager?.guestArray.count ?? 0) == Int(objHotelBookingManager?.searchRequest?.noOfTravellers ?? "0") {
          
            self.showAlert(title: "", message: "You have already selected \((objHotelBookingManager?.searchRequest?.noOfTravellers ?? "")) guest. Remove before adding a new one.")
            
        }else{
            if let addVC = HotelBookingGuestListViewController.storyboardInstance() {
                self.navigationController?.pushViewController(addVC, animated: true)
            }
        }
        */
       
    }
    // MARK: - 
    func getCancellationPolicy(){
        
        HPProgressHUD.show()
        HotelBookingViewModel().getCancellationPolicy() { response, error in
            HPProgressHUD.hide()
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.success, status == true {
                DispatchQueue.main.async {
                    print(response?.details)
                    self.roomTableView.isHidden = false
                    
                    self.cancelPolicyResponse = response?.details
                  
                    self.roomTableView.reloadData()
                
                }
            }else{
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
    
    // MARK: - Pay Now
    @IBAction func payNowButtonClick(_ sender: Any) {
       
        if Int(objHotelBookingManager?.searchRequest?.noOfTravellers ?? "0")! > objHotelBookingManager?.guestArray.count ?? 0 {
            self.showAlert(title: "", message: "Please enter guest details")
        }else{
            self.preBook()
        }
        
    }
    func preBook(){
        HPProgressHUD.show()
        HotelBookingViewModel().preBook() { response, error in
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
                    if let first = response?.data?.data?.first as? HotelBookingPreBookDataResponseModel {
                        objHotelBookingManager!.hotelPreBookResponse = first
                        
                        if let paymentReviewVC = PaymentReviewViewController.storyboardInstance() {
                            paymentReviewVC.paymentPayNow = .HotelBooking
                            self.navigationController?.pushViewController(paymentReviewVC, animated: true)
                        }
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
// MARK: -
extension HotelBookingRoomDetailViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //objHotelBookingManager!.guestArray.count  //(objHotelBookingManager!.searchRequest?.travellersArray!.count)! + 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objHotelBookingManager!.guestArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PassengerListTableViewCell") as! PassengerListTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let guestModel = objHotelBookingManager!.guestArray[indexPath.row]
        
        cell.titleLabel.text = guestModel.first_name + guestModel.last_name
        return cell
      
    }
}
// MARK: - CollectionView
extension HotelBookingRoomDetailViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objHotelBookingManager?.selectedRooms.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     //   let width = screenWidth - 40
        return CGSize(width: screenWidth, height: 140)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomDetailCollectionViewCell", for: indexPath) as! RoomDetailCollectionViewCell
        
        let selectedRoom = objHotelBookingManager?.selectedRooms[indexPath.row]
        
        cell.roomTitleLabel.text = selectedRoom?.roomTypeDesc ?? ""
     
        cell.cancelationDatelabel.text = "-"
        return cell
    }
}

// MARK: -
class BookingDetailTableViewCell:UITableViewCell {
   
    @IBOutlet weak var nameLabel: PekoLabel!
    
    @IBOutlet weak var noOfPeopleLabel: PekoLabel!
    
    @IBOutlet weak var cancelationLabel: PekoLabel!
}

class RoomDetailCollectionViewCell:UICollectionViewCell {
    @IBOutlet weak var roomTitleLabel: PekoLabel!
    
    @IBOutlet weak var sqftLabel: PekoLabel!
    
    @IBOutlet weak var maxGuestLabel: PekoLabel!
    
    @IBOutlet weak var cancelationDatelabel: PekoLabel!
    
}
