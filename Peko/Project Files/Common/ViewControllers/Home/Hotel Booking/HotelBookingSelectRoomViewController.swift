//
//  HotelBookingSelectRoomViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 27/03/24.
//

import UIKit

class HotelBookingSelectRoomViewController: MainViewController {

    @IBOutlet weak var bookingTableView: UITableView!
   
    var selectedRoom:HotelBookingSearchRoomModel?
    var roomsArray = [HotelBookingSearchRoomModel]()
    var selectedRoomsIndx = -1
    
    var completionBlock:((_ selectedRoom: HotelBookingSearchRoomModel) -> Void)?
   
    static func storyboardInstance() -> HotelBookingSelectRoomViewController? {
        return AppStoryboards.HotelBooking.instantiateViewController(identifier: "HotelBookingSelectRoomViewController") as? HotelBookingSelectRoomViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Select Room")
        self.view.backgroundColor = .white
      
        self.bookingTableView.delegate = self
        self.bookingTableView.dataSource = self
        self.bookingTableView.separatorStyle = .none
        self.bookingTableView.backgroundColor = .clear
        self.bookingTableView.register(UINib(nibName: "HotelBookingRoomTableViewCell", bundle: nil), forCellReuseIdentifier: "HotelBookingRoomTableViewCell")
        
        // Do any additional setup after loading the view.
    }
    @IBAction func clearButtonClick(_ sender: Any) {
        self.selectedRoomsIndx = -1
        self.bookingTableView.reloadData()
    }
    
    @IBAction func doneButtonClick(_ sender: Any) {
        if self.selectedRoomsIndx == -1 {
            self.showAlert(title: "", message: "Please select room")
        }else{
            let model = self.roomsArray[self.selectedRoomsIndx]
            if self.completionBlock != nil {
                self.completionBlock!(model)
            }
            self.navigationController?.popViewController(animated: false)
        }
    }
}
extension HotelBookingSelectRoomViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.roomsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotelBookingRoomTableViewCell") as! HotelBookingRoomTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let roomModel = self.roomsArray[indexPath.row]
        
        cell.roomDescLabel.text = roomModel.roomTypeDesc ?? ""
      //  cell.photoImgView.image = nil
        if let tmp = roomModel.roomRate?.rates?.first {
            cell.priceLabel.text = objUserSession.currency + " " + (tmp.amount ?? 0.0).toUSD()
        }else{
            cell.priceLabel.text = ""//(roomModel.roomRate?.currency ?? "") + " " + "\(tmp.amount ?? 0.0)"
        }
        cell.cancellationLabel.text = roomModel.ratePlan?.cancelPolicyIndicator ?? ""
     
        cell.radioImgView.isHidden = false
        if selectedRoomsIndx == indexPath.row {
            cell.containerView.borderColor = .redButtonColor
            cell.radioImgView.image = UIImage(named: "icon_radio_red")
        }else{
            cell.containerView.borderColor = UIColor(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1.0)
            cell.radioImgView.image = UIImage(named: "icon_radio_gray")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRoomsIndx = indexPath.row
        tableView.reloadData()
        
    }
}
