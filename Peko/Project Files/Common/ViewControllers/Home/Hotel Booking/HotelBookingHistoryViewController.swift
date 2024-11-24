//
//  HotelBookingHistoryViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 15/03/24.
//

import UIKit

import SafariServices

class HotelBookingHistoryViewController: MainViewController {
    @IBOutlet weak var historyTableView: UITableView!
    
    var offset = 1
    var limit = 10
 
    var isPageRefreshing:Bool = false
   
    var isSkeletonView:Bool = true
 
    var historyArray = [HotelBookingHistoryModel]()
    
    static func storyboardInstance() -> HotelBookingHistoryViewController? {
        return AppStoryboards.HotelBooking.instantiateViewController(identifier: "HotelBookingHistoryViewController") as? HotelBookingHistoryViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Manage Your Bookings")
        self.view.backgroundColor = .white
     
        self.historyTableView.delegate = self
        self.historyTableView.dataSource = self
        self.historyTableView.separatorStyle = .none
        self.historyTableView.backgroundColor = .clear
        self.historyTableView.register(UINib(nibName: "HotelBookingHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HotelBookingHistoryTableViewCell")
        self.historyTableView.isUserInteractionEnabled = false
        self.getBookingHistory()
        // Do any additional setup after loading the view.
    }

    // MARK: - Get Hotel Booking
    func getBookingHistory(){
     //   HPProgressHUD.show()
        HotelBookingViewModel().getHotelBookingListing(page: offset, limit: limit)
        { response, error in
          //  HPProgressHUD.hide()
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
              
                    self.historyArray.append(contentsOf: response?.data?.bookings ?? [HotelBookingHistoryModel]())
                    
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
    
    // MARK: -
    // MARK: - Cancel Booking
    @objc func cancelBookingButtonClick(index:Int){
        let actionSheet = UIAlertController(title: "", message: "Are you sure you want to cancel your booking?", preferredStyle: .alert)
        
        actionSheet.addAction(UIAlertAction(title: "Yes, Cancel Booking", style: .destructive, handler: { action in
            self.cancelBooking(index: index)
        }))
        actionSheet.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { action in
            
        }))
        self.present(actionSheet, animated: true)
    }
    // MARK: -
    func cancelBooking(index:Int) {
        let bookingModel = self.historyArray[index]
        
        if bookingModel.orderResponseModel != nil {
            
            if let data = bookingModel.orderResponseModel?.data?.first {
                HPProgressHUD.show()
                
                let bookingReferenceId = data.bookingReferenceId ?? ""
                let conversationId = bookingModel.orderResponseModel?.meta?.conversationId ?? ""
                let selectedCorporateTxnId = bookingModel.corporateTxnId ?? ""
               
                
                HotelBookingViewModel().cancelBooking(bookingReferenceId: bookingReferenceId, conversationId: conversationId, corporateTxnId: selectedCorporateTxnId, response: { response, error in
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
                            print(response?.data)
                            self.showAlert(title: "", message: "Booking Cancelled")
                            self.getBookingHistory()
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
                })
            }
        }
    }
    // MARK: - Download PDF
    
    func downloadPdfFromServer(order_id:Int){
       
        HPProgressHUD.show()
        HotelBookingViewModel().getDownloadInvoice(o_id: order_id) { response, error in
           // HPProgressHUD.hide()
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
        let filePath = "\(documentsPath)/Hotel_Booking_\(order_id).pdf"
        
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
        let filePath = "\(documentsPath)/Hotel_Booking_\(order_id).pdf"
        if FileManager.default.fileExists(atPath: filePath) {
            let url = URL(fileURLWithPath: filePath)
            
            if let webVC = WebViewController.storyboardInstance() {
                webVC.pdfURL = url
                self.navigationController?.pushViewController(webVC, animated: true)
            }
//            let config = SFSafariViewController.Configuration()
//            config.entersReaderIfAvailable = true
//
//            let vc = SFSafariViewController(url: url, configuration: config)
//            present(vc, animated: true)
            
            
//            let controller = PDFViewController.createNew(with: document, title: "", actionButtonImage: image, actionStyle: .activitySheet)
//            navigationController?.pushViewController(controller, animated: true)
            
        }else{
            self.downloadPdfFromServer(order_id: order_id)
        }
    }
    
}
extension HotelBookingHistoryViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSkeletonView {
            return 10
        }
        return self.historyArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotelBookingHistoryTableViewCell") as! HotelBookingHistoryTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        if self.isSkeletonView {
            cell.view_1.showAnimatedGradientSkeleton()
        }else{
            cell.view_1.hideSkeleton()
            let bookingModel = self.historyArray[indexPath.row]
            cell.prNumberLabel.text = bookingModel.providerId ?? ""
            cell.confirmationNumberLabel.text = bookingModel.corporateTxnId ?? ""
          
            if bookingModel.orderResponseModel != nil {
               
                if let data = bookingModel.orderResponseModel?.data?.first {
                    
                    cell.hotelNameLabel.text = data.hotel?.name ?? ""
                 //   cell.confirmationNumberLabel.text = data.bookingReferenceId ?? ""
                    
                    let checkInDate = (data.hotel?.checkInDate ?? "").toDate(format: "yyyy-MM-dd")
                    let checkOutDate = (data.hotel?.checkOutDate ?? "").toDate(format: "yyyy-MM-dd")
                    
                    cell.checkInDateLabel.text = checkInDate.formate(format: "EEE MMM dd yyyy")
                    cell.checkInTimeLabel.text = bookingModel.orderResponseModel?.hotelContact?.checkInTime ?? ""
                  
                    cell.checkOutDateLabel.text = checkOutDate.formate(format: "EEE MMM dd yyyy")
                    cell.checkOutTimeLabel.text = bookingModel.orderResponseModel?.hotelContact?.checkOutTime ?? ""
                   
                    let noOfNight = checkInDate.diffInDays(toDate:checkOutDate)
                   
                    cell.noOfNightLabel.text = "\(noOfNight) Night"
                  
                    let passengers = data.passengers?.count ?? 0
                    let room = data.hotel?.rooms?.count ?? 0
                    
                    cell.guestDetailLabel.text = "\(passengers) Guest" + " | " + "\(room) Room"
                    
                    cell.hotelImgView.sd_setImage(with: URL(string: bookingModel.orderResponseModel?.hotelContact?.image ?? ""))
                    cell.roomDetailLabel.text = bookingModel.orderResponseModel?.hotelContact?.address ?? ""
                 
                }
            }else{
                cell.hotelImgView.image = nil
                cell.roomDetailLabel.text = ""
                cell.hotelNameLabel.text = ""
                cell.prNumberLabel.text = ""
                cell.confirmationNumberLabel.text = ""
             
                cell.checkInDateLabel.text = ""
                cell.checkInTimeLabel.text = ""
              
                cell.checkOutDateLabel.text = ""
                cell.checkOutTimeLabel.text = ""
               
                cell.noOfNightLabel.text = ""
               
                cell.guestDetailLabel.text = ""
                
            }
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Download Invoice", style: .default, handler: { action in
            let bookingModel = self.historyArray[indexPath.row]
          
            let order_id = bookingModel.id ?? 0
            self.viewPDF(order_id: order_id)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel Booking", style: .destructive, handler: { action in
            self.cancelBookingButtonClick(index: indexPath.row)
        }))
        actionSheet.addAction(UIAlertAction(title: "Support", style: .default, handler: { action in
            self.supportMail()
        }))
        actionSheet.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { action in
                
        }))
        
        self.present(actionSheet, animated: true)
        
    }
    
}
// MARK: -
extension HotelBookingHistoryViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.historyTableView.contentOffset.y >= (self.historyTableView.contentSize.height - self.historyTableView.bounds.size.height)) {
            if !isPageRefreshing {
                isPageRefreshing = true
                self.offset += 1
                self.getBookingHistory()
            }
        }
    }
}
