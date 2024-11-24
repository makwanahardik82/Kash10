//
//  AirticketPassengerDetailsViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 08/03/24.
//

import UIKit

class AirticketPassengerDetailsViewController: MainViewController {

    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet var footerView: UIView!
    
    @IBOutlet weak var fareTypeLabel: PekoLabel!
    @IBOutlet weak var baseFareLabel: PekoLabel!
    @IBOutlet weak var taxLabel: PekoLabel!
    @IBOutlet weak var discountLabel: PekoLabel!
    @IBOutlet weak var totalAmountLabel: PekoLabel!
    
    var conversationId = ""
    var ancSearchModel:AirTicketAncSearchModel?
    
    @IBOutlet weak var finalTotalAmountLabel: PekoLabel!
    
    
    @IBOutlet weak var addOnAmountLabel: PekoLabel!
    
    private var selectedSeatArray = [AirTicketAncSeatMapCabinDeckAirRowAirSeatsModel]()
    private var selectedMealModel:AirTicketAncMealModel?
    private var selectedBaggagesModel:AirTicketAncBaggagesModel?
    
    var totalAmount = 0.0
    
    static func storyboardInstance() -> AirticketPassengerDetailsViewController? {
        return AppStoryboards.Air_Ticket.instantiateViewController(identifier: "AirticketPassengerDetailsViewController") as? AirticketPassengerDetailsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isBackNavigationBarView = true
        self.setTitle(title: "Passenger Details")
        self.view.backgroundColor = .white
        
        detailTableView.register(UINib(nibName: "AirlineTicketDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "AirlineTicketDetailsTableViewCell")
        detailTableView.separatorStyle = .none
        detailTableView.backgroundColor = .clear
        detailTableView.delegate = self
        detailTableView.dataSource = self
        
        // self.detailTableView.tableHeaderView = self.headerView
        self.detailTableView.tableFooterView = self.footerView
        self.detailTableView.register(UINib(nibName: "AddPassengersTableViewCell", bundle: nil), forCellReuseIdentifier: "AddPassengersTableViewCell")
        self.detailTableView.register(UINib(nibName: "AirlineAddTableViewCell", bundle: nil), forCellReuseIdentifier: "AirlineAddTableViewCell")
        self.detailTableView.register(UINib(nibName: "AirlineTicketTwoWayDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "AirlineTicketTwoWayDetailsTableViewCell")
       
        self.detailTableView.register(UINib(nibName: "PassengerListTableViewCell", bundle: nil), forCellReuseIdentifier: "PassengerListTableViewCell")
       
        
        let fare = objAirTicketManager?.selectedAirlinesDataModel?.fare
       
        let baseFareAmount = (fare?.baseFare?.value ?? 0.0) + (fare?.customerAdditionalFareInfo?.transactionFeeEarned?.value ?? 0.0)
        let taxAmount = (fare?.totalTax?.value ?? 0.0)
        totalAmount = (fare?.totalFare?.value ?? 0.0)
        
        let discountAmount = (fare?.customerAdditionalFareInfo?.discount?.value ?? 0.0)
       
        self.baseFareLabel.text = objUserSession.currency + baseFareAmount.withCommas()
        self.discountLabel.text = objUserSession.currency + discountAmount.withCommas()
        self.taxLabel.text = objUserSession.currency + taxAmount.withCommas()
        self.totalAmountLabel.text = objUserSession.currency + totalAmount.withCommas()
        self.finalTotalAmountLabel.text = objUserSession.currency + totalAmount.withCommas()
        
        self.addOnAmountLabel.text = objUserSession.currency + (0.0).withCommas()
        if (objAirTicketManager?.selectedAirlinesDataModel?.fare?.fareType?.refundable) ?? false {
            self.fareTypeLabel.text = "Refundable"
        }else{
            self.fareTypeLabel.text = "Non-Refundable"
        }
        self.detailTableView.isHidden = true
        self.getAncSearch()
    }
    
    // MARK: -
    func getAncSearch(){
        HPProgressHUD.show()
        AirTicketViewModel().getAncSearch() { response, error in
            HPProgressHUD.hide()
            print(response)
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    print(response?.data?.conversationId)
                 
                    if let anc = response?.data?.data?.first {
                        self.ancSearchModel = anc
                    }
                    self.detailTableView.isHidden = false
                    self.detailTableView.reloadData()
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
    
    func updateAmount(){
        
        var amount = 0.0
        if self.selectedMealModel != nil {
            if let fare = self.selectedMealModel?.fare?.first {
                amount = amount + (fare.sellingAmount?.value ?? 0.0)
            }
        }
        if self.selectedBaggagesModel != nil {
            if let fare = self.selectedBaggagesModel?.fare?.first {
                amount = amount + (fare.sellingAmount?.value ?? 0.0)
            }
        }
        
        for seat in self.selectedSeatArray {
            amount = amount + (seat.fare?.first?.buyingAmount?.value ?? 0.0)
        }
        self.addOnAmountLabel.text = objUserSession.currency + amount.withCommas()
        let final = totalAmount + amount
        self.totalAmountLabel.text = objUserSession.currency + final.withCommas()
        self.finalTotalAmountLabel.text = objUserSession.currency + final.withCommas()
        
        objAirTicketManager?.addOnsAmount = amount
        
    }
    
    // MARK: - Pay Now Button Click
    @IBAction func payNowButtonClick(_ sender: Any) {
        HPProgressHUD.show()
        var ancillaryArray = [[String:String]]()
        if self.selectedMealModel != nil {
            let pKey = selectedMealModel?.segmentPassengerMapping?.passengerKeys?.first
            let dic = [
                "ancillaryOfferId": self.selectedMealModel?.ancillary?.ancillaryOfferId ?? "",
                "passengerKey": pKey ?? ""
            ]
            ancillaryArray.append(dic)
        }
        if self.selectedBaggagesModel != nil {
            let pKey = selectedBaggagesModel?.segmentPassengerMapping?.passengerKeys?.first
           
            let dic = [
                "ancillaryOfferId": self.selectedBaggagesModel?.ancillary?.ancillaryOfferId ?? "",
                "passengerKey": pKey ?? ""
            ]
            ancillaryArray.append(dic)
        }
        
        
        if self.ancSearchModel?.seatMap != nil {
            var pKeyArray = [String]()
          
            for seatMap in self.ancSearchModel!.seatMap! {
                let keys =  (seatMap.cabin?.first?.segmentPassengerMapping?.passengerKeys) ?? [String]()
                pKeyArray.append(contentsOf: keys)
            }
            
            
            for (index, seat) in self.selectedSeatArray.enumerated() {
                
                let dic = [
                    "ancillaryOfferId": seat.ancillaryOfferId ?? "",
                    "passengerKey": pKeyArray[index] 
                ]
                ancillaryArray.append(dic)
            }
        }
       
        if ancillaryArray.count == 0 {
            self.goToPaymentVC()
        }else{
            AirTicketViewModel().provisionalAncSearchAncillary(ancillaryArray: ancillaryArray) { response, error in
                HPProgressHUD.hide()
                print(response)
                if error != nil {
    #if DEBUG
                    self.showAlert(title: "", message: error?.localizedDescription ?? "")
    #else
                    self.showAlert(title: "", message: "Something went wrong please try again")
    #endif

                }else if let status = response?.status, status == true {
                    DispatchQueue.main.async {
                        print(response?.data?.conversationId)
                        objAirTicketManager!.ancillaryArray = ancillaryArray
                        self.goToPaymentVC()
    //                    if let anc = response?.data?.data?.first {
    //                        self.ancSearchModel = anc
    //                    }
    //                    self.detailTableView.isHidden = false
    //                    self.detailTableView.reloadData()
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
    func goToPaymentVC(){
        if let vc = PaymentReviewViewController.storyboardInstance() {
           vc.paymentPayNow = .AirTicket
           self.navigationController?.pushViewController(vc, animated: true)
       }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.detailTableView.reloadData()
    }
}
extension AirticketPassengerDetailsViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }else{
            if section == 1 && self.ancSearchModel?.seatMap == nil {
                return 0
            }else if section == 2 && self.ancSearchModel?.meals == nil {
                return 0
            }else if section == 3 && self.ancSearchModel?.baggages == nil {
                return 0
            }
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if objAirTicketManager?.airTicketWayType == .OneWay {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AirlineTicketDetailsTableViewCell") as! AirlineTicketDetailsTableViewCell
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                
                let origin = objAirTicketManager?.request.origin?.city_name ?? ""
                let destination = objAirTicketManager?.request.destination?.city_name ?? ""
                
                cell.departureLabel.text = "Departure: \(origin)-\(destination)"
                cell.passengerlabel.text = "\(objAirTicketManager?.request.passengersCount ?? "") passengers - \(objAirTicketManager?.request.travel_class ?? "")"
                
                let model = objAirTicketManager?.selectedAirlinesDataModel!
                
                if let journey = model?.journey?.first, let first =  journey.flightSegments?.first, let last =  journey.flightSegments?.last {
                   
                    cell.sourceAirportNameLabel.text = first.departureAirportCode ?? ""
                    let takeOfDate = first.departureDateTime?.toDate()
                    cell.takeOffDateLabel.text = takeOfDate?.formate(format: "dd MMM yyyy")
                    cell.takeOffTimeLabel.text = takeOfDate?.formate(format: "hh:mm a")
                    cell.sourceAirportCityLabel.text = origin
                    cell.sourceAirportTerminalLabel.text = "Terminal " + (first.departureTerminal ?? "")
                    
                   
                    cell.destinationAirportLabel.text = last.arrivalAirportCode ?? ""
                    let arrivalDate = last.arrivalDateTime?.toDate()
                    cell.reachDateLabel.text = arrivalDate?.formate(format: "dd MMM yyyy")
                    cell.reachTimeLabel.text = arrivalDate?.formate(format: "hh:mm a")
                    cell.destinationAirportCityLabel.text = destination
                    cell.destinationAirportTerminalLabel.text = "Terminal " + (last.arrivalTerminal ?? "")
                    
                    
                    if first.baggageAllowance?.checkedInBaggage?.count != 0 {
                        let tmp = first.baggageAllowance?.checkedInBaggage?.first
                        
                        let string = (tmp?.value ?? "") + " " + (tmp?.unit ?? "")
                        cell.checkInBaggageLabel.text = "Check-in : " + string
                    }else{
                        cell.checkInBaggageLabel.text = "Check-in : -"
                    }
                    cell.cabinLabel.text = "Cabin : " + (first.cabinClass ?? "")
                }
               
                let airline_code = (model?.fare?.platingAirlineCode ?? "")
                cell.flightNameLabel.text = objAirTicketManager?.selectedAirlinesName
                
                let imgString = "https://res.cloudinary.com/dqhshqcqd/image/upload/v1710764763/Airline/\(airline_code).png"
                cell.flightLogoImgView.sd_setImage(with: URL(string: imgString))
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "AirlineTicketTwoWayDetailsTableViewCell") as! AirlineTicketTwoWayDetailsTableViewCell
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AirlineAddTableViewCell") as! AirlineAddTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.selectButton.removeTarget(nil, action: nil, for: .allEvents)

            cell.tagCollectionView.register(UINib(nibName: "AirTicketTagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AirTicketTagCollectionViewCell")
            cell.tagCollectionView.backgroundColor = .clear
            
            if indexPath.section == 1 {
                cell.titleLabel.text = "Select Seats"
                cell.selectButton.setTitle("Select", for: .normal)
                cell.selectButton.addTarget(self, action: #selector(selectSeatButtonClick(sender:)), for: .touchUpInside)
                
                cell.tagCollectionView.tag = 100
                
                if self.selectedSeatArray.count == 0 {
                    cell.tagCollectionView.isHidden = true
                }else{
                    cell.tagCollectionView.delegate = self
                    cell.tagCollectionView.dataSource = self
                    cell.tagCollectionView.isHidden = false
                }
                
            }else if indexPath.section == 2 {
                cell.titleLabel.text = "Select Meals"
                cell.selectButton.setTitle("Select", for: .normal)
                cell.selectButton.addTarget(self, action: #selector(selectMealsButtonClick(sender:)), for: .touchUpInside)
                
                cell.tagCollectionView.tag = 200
                
                if self.selectedMealModel == nil {
                    cell.tagCollectionView.isHidden = true
                }else{
                    cell.tagCollectionView.delegate = self
                    cell.tagCollectionView.dataSource = self
                    cell.tagCollectionView.isHidden = false
                }
                
            }else if indexPath.section == 3 {
                cell.titleLabel.text = "Add Extra Luggage"
                cell.selectButton.setTitle("Add", for: .normal)
                cell.selectButton.addTarget(self, action: #selector(addExtaluggageButtonClick(sender: )), for: .touchUpInside)
                
                cell.tagCollectionView.tag = 300
                
                if self.selectedBaggagesModel == nil {
                    cell.tagCollectionView.isHidden = true
                }else{
                    cell.tagCollectionView.delegate = self
                    cell.tagCollectionView.dataSource = self
                    cell.tagCollectionView.isHidden = false
                }
              
            }
            cell.tagCollectionView.reloadData()
            return cell
        }
    }

    // MARK: - Add Passenger
    @objc func selectSeatButtonClick(sender:UIButton) {
        if let seatVC = AirTicketSelectSeatViewController.storyboardInstance() {
            
            seatVC.seatArray = self.ancSearchModel?.seatMap ?? [AirTicketAncSeatMapModel]()
            let ancillary = self.ancSearchModel?.ancillaryRules?.filter({ $0.ancillaryType == "SEAT" })
            seatVC.ancRulesModel = ancillary?.first
            seatVC.completionBlock = { array in
                self.selectedSeatArray = array
                self.detailTableView.reloadData()
                self.updateAmount()
            }
            self.navigationController?.pushViewController(seatVC, animated: true)
        }
        
    }
    // MARK: - Add Passenger
    @objc func selectMealsButtonClick(sender:UIButton) {
        if let addVC = AirTicketAddMealViewController.storyboardInstance() {
            addVC.mealArray = self.ancSearchModel?.meals ?? [AirTicketAncMealModel]()
            addVC.completionBlock = { model in
                self.selectedMealModel = model
                self.detailTableView.reloadData()
                self.updateAmount()
            }
            self.navigationController?.pushViewController(addVC, animated: true)
        }
    }
    // MARK: - Add Passenger
    @objc func addExtaluggageButtonClick(sender:UIButton) {
        if let addVC = AirTicketAddLuggageViewController.storyboardInstance() {
            addVC.baggagesArray = self.ancSearchModel?.baggages ?? [AirTicketAncBaggagesModel]()
            addVC.completionBlock = { model in
                self.selectedBaggagesModel = model
                self.detailTableView.reloadData()
                self.updateAmount()
            }
            self.navigationController?.pushViewController(addVC, animated: true)
        }
    }
}


// MARK: -
// MARK: -
extension AirticketPassengerDetailsViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 100 {
            return self.selectedSeatArray.count
        }
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AirTicketTagCollectionViewCell", for: indexPath) as! AirTicketTagCollectionViewCell
        cell.backgroundColor = .clear
        cell.closeImgView.isHidden = true
        
        if collectionView.tag == 100 {
            let model = self.selectedSeatArray[indexPath.row]
            cell.titleLabel.text = model.seatCode
            
        }else if collectionView.tag == 200 { // MEAL
            cell.titleLabel.text = self.selectedMealModel?.ancillary?.ancillaryDescription ?? ""
        }else if  collectionView.tag == 300 { // Baggage
            cell.titleLabel.text = self.selectedBaggagesModel?.ancillary?.ancillaryDescription ?? ""
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
