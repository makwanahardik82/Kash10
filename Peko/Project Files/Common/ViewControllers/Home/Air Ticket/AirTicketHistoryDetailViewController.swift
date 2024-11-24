//
//  AirTicketHistoryDetailViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 20/03/24.
//

import UIKit

class AirTicketHistoryDetailViewController: MainViewController {

    @IBOutlet weak var historyTableView: UITableView!
  
    var historyModel:AirTicketHistoryModel?
    
    static func storyboardInstance() -> AirTicketHistoryDetailViewController? {
        return AppStoryboards.Air_Ticket.instantiateViewController(identifier: "AirTicketHistoryDetailViewController") as? AirTicketHistoryDetailViewController
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
    }
   
    // MARK: - Download Ticket
    @IBAction func downloadTicketButtonClick(_ sender: Any) {
        self.viewPDF(order_id: self.historyModel?.id ?? 0)
    }
    
    // MARK: - Cancel Ticket
    @IBAction func cancelTicketButtonClick(_ sender: Any) {
   
    }
    
    
    // MARK: - Download PDF
    
    func downloadPdfFromServer(order_id:Int){
       
        HPProgressHUD.show()
        AirTicketViewModel().getDownloadTicket(o_id: order_id) { response, error in
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    self.createPDF(with: response?.data?.pdfFile?.data ?? [UInt8](), order_id: order_id)
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
    
    /// This will creates a PDF file
    func createPDF(with byte: [UInt8], order_id:Int) {
        let data = Data(byte)
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = "\(documentsPath)/AirTicket_\(order_id).pdf"
        
        let url = URL(fileURLWithPath: filePath)
        do{
            try data.write(to: url, options: .atomic)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.viewPDF(order_id: order_id)
            }
            
        }catch let failedError {
            HPProgressHUD.hide()
            print("Failed to write the pdf data due to \(failedError.localizedDescription)")
            self.showAlert(title: "", message: "Failed to write the pdf data due to \(failedError.localizedDescription)")
        }
    }

    /// Verify your created PDF file
    func viewPDF(order_id:Int) {
        HPProgressHUD.hide()
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = "\(documentsPath)/AirTicket_\(order_id).pdf"
        if FileManager.default.fileExists(atPath: filePath) {
            let url = URL(fileURLWithPath: filePath)
            
            if let webVC = WebViewController.storyboardInstance() {
                webVC.pdfURL = url
                self.navigationController?.pushViewController(webVC, animated: true)
            }
        }else{
            self.downloadPdfFromServer(order_id: order_id)
        }
    }
    
}

// MARK: -
extension AirTicketHistoryDetailViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AirTicketHistoryTableViewCell") as! AirTicketHistoryTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let C_555555 = UIColor(named: "555555")
        let C_363636 = UIColor(named: "363636")
        
        cell.confirmationLabel.attributedText = NSMutableAttributedString().color(C_363636!, "Confirmation Number: ", font: .regular(size: 12)).color(C_555555!, historyModel?.orderResponseModel?.bookingReferenceId ?? "", font: .medium(size: 12))
        
        cell.bookingCodeLabel.attributedText = NSMutableAttributedString().color(C_363636!, "Airline Booking Code: ", font: .regular(size: 12)).color(C_555555!, historyModel?.orderResponseModel?.supplierLocator ?? "", font: .medium(size: 12))
        
        cell.amountLabel.text = (historyModel?.baseCurrency ?? "") + " " + (historyModel?.baseAmount ?? "")
      
        if let journey = historyModel?.orderResponseModel?.journey?.first, let first =  journey.flightSegments?.first, let last =  journey.flightSegments?.last {
           
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
       
        
        
        return cell
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
