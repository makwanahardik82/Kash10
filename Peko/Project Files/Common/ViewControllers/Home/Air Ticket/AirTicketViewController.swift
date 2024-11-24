//
//  AirTicketViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 10/02/23.
//

import UIKit
import KMPlaceholderTextView

class AirTicketViewController: MainViewController {

    @IBOutlet weak var oneWayButton: UIButton!
    @IBOutlet weak var roundTripButton: UIButton!
    @IBOutlet weak var multiCityButton: UIButton!
    
    @IBOutlet weak var sourceAirportLabel: UILabel!
    @IBOutlet weak var destinationAirportLabel: UILabel!
 
    @IBOutlet weak var returnDateContainerView: UIView!
    
    @IBOutlet weak var departureDateView: PekoFloatingTextFieldView!
    @IBOutlet weak var returnDateView: PekoFloatingTextFieldView!
 
    @IBOutlet weak var classView: PekoFloatingTextFieldView!
    @IBOutlet weak var passengerView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var multiCityView: UIView!
    
    @IBOutlet weak var multiCitySourceAirportLabel: UILabel!
    @IBOutlet weak var multiCityDestinationAirportLabel: UILabel!
    @IBOutlet weak var multiCityDepartureDateView: PekoFloatingTextFieldView!
    
    var requestModel = AirTicketSearchRequestModel()
    // @IBOutlet weak var airTicketTableView: UITableView!
   
//    var seatArray = [AirTicketAncSeatMapModel]()
   // var response:[AirTicketAncSearchModel]?
    
    var travellerDictionary:[String:Int] = [
        "adult":1,
        "child":0,
        "infants":0
    ]
    
