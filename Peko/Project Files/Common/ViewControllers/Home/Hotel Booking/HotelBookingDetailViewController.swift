//
//  HotelBookingDetailViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 21/08/23.
//

import UIKit

import SwiftyStarRatingView

class HotelBookingDetailViewController: MainViewController {
    
    //    @IBOutlet weak var statusBarView: UIView!
    //    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var bookingTableView: UITableView!
    @IBOutlet var headerView: UIView!
    // @IBOutlet weak var segmentControl: PekoSegmentControl!
    
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingView: SwiftyStarRatingView!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var totalAmountLabel: PekoLabel!
    @IBOutlet weak var buyNowContainerViewHeightConstraint: NSLayoutConstraint!
    
    var roomsArray = [HotelBookingSearchRoomModel]()
    var imagesArray = [HotelBookingHotelImageModel]()
    var aboutString = ""
    var cancelPolicyResponse:HotelBookingHotelDetailsResultsModel?
    
    var selectedRoomsIndx = [Int]()
    var selectedRoomsArray = [HotelBookingSearchRoomModel]()
    
    // var selectedRoomIndex = -1
    
    static func storyboardInstance() -> HotelBookingDetailViewController? {
        return AppStoryboards.HotelBooking.instantiateViewController(identifier: "HotelBookingDetailViewController") as? HotelBookingDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isBackNavigationBarView = true
        self.setTitle(title: "Hotel Booking")
        self.view.backgroundColor = .white
        
        self.getHotelDetail()
        self.buyNowContainerViewHeightConstraint.constant = 0
        // Do any additional setup after loading the view.
    }
    func getHotelDetail(){
        HPProgressHUD.show()
        HotelBookingViewModel().getHotelDetails() { response, error in
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
                    self.setData(data: (response?.data!)!)
                    //                    if let hotelListVC = HotelBookingListViewController.storyboardInstance() {
                    //                        hotelListVC.searchResponseData = response?.data
                    //                        self.navigationController?.pushViewController(hotelListVC, animated: true)
                    //                    }
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
    // MARK: - Set Data
    func setData(data:HotelBookingHotelDetailsResponseModel) {
        
        if let hotelDetail = data.hotelDetails?.data?.first {
            objHotelBookingManager!.hotelDetailsData = hotelDetail
            //
            self.hotelNameLabel.text = hotelDetail.name ?? ""
            self.addressLabel.text = hotelDetail.address ?? ""
            self.ratingView.value = CGFloat(hotelDetail.starRating?.toDouble() ?? 0.0)
            //       self.ratingLabel.text = (hotelDetail.starRating ?? "0.0") + "/5.0"
            
            self.aboutString = hotelDetail.description ?? ""
            self.imagesArray = hotelDetail.images ?? [HotelBookingHotelImageModel]()
            // self.imagesArray = hotelDetail.images ?? [HotelBookingHotelImageModel]()
            
            self.imageCollectionView.delegate = self
            self.imageCollectionView.dataSource = self
            self.imageCollectionView.reloadData()
        }
        
        if let rooms_arr = data.moreRooms?.data?.first?.rooms {
            //  self.hotelNameLabel.text = hotelDetail.name ?? ""
            
            //  let count = Int(objHotelBookingManager?.searchRequest?.noOfRooms ?? "0")!
            
            self.roomsArray = rooms_arr
            
            //            if rooms_arr.count >= count {
            //                self.roomsArray = Array(rooms_arr.prefix(upTo: count))// as! [HotelBookingSearchRoomModel]
            //            }else{
            //                self.roomsArray = rooms_arr
            //            }
        }
        
        self.headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: (screenWidth * 0.78) + 90)
        self.bookingTableView.tableHeaderView = self.headerView
        self.bookingTableView.delegate = self
        self.bookingTableView.dataSource = self
        self.bookingTableView.separatorStyle = .none
        self.bookingTableView.backgroundColor = .clear
        self.bookingTableView.register(UINib(nibName: "HotelBookingRoomTableViewCell", bundle: nil), forCellReuseIdentifier: "HotelBookingRoomTableViewCell")
        
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
        self.imageCollectionView.reloadData()
        
        self.bookingTableView.isHidden = false
        self.bookingTableView.reloadData()
        
        self.setAmount()
    }
    
    // MARK: - Buy Now Button
    @IBAction func buyNoeButtonClick(_ sender: Any) {
        
        let count = Int(objHotelBookingManager?.searchRequest?.noOfRooms ?? "0")!
        if self.selectedRoomsArray.count != count {
            self.showAlert(title: "", message: "Please select \(count) room")
        }else{
            if let roomDetailVC =  HotelBookingRoomDetailViewController.storyboardInstance() {
                objHotelBookingManager?.selectedRooms = self.selectedRoomsArray
                
                self.navigationController?.pushViewController(roomDetailVC, animated: true)
            }
        }
    }
    // MARK: -  // MARK: - Pay Now
    @IBAction func payNowButtonClick(_ sender: Any) {
        //  objHotelBookingManager!.roomsArray = self.roomsArray
        
        HPProgressHUD.show()
        //        let roomKey = objHotelBookingManager?.roomDetails?.roomKey ?? ""
        //        let roomIndex = objHotelBookingManager?.roomDetails?.roomIndex ?? 0
        //
        //        let roomArray = [
        //            [
        //             "roomIndex": roomIndex,
        //             "roomKey": roomKey
        //            ]
        //        ]
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
                        
                        if let roomDetailVC =  HotelBookingRoomDetailViewController.storyboardInstance() {
                            //  objHotelBookingManager?.roomsArray = self.roomsArray
                            self.navigationController?.pushViewController(roomDetailVC, animated: true)
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
    
    func setAmount() {
        self.buyNowContainerViewHeightConstraint.constant = 80
        //  let roomModel = self.roomsArray[self.selectedRoomIndex]
        
        // let amountArray = selectedRoomsArray.compactMap()
        let amountArray = selectedRoomsArray.compactMap({ $0.roomRate?.netAmount ?? 0.0 })
        
        let total = amountArray.reduce(0, +)
        self.totalAmountLabel.text = objUserSession.currency + total.toUSD()
        
    }
}

// MARK: - UITableView Delegate
extension HotelBookingDetailViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        //        if segmentControl.selectedIndex == 1 {
        //            return 3
        //        }
        return 3
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell")
        view!.backgroundColor = .clear
        let label = view?.viewWithTag(101) as! UILabel
        label.font = .bold(size: 18)
        
        if section == 0 {
            label.text = "Description"
        }else if section == 1 {
            label.text = "Facilities"
        }else if section == 2 {
            label.text = "Select Room"
        }
        return view
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return self.selectedRoomsArray.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            /// return 250
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HotelBookingAboutCell")
            cell?.backgroundColor = .clear
            cell?.selectionStyle = .none
            
            let label = cell?.viewWithTag(101) as! UILabel
            
            label.text = aboutString
            
            return cell!
            
            
        }else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "HotelBookingFacilitiesCell") as! HotelBookingFacilitiesCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            cell.collectionView.tag = 100
            cell.collectionView.backgroundColor = .clear
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            
            return cell
            
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HotelBookingRoomTableViewCell") as! HotelBookingRoomTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            let roomModel = self.selectedRoomsArray[indexPath.row]
            cell.roomIndexLabel.text = "Room \(roomModel.roomIndex ?? 0)"
            cell.roomDescLabel.text = roomModel.roomTypeDesc ?? ""
            //  cell.photoImgView.image = nil
            if let tmp = roomModel.roomRate?.rates?.first {
                cell.priceLabel.text = objUserSession.currency + " " + (tmp.amount ?? 0.0).toUSD()
            }else{
                cell.priceLabel.text = ""//(roomModel.roomRate?.currency ?? "") + " " + "\(tmp.amount ?? 0.0)"
            }
            cell.cancellationLabel.text = roomModel.ratePlan?.cancelPolicyIndicator ?? ""
            cell.radioImgView.isHidden = true
            cell.maxGuestLabel.text = "Max Guests \(roomModel.maxOccupancy ?? 0)"
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let roomModel = self.selectedRoomsArray[indexPath.row]
            
