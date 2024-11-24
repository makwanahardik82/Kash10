//
//  AirTicketHistoryViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 19/03/24.
//

import UIKit

class AirTicketHistoryViewController: MainViewController {

    @IBOutlet weak var historyTableView: UITableView!
  
    var offset = 1
    var limit = 10
 
    var isPageRefreshing:Bool = false
   
    var isSkeletonView:Bool = true
 
    var historyArray = [AirTicketHistoryModel]()
    
    
    static func storyboardInstance() -> AirTicketHistoryViewController? {
        return AppStoryboards.Air_Ticket.instantiateViewController(identifier: "AirTicketHistoryViewController") as? AirTicketHistoryViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.view.backgroundColor = .white
        self.setTitle(title: "Manage Your Bookings")
      
        self.historyTableView.delegate = self
        self.historyTableView.dataSource = self
        self.historyTableView.register(UINib(nibName: "AirTicketHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "AirTicketHistoryTableViewCell")
        self.historyTableView.backgroundColor = .clear
        self.historyTableView.separatorStyle = .none
        // Do any additional setup after loading the view.
        
        self.historyTableView.isUserInteractionEnabled = false
        self.getHistory()
    }

    // MARK: - Air Ticket
    func getHistory(){
        AirTicketViewModel().getHisoryList(offset: self.offset, limit: self.limit) { response, error in
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
              
                    self.historyArray.append(contentsOf: response?.data?.bookings ?? [AirTicketHistoryModel]())
                    
                    if self.historyArray.count < response?.data?.count ?? 0 {
                        self.isPageRefreshing = false
                    }else{
                        self.isPageRefreshing = true
                    }
                    self.isSkeletonView = false
                    self.historyTableView.isUserInteractionEnabled = true
                    self.historyTableView.reloadData()
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
extension AirTicketHistoryViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSkeletonView {
            return 10
        }
        return self.historyArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AirTicketHistoryTableViewCell") as! AirTicketHistoryTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        if self.isSkeletonView {
            cell.view_1.showAnimatedGradientSkeleton()
            
        }else{
            cell.view_1.hideSkeleton()
            
            let historyModel = self.historyArray[indexPath.row]
            
            let C_555555 = UIColor(named: "555555")
            let C_363636 = UIColor(named: "363636")
            
            cell.confirmationLabel.attributedText = NSMutableAttributedString().color(C_363636!, "Confirmation Number: ", font: .regular(size: 12)).color(C_555555!, historyModel.orderResponseModel?.bookingReferenceId ?? "", font: .medium(size: 12))
            
            cell.bookingCodeLabel.attributedText = NSMutableAttributedString().color(C_363636!, "Airline Booking Code: ", font: .regular(size: 12)).color(C_555555!, historyModel.orderResponseModel?.supplierLocator ?? "", font: .medium(size: 12))
        
            cell.amountLabel.text = (historyModel.baseCurrency ?? "") + " " + (historyModel.baseAmount ?? "")
          
            if let journey = historyModel.orderResponseModel?.journey?.first, let first =  journey.flightSegments?.first, let last =  journey.flightSegments?.last {
               
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
            
            cell.supportButton.tag = indexPath.row
            cell.supportButton.addTarget(self, action: #selector(supportButtonClick(sender: )), for: .touchUpInside)
            
            cell.cancelationPolicyButton.tag = indexPath.row
            cell.cancelationPolicyButton.addTarget(self, action: #selector(cancelPolicyButtonClick(sender: )), for: .touchUpInside)
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = AirTicketHistoryDetailViewController.storyboardInstance() {
            detailVC.historyModel = self.historyArray[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    @objc func supportButtonClick(sender:UIButton){
        self.supportMail()
    }
    @objc func cancelPolicyButtonClick(sender:UIButton){
        if let cancelVC = AirTicketCancelpolicyViewController.storyboardInstance() {
            self.navigationController?.pushViewController(cancelVC, animated: true)
        }
    }
}