    static func storyboardInstance() -> AirTicketViewController? {
        return AppStoryboards.Air_Ticket.instantiateViewController(identifier: "AirTicketViewController") as? AirTicketViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.view.backgroundColor = .white
        self.setTitle(title: "Air Tickets")
      
        objAirTicketManager = AirTicketManager.sharedInstance
        
        self.oneWayButtonClick(self.oneWayButton)
 
        self.backNavigationView?.orderHistoryView.isHidden = false
        self.backNavigationView?.historyButton.addTarget(self, action: #selector(bookingHistoryButtonClick), for: .touchUpInside)
       
        self.departureDateView.text = Date().formate(format: "dd, MMMM, yyyy")
        self.requestModel.departure_date = Date().addDays(day: 1)

        self.classView.text = "Economy"
        self.setTravellers()
        
        let source_airport = AirportModel(iata_code: "EWR", airport_name: "New York International Airport", city_name: "New York", country: "United States", country_code: "US")
      
        let destination_airport = AirportModel(iata_code: "DXB", airport_name: "Dubai International", city_name: "Dubai", country: "United Arab Emirates", country_code: "AE")
        
        //AirportModel(iata_code: "RUH", airport_name: "King Khaled International", city_name: "Riyadh", country: "Saudi Arabia", country_code: "SA")
        
        self.setAirport(airport: source_airport, tag: 1)
        self.setAirport(airport: destination_airport, tag: 2)
        
        
        self.requestModel.travellerDictionary = self.travellerDictionary
        // Do any additional setup after loading the view.
    }
   // MARK: - Booking History Button
    @objc func bookingHistoryButtonClick(){
        if let historyVC = AirTicketHistoryViewController.storyboardInstance(){
            self.navigationController?.pushViewController(historyVC, animated: true)
        }
    }
    // MARK: - Select Airport
    @IBAction func selectAirportButtonClick(_ sender: UIButton) {
    
        if let searchVC = SearchAirportsViewController.storyboardInstance() {
            searchVC.completionBlock = { airport in
                self.setAirport(airport: airport, tag: sender.tag)
            }
            searchVC.modalPresentationStyle = .fullScreen
            self.present(searchVC, animated: true)
        }
    }
    func setAirport(airport:AirportModel, tag:Int)
    {
        if tag == 1 {
            let attr = NSMutableAttributedString().color(.black, "\(airport.iata_code ?? "")".uppercased() + "\n", font: AppFonts.Bold.size(size: 16), 0, .left).color(.black, airport.airport_name ?? "", font: AppFonts.Regular.size(size: 12), 0, .left)
            
            self.sourceAirportLabel.attributedText = attr
            self.requestModel.origin = airport
        }else if tag == 2 {
            let attr = NSMutableAttributedString().color(.black, "\(airport.iata_code ?? "")".uppercased() + "\n", font: AppFonts.Bold.size(size: 16), 0, .right).color(.black, airport.airport_name ?? "", font: AppFonts.Regular.size(size: 12), 0, .right)
            
            self.destinationAirportLabel.attributedText = attr
            self.requestModel.destination = airport
        }else if tag == 3 {
            let attr = NSMutableAttributedString().color(.black, "\(airport.iata_code ?? "")".uppercased() + "\n", font: AppFonts.Bold.size(size: 16), 0, .left).color(.black, airport.airport_name ?? "", font: AppFonts.Regular.size(size: 12), 0, .left)
            
            self.multiCitySourceAirportLabel.attributedText = attr
            self.requestModel.multi_origin = airport
        }else if tag == 4 {
            
            let attr = NSMutableAttributedString().color(.black, "\(airport.iata_code ?? "")".uppercased() + "\n", font: AppFonts.Bold.size(size: 16), 0, .right).color(.black, airport.airport_name ?? "", font: AppFonts.Regular.size(size: 12), 0, .right)
            
            self.multiCityDestinationAirportLabel.attributedText = attr
            self.requestModel.multi_destination = airport
        }
    }
    
    // MARK: - One Way
    @IBAction func oneWayButtonClick(_ sender: UIButton) {
        self.oneWayButton.backgroundColor = .redButtonColor
        self.oneWayButton.setTitleColor(.white, for: .normal)
        
        self.roundTripButton.backgroundColor = .clear
        self.roundTripButton.setTitleColor(.black, for: .normal)
        
        self.multiCityButton.backgroundColor = .clear
        self.multiCityButton.setTitleColor(.black, for: .normal)
        
        self.returnDateContainerView.isHidden = true
        self.multiCityView.isHidden = true
        
        objAirTicketManager?.airTicketWayType = .OneWay
    }
    
    // MARK: - Round Trip
    @IBAction func roundTripButtonClick(_ sender: UIButton) {
        self.oneWayButton.backgroundColor = .clear
        self.oneWayButton.setTitleColor(.black, for: .normal)
        
        self.roundTripButton.backgroundColor = .redButtonColor
        self.roundTripButton.setTitleColor(.white, for: .normal)
        
        self.multiCityButton.backgroundColor = .clear
        self.multiCityButton.setTitleColor(.black, for: .normal)
        
        self.returnDateContainerView.isHidden = false
        self.multiCityView.isHidden = true
    
        objAirTicketManager?.airTicketWayType = .RoundTrip
    }
    // MARK: - Multi City
    @IBAction func multiCityButtonClick(_ sender: UIButton) {
        self.oneWayButton.backgroundColor = .clear
        self.oneWayButton.setTitleColor(.black, for: .normal)
        
        self.roundTripButton.backgroundColor = .clear
        self.roundTripButton.setTitleColor(.black, for: .normal)
        
        self.multiCityButton.backgroundColor = .redButtonColor
        self.multiCityButton.setTitleColor(.white, for: .normal)
        
        self.returnDateContainerView.isHidden = true
        self.multiCityView.isHidden = false
     
        objAirTicketManager?.airTicketWayType = .MultiCity
    }
    // MARK: - Search Button Click
    @IBAction func searchButtonClick(_ sender: Any) {
       
        self.requestModel.passengersCount = self.passengerView.text!
        self.requestModel.travel_class = self.classView.text!
        
//        if objAirTicketManager?.airTicketWayType == .RoundTrip {
//            self.requestModel.multi_origin = self.requestModel.destination
//            self.requestModel.multi_destination = self.requestModel.origin
//        }
        let validationResult = AirTicketValidation().Validate(request: requestModel)

        if validationResult.success {
            DispatchQueue.main.async {
                objAirTicketManager?.request = self.requestModel
                if let searchListVC = AirTicketListViewController.storyboardInstance(){
                    self.navigationController?.pushViewController(searchListVC, animated: true)
                }
            }
        }else{
            self.showAlert(title: "", message: validationResult.error!)
        }
       
    }
   
    // MARK: -
    @IBAction func calendarButtonClick(_ sender: UIButton) {
   
        if let dateVC = AirTicketCalendarViewController.storyboardInstance(){
            dateVC.completionBlock = { date1 in
               
                let str = date1.formate(format: "dd MMMM, yyyy")

                if sender.tag == 1 { // Departure
                    self.departureDateView.text = str
                    self.requestModel.departure_date = date1
                }else if sender.tag == 2 { // Return
                    self.returnDateView.text = str
                    self.requestModel.return_date = date1
                }else if sender.tag == 3 { // Return
                    self.multiCityDepartureDateView.text = str
                    self.requestModel.return_date = date1
                }
            }
            dateVC.modalPresentationStyle = .fullScreen
            self.present(dateVC, animated: true)
        }
    }
    // MARK: - Passanger & Cabin
    @IBAction func selectPassangerAndCabinButtonClick(_ sender: Any) {
        if let pickerVC = AirTicketPassengerCabinViewController.storyboardInstance() {
            pickerVC.travellerDictionary = travellerDictionary
            pickerVC.selectedCabinClass = self.classView.text!
            pickerVC.completionBlock = { array, cabin in
                self.travellerDictionary = array
                self.classView.text = cabin
                self.requestModel.travellerDictionary = array
                self.setTravellers()
            }
            pickerVC.modalPresentationStyle = .fullScreen
            self.present(pickerVC, animated: true)
        }
    }
    func setTravellers(){
        let total_adult = self.travellerDictionary["adult"]!
        let total_child = self.travellerDictionary["child"]!
        let infants = self.travellerDictionary["infants"]!
        
        let total_guest = total_adult + total_child + infants
       
        self.passengerView.text = "\(total_guest)"
    }

}