            let array = self.roomsArray.filter { $0.roomIndex == roomModel.roomIndex }
            
            if let vc = HotelBookingSelectRoomViewController.storyboardInstance(){
                vc.roomsArray = array
                vc.completionBlock = { room in
                    self.selectedRoomsArray[indexPath.row] = room
                    tableView.reloadData()
                    self.setAmount()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            /*
             if selectedRoomsIndx.contains(indexPath.row) {
             let indx = selectedRoomsIndx.firstIndex(of: indexPath.row)
             selectedRoomsIndx.remove(at: indx!)
             self.selectedRoomsArray.remove(at: indx!)
             }else{
             if Int(objHotelBookingManager?.searchRequest?.noOfRooms ?? "0") ?? 0 > selectedRoomsIndx.count
             {
             selectedRoomsIndx.append(indexPath.row)
             let roomModel = self.roomsArray[indexPath.row]
             
             self.selectedRoomsArray.append(roomModel)
             
             }else{
             self.showAlert(title: "", message: "You have already selected \(self.selectedRoomsIndx.count) room. Remove before adding a new one.")
             }
             }
             self.setAmount()
             tableView.reloadData()
             */
        }
    }
}
// MARK: -
extension HotelBookingDetailViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 100 {
            return 2 //
        }else if collectionView == self.imageCollectionView{
            return self.imagesArray.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 100 {
            return CGSize(width: 72, height: 72)
        }else if collectionView == self.imageCollectionView{
            //    return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
            return CGSize(width: screenWidth - 115, height: collectionView.bounds.height)
            
        }
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 100 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelBookingFacilitiesCollectionCell", for: indexPath)
            cell.backgroundColor = .clear
            
            
            return cell
        }else if collectionView == self.imageCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionView", for: indexPath)
            cell.backgroundColor = .clear
            
            let imageView = cell.viewWithTag(220) as! UIImageView
            
            let imageModel = self.imagesArray[indexPath.row]
            imageView.sd_setImage(with: URL(string: imageModel.path ?? ""))
            
            return cell
            
        }
        return UICollectionViewCell()
    }
    
}

// MARK: - PekoSegmentControlDelegate
extension HotelBookingDetailViewController:PekoSegmentControlDelegate {
    func selectedSegmentIndex(index: Int) {
        self.bookingTableView.reloadData()
    }
}
/*
 extension HotelBookingDetailViewController:UIScrollViewDelegate {
 func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
 
 
 }
 func scrollViewDidScroll(_ scrollView: UIScrollView) {
 
 if scrollView == self.bookingTableView {
 if(self.bookingTableView.contentOffset.y > 0) {
 self.navigationView.backgroundColor = AppColors.blackThemeColor
 self.statusBarView.isHidden = false
 } else {
 self.navigationView.backgroundColor = .clear
 self.statusBarView.isHidden = true
 }
 }
 }
 }
 */
// MARK: -
class HotelBookingFacilitiesCell:UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
}
