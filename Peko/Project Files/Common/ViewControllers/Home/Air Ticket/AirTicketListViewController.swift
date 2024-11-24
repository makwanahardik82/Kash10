//
//  AirTicketListViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 11/02/23.
//

import UIKit


class AirTicketListViewController: UIViewController {

    @IBOutlet weak var calendarCollectionView: UICollectionView!
 
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var dateContainerView: UIView!
    
    @IBOutlet weak var departureLabel: PekoLabel!
    @IBOutlet weak var passengersLabel: PekoLabel!
    
    
    var searchRequestModel:AirTicketSearchRequestModel?
    
    var bestAirTicketArray = [AirportSearchDataModel]()
    var searchAirTicketArray = [AirportSearchDataModel]()
   
  //  var airlinesArray = [AirlinesModel]()
    
    let subTitleColor = UIColor(red: 137/255.0, green: 137/255.0, blue: 137/255.0, alpha: 1.0)
    
    var selectedIndex = -1
    
    var isSkeletonView = true
    
    static func storyboardInstance() -> AirTicketListViewController? {
        return AppStoryboards.Air_Ticket.instantiateViewController(identifier: "AirTicketListViewController") as? AirTicketListViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.calendarCollectionView.delegate = self
        self.calendarCollectionView.dataSource = self
        self.calendarCollectionView.backgroundColor = .clear
       
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        self.listTableView.backgroundColor = .clear
        self.listTableView.tableFooterView = UIView()
        self.listTableView.register(UINib(nibName: "AirTicketListTableViewCell", bundle: nil), forCellReuseIdentifier: "AirTicketListTableViewCell")
        self.listTableView.register(UINib(nibName: "AirTicketTwoWayListTableViewCell", bundle: nil), forCellReuseIdentifier: "AirTicketTwoWayListTableViewCell")
        
        self.listTableView.separatorStyle = .none
        listTableView.isUserInteractionEnabled = false
        self.calendarCollectionView.isUserInteractionEnabled = false
       
        let origin = objAirTicketManager?.request.origin?.city_name ?? ""
        let destination = objAirTicketManager?.request.destination?.city_name ?? ""
        
        self.departureLabel.text = "Departure: \(origin)-\(destination)"
        self.passengersLabel.text = "\(objAirTicketManager?.request.passengersCount ?? "") passengers - \(objAirTicketManager?.request.travel_class ?? "")"
        
        self.searchFlight()
        
    }
    
