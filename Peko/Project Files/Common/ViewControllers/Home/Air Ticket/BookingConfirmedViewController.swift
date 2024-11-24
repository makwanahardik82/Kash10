//
//  BookingConfirmedViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 17/06/23.
//

import UIKit

class BookingConfirmedViewController: MainViewController {
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var supportLabel: UILabel!
    
    @IBOutlet weak var historyTableView: UITableView!
    
    //  var booking_reference_id = ""
    
    static func storyboardInstance() -> BookingConfirmedViewController? {
        return AppStoryboards.Air_Ticket.instantiateViewController(identifier: "BookingConfirmedViewController") as? BookingConfirmedViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.isBackNavigationBarView = false
        //   self.navigationItem.hidesBackButton = true
        self.setTitle(title: "Booking Confirmed!")
        
        DispatchQueue.main.async {
            
            let city_1 = objAirTicketManager?.request.origin?.city_name ?? ""
            let city_2 = objAirTicketManager?.request.destination?.city_name ?? ""
            
            
            self.descriptionLabel.attributedText = NSMutableAttributedString().color(.black, "Payment for your trip \(city_1) to \(city_2) was successful. Your booking is now confirmed. Please find attached your e-ticket for Peko ID \(objAirTicketManager?.bookResponseModel?.corporateTxnId?.value ?? 0). Your ticket will be send by the airline on your mail shortly.", font: AppFonts.Light.size(size: 15), 8, .center)
            
            self.supportLabel.attributedText = NSMutableAttributedString().color(.black, "For any queries or support,\nplease contact us at ", font: AppFonts.Regular.size(size: 15), 8, .center).color(.black, Constants.support_email, font: AppFonts.SemiBold.size(size: 15), 8, .center)
            
            self.historyTableView.delegate = self
            self.historyTableView.dataSource = self
            self.historyTableView.register(UINib(nibName: "AirTicketHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "AirTicketHistoryTableViewCell")
            self.historyTableView.backgroundColor = .clear
            self.historyTableView.separatorStyle = .none
            
        }
    }
    
    // MARK: -
    @IBAction func downloadButtonClick(_ sender: Any) {
        self.viewPDF(order_id: objAirTicketManager?.bookResponseModel?.orderId?.value ?? 0)
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
extension BookingConfirmedViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AirTicketHistoryTableViewCell") as! AirTicketHistoryTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        
        let historyModel = objAirTicketManager?.bookResponseModel?.data?.first
        
        let C_555555 = UIColor(named: "555555")
        let C_363636 = UIColor(named: "363636")
        
        cell.confirmationLabel.attributedText = NSMutableAttributedString().color(C_363636!, "Confirmation Number: ", font: .regular(size: 12)).color(C_555555!, historyModel?.bookingReferenceId ?? "", font: .medium(size: 12))
        
        cell.bookingCodeLabel.attributedText = NSMutableAttributedString().color(C_363636!, "Airline Booking Code: ", font: .regular(size: 12)).color(C_555555!, historyModel?.supplierLocator ?? "", font: .medium(size: 12))
        
        if let fare = historyModel?.fare {
            cell.amountLabel.text = objUserSession.currency + "\(fare.baseFare?.value ?? 0.0)"
        }
        if let journey = historyModel?.journey?.first, let first =  journey.flightSegments?.first, let last =  journey.flightSegments?.last {
            
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
