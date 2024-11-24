//
//  HotelBookingListViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 19/08/23.
//

import UIKit

class HotelBookingListViewController: MainViewController {

//    @IBOutlet weak var cityLabel: UILabel!
//    @IBOutlet weak var checkInDateLabel: UILabel!
//    @IBOutlet weak var checkOutDateLabel: UILabel!
//    @IBOutlet weak var detailLabel: UILabel!
//    
//    @IBOutlet weak var searchTxt: UITextField!
    
    var searchResponseData:HotelBookingSearchResponseModel?
    var filteredArray = [HotelBookingSearchResponseDataModel]()
    
    @IBOutlet weak var bookingTableView: UITableView!
    static func storyboardInstance() -> HotelBookingListViewController? {
        return AppStoryboards.HotelBooking.instantiateViewController(identifier: "HotelBookingListViewController") as? HotelBookingListViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isBackNavigationBarView = true
        self.setTitle(title: "Hotel Booking")
        self.view.backgroundColor = .white
      
        self.filteredArray = searchResponseData?.data ?? [HotelBookingSearchResponseDataModel]()
        
        self.bookingTableView.delegate = self
        self.bookingTableView.dataSource = self
        self.bookingTableView.register(UINib(nibName: "HotelBookingListTableViewCell", bundle: nil), forCellReuseIdentifier: "HotelBookingListTableViewCell")
        self.bookingTableView.backgroundColor = .clear
        self.bookingTableView.separatorStyle = .none
        
        
        /*
        self.cityLabel.text = objHotelBookingManager?.searchRequest?.city ?? ""
        self.checkInDateLabel.text = objHotelBookingManager?.searchRequest?.checkInDate?.formate(format: "dd-MM-yyyy") ?? ""
        self.checkOutDateLabel.text =  objHotelBookingManager?.searchRequest?.checkOutDate?.formate(format: "dd-MM-yyyy") ?? ""
       
        var str = ""
      
        let total_adult = objHotelBookingManager?.searchRequest?.travellersArray!.compactMap { $0["adult"] as? Int }.reduce(0, +)
        
        str = "\(total_adult ?? 0) Adult"
        let total_child = objHotelBookingManager?.searchRequest?.travellersArray!.compactMap { $0["child"] as? Int }.reduce(0, +)
        
        
        if total_child != 0 {
            str = str + ", \(total_adult ?? 0) Child"
        }
        str = str + "| \(objHotelBookingManager?.searchRequest?.travellersArray?.count ?? 0) Room"
        self.detailLabel.text = str
        
        self.searchTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        */
    }
    /*
    @objc func textFieldDidChange(_ textField: UITextField) {
        let searchString = self.searchTxt.text?.lowercased() ?? ""
        
        if searchString.count == 0 {
            self.filteredArray = searchResponseData?.data ?? [HotelBookingSearchResponseDataModel]()
        }else{
            let arr = searchResponseData?.data ?? [HotelBookingSearchResponseDataModel]()
        
            self.filteredArray = arr.filter { ($0.propertyInfo?.hotelName ?? "").lowercased().contains(searchString) }
        }
        self.bookingTableView.reloadData()
    }
   
    */
}

// MARK: - UITableView 
extension HotelBookingListViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.filteredArray.count
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 144
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotelBookingListTableViewCell") as! HotelBookingListTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
       
        let hotelDic = self.filteredArray[indexPath.row]
        
        // propertyInfo
        
        let hotelInfo = hotelDic.propertyInfo
        cell.photoImgView.sd_setImage(with: URL(string: hotelInfo?.imageUrl ?? ""))
        cell.nameLabel.text = hotelInfo?.hotelName ?? ""
        cell.locationLabel.text = hotelInfo?.address ?? ""
        cell.ratingView.value = CGFloat((hotelInfo?.starRating ?? "0.0").toDouble())
        
        if let room = hotelDic.rooms?.first {
            cell.priceLabel.text = objUserSession.currency + " " + (room.roomRate?.netAmount ?? 0.0).toUSD()
            
            if let ratePlan = room.ratePlan {
             //   cell.roomDescLabel.text = ratePlan.meal ?? ""
                cell.cancelationDetailLabel.text = ratePlan.cancelPolicyIndicator ?? ""
            }
            
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        DispatchQueue.main.async {
            let hotelDic = self.filteredArray[indexPath.row]
           
            objHotelBookingManager!.conversationId = self.searchResponseData!.conversationId ?? ""
            objHotelBookingManager!.searchKey = self.searchResponseData!.commonData!.searchKey ?? ""
            objHotelBookingManager!.hotelListData = self.filteredArray[indexPath.row]
            objHotelBookingManager!.hotelKey = self.filteredArray[indexPath.row].hotelKey ?? ""
           // objHotelBookingManager?.selectedRooms
            if let detailVC = HotelBookingDetailViewController.storyboardInstance() {
                detailVC.selectedRoomsArray = hotelDic.rooms!
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
}