    // MARK: -
    @IBAction func filterButtonClick(_ sender: Any) {
        if let filterVC = AirTicketFilterViewController.storyboardInstance() {
//            filterVC.completionBlock = { beneficiary in
//                self.beneficiaryArray.append(beneficiary)
//                self.billTableView.reloadData()
//            }
            filterVC.modalPresentationStyle = .overCurrentContext
            filterVC.modalTransitionStyle = .crossDissolve
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController!.present(filterVC, animated: false)
        }
    }
    @IBAction func sortButtonClick(_ sender: Any) {
        if let sortVC = AirTicketSortViewController.storyboardInstance() {
//            filterVC.completionBlock = { beneficiary in
//                self.beneficiaryArray.append(beneficiary)
//                self.billTableView.reloadData()
//            }
            sortVC.modalPresentationStyle = .overCurrentContext
            sortVC.modalTransitionStyle = .crossDissolve
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController!.present(sortVC, animated: false)
        }
    }
    
    
    // MARK: - Search
    func searchFlight(isShowHud:Bool = false){
        if isShowHud {
            HPProgressHUD.show()
        }
       
        AirTicketViewModel().searchTicket() { response, error in
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
                    objAirTicketManager?.conversationId = response?.data?.conversationId ?? ""
                    self.bestAirTicketArray = response?.data?.data ?? [AirportSearchDataModel]()
                    self.searchAirTicketArray = self.bestAirTicketArray
                    self.isSkeletonView = false
                    self.listTableView.isUserInteractionEnabled = true
                  //  self.sortButtonClick(self.sortByBestButton)
                    self.listTableView.reloadData()
                    
                    self.calendarCollectionView.isUserInteractionEnabled = true
                    self.calendarCollectionView.reloadData()
                   
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
    
    // MARK: - Sort Button Click
 //   @IBAction func sortButtonClick(_ sender: UIButton) {
        /*
        self.departureTitleLabel.attributedText = NSMutableAttributedString().color(.black, "DEPARTURE\n", font: AppFonts.Bold.size(size: 8), 1, .center).color(.black, "Earliest ", font: AppFonts.Regular.size(size: 6), 1, .center)
        
        self.durationTitleLabel.attributedText = NSMutableAttributedString().color(.black, "DURATION\n", font: AppFonts.Bold.size(size: 8), 1, .center).color(.black, "Fastest", font: AppFonts.Regular.size(size: 6), 1, .center)
        self.arrivalTitleLabel.attributedText = NSMutableAttributedString().color(.black, "ARRIVAL\n", font: AppFonts.Bold.size(size: 8), 1, .center).color(.black, "Today", font: AppFonts.Regular.size(size: 6), 1, .center)
        self.priceTitleLabel.attributedText = NSMutableAttributedString().color(.black, "PRICE\n", font: AppFonts.Bold.size(size: 8), 1, .center).color(.black, "Lowest", font: AppFonts.Regular.size(size: 6), 1, .center)
        self.bestTitleLabel.attributedText = NSMutableAttributedString().color(.black, "BEST\n", font: AppFonts.Bold.size(size: 8), 1, .center).color(.black, "Relevance ", font: AppFonts.Regular.size(size: 6), 1, .center)
     
        self.sortByDepartureButton.backgroundColor = .clear
        self.sortByDurationButton.backgroundColor = .clear
        self.sortByArrivalButton.backgroundColor = .clear
        self.sortByPriceButton.backgroundColor = .clear
        self.sortByBestButton.backgroundColor = .clear
        
        if sender == sortByBestButton { // Original
         
            self.bestTitleLabel.attributedText = NSMutableAttributedString().color(.white, "BEST\n", font: AppFonts.Bold.size(size: 8), 1, .center).color(.white, "Relevance ", font: AppFonts.Regular.size(size: 6), 1, .center)
            
            self.sortByBestButton.backgroundColor = AppColors.blackThemeColor
            self.searchAirTicketArray = self.bestAirTicketArray
            
        }else if sender == sortByPriceButton { // Price Sort
            self.priceTitleLabel.attributedText = NSMutableAttributedString().color(.white, "PRICE\n", font: AppFonts.Bold.size(size: 8), 1, .center).color(.white, "Lowest", font: AppFonts.Regular.size(size: 6), 1, .center)
            
            self.sortByPriceButton.backgroundColor = AppColors.blackThemeColor
            
            self.searchAirTicketArray = self.bestAirTicketArray.sorted(by: {(obj1, obj2)  -> Bool in
                return (obj1.fare?.totalFare?.value ?? 0.0) < (obj2.fare?.totalFare?.value ?? 0.0) // It sorted the values and return to the mySortedArray
              })
            //fare?.totalFare?.value ?? 0.0
        }else if sender == sortByArrivalButton { // Arrival Time
            self.arrivalTitleLabel.attributedText = NSMutableAttributedString().color(.white, "ARRIVAL\n", font: AppFonts.Bold.size(size: 8), 1, .center).color(.white, "Today", font: AppFonts.Regular.size(size: 6), 1, .center)
            
            self.sortByArrivalButton.backgroundColor = AppColors.blackThemeColor
           
            self.searchAirTicketArray = self.bestAirTicketArray.sorted(by: {(obj1, obj2)  -> Bool in
                 return (obj1.journey?.first?.flightSegments?.first?.arrivalDate ?? Date()) < (obj2.journey?.first?.flightSegments?.first?.arrivalDate ?? Date()) // It sorted the values and return to the mySortedArray
            })
            
        }else if sender == sortByDurationButton { // Duration sort
            self.durationTitleLabel.attributedText = NSMutableAttributedString().color(.white, "DURATION\n", font: AppFonts.Bold.size(size: 8), 1, .center).color(.white, "Fastest", font: AppFonts.Regular.size(size: 6), 1, .center)
            
            self.sortByDurationButton.backgroundColor = AppColors.blackThemeColor
            
            self.searchAirTicketArray = self.bestAirTicketArray.sorted(by: {(obj1, obj2)  -> Bool in
                return (obj1.durationInMinutes) < (obj2.durationInMinutes) // It sorted
            })
            
        }else if sender == sortByDepartureButton { // Departure Time
            self.departureTitleLabel.attributedText = NSMutableAttributedString().color(.white, "DEPARTURE\n", font: AppFonts.Bold.size(size: 8), 1, .center).color(.white, "Earliest ", font: AppFonts.Regular.size(size: 6), 1, .center)
            
            self.sortByDepartureButton.backgroundColor = AppColors.blackThemeColor
            
            self.searchAirTicketArray = self.bestAirTicketArray.sorted(by: {(obj1, obj2)  -> Bool in
                 return (obj1.journey?.first?.flightSegments?.first?.departureDate ?? Date()) < (obj2.journey?.first?.flightSegments?.first?.departureDate ?? Date()) // It sorted the values and return to the mySortedArray
            })
            
        }
       // self.dateContainerView.isHidden = false
        self.sortContainerView.isHidden = false
        self.listTableView.reloadData()
        */
  //  }
    
}

// MARK: - UiCollectionView
extension AirTicketListViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isSkeletonView {
            return 10
        }
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 85, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionCell", for: indexPath) as! DateCollectionCell
        cell.backgroundColor = .white
        
        if self.isSkeletonView {
            cell.view_1.showAnimatedGradientSkeleton()
        }else{
            cell.view_1.hideSkeleton()
            
            let date = Date().addDays(day: indexPath.row)
            let currentString = date?.formate(format: "EEE, dd MMM")
            
            let selectedString = objAirTicketManager?.request.departure_date?.formate(format: "EEE, dd MMM")
            
            cell.titleLabel.text = currentString //"Sat, 7 Feb"
          
            if currentString == selectedString {
                cell.view_1.borderWidth = 0
                cell.view_1.backgroundColor = UIColor(red: 236/255.0, green: 255/255.0, blue: 224/255.0, alpha: 1.0)// rgba(255, 123, 120, 1) rgba(236, 255, 224, 1)
                cell.titleLabel.textColor = UIColor(red: 23/255.0, green: 65/255.0, blue: 45/255.0, alpha: 1.0) // .white rgba(23, 65, 45, 1)
            }else{
                cell.view_1.borderWidth = 1
                cell.view_1.backgroundColor = .clear
                cell.titleLabel.textColor = UIColor(red: 107/255.0, green: 107/255.0, blue: 107/255.0, alpha: 1.0)
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isSkeletonView {
    
        }else{
            let date = Date().addDays(day: indexPath.row)
            objAirTicketManager?.request.departure_date = date
            self.searchFlight(isShowHud: true)
        }
    }
}

extension AirTicketListViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSkeletonView {
            return 10
        }
        return self.searchAirTicketArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if objAirTicketManager?.airTicketWayType == .OneWay {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AirTicketListTableViewCell") as! AirTicketListTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
         
            if self.isSkeletonView {
                cell.view_1.showAnimatedGradientSkeleton()
            }else{
                cell.view_1.hideSkeleton()
                let model = self.searchAirTicketArray[indexPath.row]
                
                if let journey = model.journey?.first, let first =  journey.flightSegments?.first, let last =  journey.flightSegments?.last {
                   
                    cell.sourceAirportNameLabel.text = first.departureAirportCode ?? ""
                    let takeOfDate = first.departureDateTime?.toDate()
                    cell.takeOffDateLabel.text = takeOfDate?.formate(format: "dd MMM yyyy")
                    cell.takeOffTimeLabel.text = takeOfDate?.formate(format: "hh:mm a")
                    
                    cell.destinationAirportLabel.text = last.arrivalAirportCode ?? ""
                    let arrivalDate = last.arrivalDateTime?.toDate()
                    cell.reachDateLabel.text = arrivalDate?.formate(format: "dd MMM yyyy")
                    cell.reachTimeLabel.text = arrivalDate?.formate(format: "hh:mm a")
                    cell.classLabel.text = first.cabinClass ?? ""
                    
                    cell.durationLabel.text = "Duration " + (journey.duration )
                    cell.numberOfStopLabel.text = journey.numberOfStop
                   
                    let airline_code = (first.operatingAirline ?? "")
                    let array = objAirTicketManager!.airlinesArray.filter { $0.airline_code?.value == airline_code }
                 
                    if array.count != 0, let dic = array.first{
                        cell.flightNameLabel.text = dic.airline_name ?? ""
                    }else{
                        cell.flightNameLabel.text = "-"
                    }
                    let imgString = "https://res.cloudinary.com/dqhshqcqd/image/upload/v1710764763/Airline/\(airline_code).png"
                    cell.flightLogoImgView.sd_setImage(with: URL(string: imgString))
                    
                }
                
#if DEBUG
                cell.amountLabel.text = objUserSession.currency + ((model.fare?.totalFare?.value ?? 0.0).toUSD())  + " => \(model.detail?.lcc ?? false)"
                
                #else
                cell.amountLabel.text = objUserSession.currency + ((model.fare?.totalFare?.value ?? 0.0).toUSD())
#endif
          
            }
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AirTicketTwoWayListTableViewCell") as! AirTicketTwoWayListTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
         
            if self.isSkeletonView {
                cell.view_1.showAnimatedGradientSkeleton()
            }else{
                cell.view_1.hideSkeleton()
                
                let model = self.searchAirTicketArray[indexPath.row]
                
                if let journey1 = model.journey?.first, let first =  journey1.flightSegments?.first, let last =  journey1.flightSegments?.last {
                   
                    cell.j1_sourceAirportNameLabel.text = first.departureAirportCode ?? ""
                    let takeOfDate = first.departureDateTime?.toDate()
                    cell.j1_takeOffDateLabel.text = takeOfDate?.formate(format: "dd MMM yyyy")
                    cell.j1_takeOffTimeLabel.text = takeOfDate?.formate(format: "hh:mm a")
                    
                    cell.j1_destinationAirportLabel.text = last.arrivalAirportCode ?? ""
                    let arrivalDate = last.arrivalDateTime?.toDate()
                    cell.j1_reachDateLabel.text = arrivalDate?.formate(format: "dd MMM yyyy")
                    cell.j1_reachTimeLabel.text = arrivalDate?.formate(format: "hh:mm a")
                    
                    cell.j1_durationLabel.text = "Duration " + (journey1.duration )
                    cell.j1_numberOfStopLabel.text = journey1.numberOfStop
                   
                    cell.classLabel.text = first.cabinClass ?? ""
                    
                    let airline_code = (first.operatingAirline ?? "")
                    let array = objAirTicketManager!.airlinesArray.filter { $0.airline_code?.value == airline_code }
                    
                    if array.count != 0, let dic = array.first{
                        cell.j1_flightNameLabel.text = dic.airline_name ?? ""
                    }else{
                        cell.j1_flightNameLabel.text = "-"
                    }
                    let imgString = "https://res.cloudinary.com/dqhshqcqd/image/upload/v1710764763/Airline/\(airline_code).png"
                    cell.j1_flightLogoImgView.sd_setImage(with: URL(string: imgString))
                }
                
                if let journey2 = model.journey?.last, let first =  journey2.flightSegments?.first, let last =  journey2.flightSegments?.last {
                   
                    cell.j2_sourceAirportNameLabel.text = first.departureAirportCode ?? ""
                    let takeOfDate = first.departureDateTime?.toDate()
                    cell.j2_takeOffDateLabel.text = takeOfDate?.formate(format: "dd MMM yyyy")
                    cell.j2_takeOffTimeLabel.text = takeOfDate?.formate(format: "hh:mm a")
                    
                    cell.j2_destinationAirportLabel.text = last.arrivalAirportCode ?? ""
                    let arrivalDate = last.arrivalDateTime?.toDate()
                    cell.j2_reachDateLabel.text = arrivalDate?.formate(format: "dd MMM yyyy")
                    cell.j2_reachTimeLabel.text = arrivalDate?.formate(format: "hh:mm a")
                    
                    cell.j2_durationLabel.text = "Duration " + (journey2.duration )
                    cell.j2_numberOfStopLabel.text = journey2.numberOfStop
                   
                    let airline_code = (first.operatingAirline ?? "")
                    let array = objAirTicketManager!.airlinesArray.filter { $0.airline_code?.value == airline_code }
                    
                    if array.count != 0, let dic = array.first{
                        cell.j2_flightNameLabel.text = dic.airline_name ?? ""
                    }else{
                        cell.j2_flightNameLabel.text = "-"
                    }
                    let imgString = "https://res.cloudinary.com/dqhshqcqd/image/upload/v1710764763/Airline/\(airline_code).png"
                    cell.j2_flightLogoImgView.sd_setImage(with: URL(string: imgString))
                }
                
                cell.amountLabel.text = objUserSession.currency + ((model.fare?.totalFare?.value ?? 0.0).withCommas())// ?? ""
                
            }
            
            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.searchAirTicketArray[indexPath.row]
        
        if let journey1 = model.journey?.first, let first =  journey1.flightSegments?.first {
            
            let airline_code = (first.operatingAirline ?? "")
            let array = objAirTicketManager!.airlinesArray.filter { $0.airline_code?.value == airline_code }
            
            if array.count != 0, let dic = array.first{
                objAirTicketManager?.selectedAirlinesName = dic.airline_name ?? ""
            }else{
                objAirTicketManager?.selectedAirlinesName = "-"
            }
           
        }
        
        if objAirTicketManager?.airTicketWayType != .OneWay {
            if let journey2 = model.journey?.last, let first =  journey2.flightSegments?.first {
                
                let airline_code = (first.operatingAirline ?? "")
                let array = objAirTicketManager!.airlinesArray.filter { $0.airline_code?.value == airline_code }
                
                if array.count != 0, let dic = array.first{
                    objAirTicketManager?.selectedReturnAirlinesName = dic.airline_name ?? ""
                }else{
                    objAirTicketManager?.selectedReturnAirlinesName = "-"
                }
               
            }
        }
        objAirTicketManager?.selectedAirlinesDataModel = model
        
        if let detailVC  = AirTicketDetailViewController.storyboardInstance() {
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    @objc func moreDetailButtonClick(sender:UIButton) {
        if sender.tag == self.selectedIndex {
            self.selectedIndex = -1
            sender.isSelected = false
        }else{
            self.selectedIndex = sender.tag
            sender.isSelected = true
        }
        let indexPath = IndexPath(row: sender.tag, section: 1)
        self.listTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}



// MARK: - Date CollectionView Cell

class DateCollectionCell:UICollectionViewCell{
    
    @IBOutlet weak var view_1: UIView!
    
    @IBOutlet weak var titleLabel: PekoLabel!
    
}

