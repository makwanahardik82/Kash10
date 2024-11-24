//
//  AirTicketDetailViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 11/02/23.
//

import UIKit

class AirTicketDetailViewController: MainViewController {

    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet var footerView: UIView!
    
    @IBOutlet weak var fullNameView: PekoFloatingTextFieldView!
    @IBOutlet weak var phoneNumberView: PekoFloatingTextFieldView!
    @IBOutlet weak var emailView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var fareTypeLabel: PekoLabel!
    @IBOutlet weak var baseFareLabel: PekoLabel!
    @IBOutlet weak var taxLabel: PekoLabel!
    @IBOutlet weak var discountLabel: PekoLabel!
    @IBOutlet weak var totalAmountLabel: PekoLabel!
    
  //  var passangerArray = [AirTicketPassangerDetailsModel]()
    
    static func storyboardInstance() -> AirTicketDetailViewController? {
        return AppStoryboards.Air_Ticket.instantiateViewController(identifier: "AirTicketDetailViewController") as? AirTicketDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Ticket Details")
        self.view.backgroundColor = .white
        
        let fare = objAirTicketManager?.selectedAirlinesDataModel?.fare
       
        let baseFareAmount = (fare?.baseFare?.value ?? 0.0) + (fare?.customerAdditionalFareInfo?.transactionFeeEarned?.value ?? 0.0)
        let taxAmount = (fare?.totalTax?.value ?? 0.0)
        let totalAmount = (fare?.totalFare?.value ?? 0.0)
        
        let discountAmount = (fare?.customerAdditionalFareInfo?.discount?.value ?? 0.0)
       
        self.baseFareLabel.text = objUserSession.currency + baseFareAmount.toUSD()
        self.discountLabel.text = objUserSession.currency + discountAmount.toUSD()
        self.taxLabel.text = objUserSession.currency + taxAmount.toUSD()
        self.totalAmountLabel.text = objUserSession.currency + totalAmount.toUSD()
      
        if (objAirTicketManager?.selectedAirlinesDataModel?.fare?.fareType?.refundable) ?? false {
            self.fareTypeLabel.text = "Refundable"
        }else{
            self.fareTypeLabel.text = "Non-Refundable"
        }
        
        detailTableView.register(UINib(nibName: "AirlineTicketDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "AirlineTicketDetailsTableViewCell")
        detailTableView.register(UINib(nibName: "AirlineTicketTwoWayDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "AirlineTicketTwoWayDetailsTableViewCell")
        detailTableView.register(UINib(nibName: "PassengerListTableViewCell", bundle: nil), forCellReuseIdentifier: "PassengerListTableViewCell")
        
        detailTableView.separatorStyle = .none
        detailTableView.backgroundColor = .clear
        detailTableView.delegate = self
        detailTableView.dataSource = self
      
       // self.detailTableView.tableHeaderView = self.headerView
        self.detailTableView.tableFooterView = self.footerView
        
     
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        detailTableView.reloadData()
    }
    
    // MARK: -
    @IBAction func addPassengerButtonClick(_ sender: Any) {
       /*
        if (objAirTicketManager?.passangerArray.count ?? 0) == Int(objAirTicketManager?.request.passengersCount ?? "0") {
          
            self.showAlert(title: "", message: "You have already selected \((objAirTicketManager?.passangerArray.count ?? 0)) passenger. Remove before adding a new one.")
            
        }else{
            if let vc = AirticketPassengerListViewController.storyboardInstance() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        */
        if let vc = AirticketPassengerListViewController.storyboardInstance() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    // MARK: - Baggage & Fare Rules
    
//    @IBAction func baggageAndFareRulesButtonClick(_ sender: Any) {
//        if let fareVC = AirTicketFareRulesViewController.storyboardInstance() {
//          //  fareVC.offerId = objAirTicketManager.
//           // fareVC.conversationId = objAirTicketManager?.conversationId ?? ""
//            self.navigationController?.pushViewController(fareVC, animated: true)
//
//        }
//    }
//
    // MARK: - Pay Now Button Click
    @IBAction func payNowButtonClick(_ sender: Any) {
        
        if (objAirTicketManager?.passangerArray.count ?? 0) != Int(objAirTicketManager?.request.passengersCount ?? "0") {
            self.showAlert(title: "", message: "Please add passenger details")
            return
        }else if (self.fullNameView.text ?? "").isEmpty {
            self.showAlert(title: "", message: "Please enter full name")
            return
        }else if (self.phoneNumberView.text ?? "").isEmpty {
            self.showAlert(title: "", message: "Please enter phone number")
            return
        }else if (self.emailView.text ?? "").isEmpty {
            self.showAlert(title: "", message: "Please enter email")
            return
        }
        objAirTicketManager?.fullName = self.fullNameView.text!
        objAirTicketManager?.phoneNumber = self.phoneNumberView.text!
        objAirTicketManager?.email = self.emailView.text!
       
        self.view.endEditing(true)
        
        self.provisionalBookTicket()

    }
    
    // MARK: - provisionalBook Ticket
    func provisionalBookTicket ()
    {
        HPProgressHUD.show()
        AirTicketViewModel().provisionalBookTicket() { response, error in
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
                    print()
                    objAirTicketManager?.provisionConversationId = response?.data?.conversationId ?? ""
                  //  objAirTicketManager?.provisionAirlinesDataModel = response?.data?.data?.first //  ?? [AirportSearchDataModel]()
                   
//                    if airTicketArray.count != 0 {
//                        objAirTicketManager?.airportSearchDataModel = airTicketArray.first
//                    }
                    self.goToPaymentView()
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
     
    func goToPaymentView(){
//                if let pVc = AirticketPassengerDetailsViewController.storyboardInstance() {
//                    self.navigationController?.pushViewController(pVc, animated: true)
//                }
        if objAirTicketManager?.selectedAirlinesDataModel?.detail?.lcc == true {
        
        //if objAirTicketManager?.provisionAirlinesDataModel?.detail?.lcc == true {
            objAirTicketManager?.addOnsAmount = 0.0
            if let addOnVC = AirticketPassengerDetailsViewController.storyboardInstance() {
                self.navigationController?.pushViewController(addOnVC, animated: true)
            }
        
        }else{
            if let vc = PaymentReviewViewController.storyboardInstance() {
                vc.paymentPayNow = .AirTicket
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
extension AirTicketDetailViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return objAirTicketManager?.passangerArray.count ?? 0
        }
        return 1 //self.passangerArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 40
        }else if indexPath.section == 2 {
            return 70
        }
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
                    
                    let airline_code = (first.operatingAirline ?? "")
                  
                    cell.flightNameLabel.text = objAirTicketManager?.selectedAirlinesName
                    
                    let imgString = "https://res.cloudinary.com/dqhshqcqd/image/upload/v1710764763/Airline/\(airline_code).png"
                    cell.flightLogoImgView.sd_setImage(with: URL(string: imgString))
                   
                }
                return cell
            }  else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "AirlineTicketTwoWayDetailsTableViewCell") as! AirlineTicketTwoWayDetailsTableViewCell
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                
                let origin = objAirTicketManager?.request.origin?.city_name ?? ""
                let destination = objAirTicketManager?.request.destination?.city_name ?? ""
                
                cell.departureLabel.text = "Departure: \(origin)-\(destination)"
                cell.passengerlabel.text = "\(objAirTicketManager?.request.passengersCount ?? "") passengers - \(objAirTicketManager?.request.travel_class ?? "")"
                
                let model = objAirTicketManager?.selectedAirlinesDataModel!
                
                if let journey = model?.journey?.first, let first =  journey.flightSegments?.first, let last =  journey.flightSegments?.last {
                   
                    cell.j1_sourceAirportNameLabel.text = first.departureAirportCode ?? ""
                    let takeOfDate = first.departureDateTime?.toDate()
                    cell.j1_takeOffDateLabel.text = takeOfDate?.formate(format: "dd MMM yyyy")
                    cell.j1_takeOffTimeLabel.text = takeOfDate?.formate(format: "hh:mm a")
               
                    //cell.j1_sourceAirportCityLabel.text = origin
                    cell.j1_sourceTerminalLabel.text = "Terminal " + (first.departureTerminal ?? "")
                    
                   
                    cell.j1_destinationAirportLabel.text = last.arrivalAirportCode ?? ""
                    let arrivalDate = last.arrivalDateTime?.toDate()
                    cell.j1_reachDateLabel.text = arrivalDate?.formate(format: "dd MMM yyyy")
                    cell.j1_reachTimeLabel.text = arrivalDate?.formate(format: "hh:mm a")
                 //   cell.j1_destinationAirportCityLabel.text = destination
                    cell.j1_destinationTerminalLabel.text = "Terminal " + (last.arrivalTerminal ?? "")
                    
                    
                    if first.baggageAllowance?.checkedInBaggage?.count != 0 {
                        let tmp = first.baggageAllowance?.checkedInBaggage?.first
                        
                        let string = (tmp?.value ?? "") + " " + (tmp?.unit ?? "")
                        cell.checkInBaggageLabel.text = "Check-in : " + string
                    }else{
                        cell.checkInBaggageLabel.text = "Check-in : -"
                    }
                    cell.cabinLabel.text = "Cabin : " + (first.cabinClass ?? "")
                    
                    
                    cell.classLabel.text = first.cabinClass ?? ""
                    cell.j1_durationLabel.text = "Duration " + (journey.duration )
                 
                    
                    let airline_code = (first.operatingAirline ?? "")
                    cell.j1_flightNameLabel.text = objAirTicketManager?.selectedAirlinesName
                    
                    let imgString = "https://res.cloudinary.com/dqhshqcqd/image/upload/v1710764763/Airline/\(airline_code).png"
                    cell.j1_flightLogoImgView.sd_setImage(with: URL(string: imgString))
                     
                }
                if let journey = model?.journey?.last, let first =  journey.flightSegments?.first, let last =  journey.flightSegments?.last {
                   
                    cell.j2_sourceAirportNameLabel.text = first.departureAirportCode ?? ""
                    let takeOfDate = first.departureDateTime?.toDate()
                    cell.j2_takeOffDateLabel.text = takeOfDate?.formate(format: "dd MMM yyyy")
                    cell.j2_takeOffTimeLabel.text = takeOfDate?.formate(format: "hh:mm a")
               
                    //cell.j1_sourceAirportCityLabel.text = origin
                    cell.j2_sourceTerminalLabel.text = "Terminal " + (first.departureTerminal ?? "")
                    
                   
                    cell.j2_destinationAirportLabel.text = last.arrivalAirportCode ?? ""
                    let arrivalDate = last.arrivalDateTime?.toDate()
                    cell.j2_reachDateLabel.text = arrivalDate?.formate(format: "dd MMM yyyy")
                    cell.j2_reachTimeLabel.text = arrivalDate?.formate(format: "hh:mm a")
                 //   cell.j1_destinationAirportCityLabel.text = destination
                    cell.j2_destinationTerminalLabel.text = "Terminal " + (last.arrivalTerminal ?? "")
                    
                    
//
                    
                  //  cell.cabinLabel.text = "Cabin : " + (first.cabinClass ?? "")
                    cell.j2_durationLabel.text = "Duration " + (journey.duration )
                 
                    let airline_code = (first.operatingAirline ?? "")
                    cell.j2_flightNameLabel.text = objAirTicketManager?.selectedAirlinesName
                    
                    let imgString = "https://res.cloudinary.com/dqhshqcqd/image/upload/v1710764763/Airline/\(airline_code).png"
                    cell.j2_flightLogoImgView.sd_setImage(with: URL(string: imgString))
                     
                }
             
                return cell
            }
        }else if indexPath.section == 1 {
            let view = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
            view?.backgroundColor = .white
            
            let titleLabel = view?.viewWithTag(101) as! UILabel
            let countLabel = view?.viewWithTag(102) as! UILabel
            titleLabel.font = .bold(size: 18)
            
            titleLabel.text = "Passengers"
            countLabel.text = "\(objAirTicketManager?.passangerArray.count ?? 0)/\(Int(objAirTicketManager?.request.passengersCount ?? "0")!) added"
          
            view?.clipsToBounds = true
            return view!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PassengerListTableViewCell") as! PassengerListTableViewCell
            cell.backgroundColor = .white
            cell.selectionStyle = .none
            
            let guestModel = objAirTicketManager?.passangerArray[indexPath.row]
            
            cell.titleLabel.text = (guestModel?.first_name ?? "") + (guestModel?.last_name ?? "")
            return cell
        }
    }
}
