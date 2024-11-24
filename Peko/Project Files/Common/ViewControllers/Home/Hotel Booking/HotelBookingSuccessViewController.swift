//
//  HotelBookingSuccessViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 11/01/24.
//

import UIKit
import Lottie


class HotelBookingSuccessViewController: MainViewController {
   
    @IBOutlet weak var animationView: LottieAnimationView!
   // @IBOutlet weak var animationView: PekoAnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var supportLabel: UILabel!
    //   @IBOutlet weak var successMsgKLabel: UILabel!
    
    @IBOutlet weak var hotelImgView: UIImageView!
    @IBOutlet weak var hotelNameLabel: PekoLabel!
    @IBOutlet weak var roomDetailLabel: PekoLabel!
   
    @IBOutlet weak var guestDetailLabel: PekoLabel!
    
    @IBOutlet weak var checkInDateLabel: PekoLabel!
    @IBOutlet weak var checkInTimeLabel: PekoLabel!
    
    @IBOutlet weak var checkOutDateLabel: PekoLabel!
    @IBOutlet weak var checkOutTimeLabel: PekoLabel!
    
    @IBOutlet weak var confirmationNumberLabel: PekoLabel!
    @IBOutlet weak var prNumberLabel: PekoLabel!
    
    
    @IBOutlet weak var noOfNightLabel: PekoLabel!
    
    var orderResponse:HotelBookingOrderResponseModel?
    
    var order_id = 0
    
    static func storyboardInstance() -> HotelBookingSuccessViewController? {
        return AppStoryboards.HotelBooking.instantiateViewController(identifier: "HotelBookingSuccessViewController") as? HotelBookingSuccessViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isBackNavigationBarView = true
        self.setTitle(title: "Hotel Booking")
        self.view.backgroundColor = .white
      
        animationView.loopMode = .loop
        animationView.play()
        
//        self.titleLabel.attributedText = self.titleAttributeString
//        self.detailLabel.attributedText = self.detailAttributeString
//      
        let hotelInfo = objHotelBookingManager!.hotelListData?.propertyInfo
        let hotelName = hotelInfo?.hotelName ?? ""
      
        let str =  "Thank you for choosing \(hotelName) for your upcoming stay. We are delighted to confirm your reservation and provide you with the details of your booking. Please review the following information:"
        
        self.detailLabel.attributedText = NSMutableAttributedString().color(.black.withAlphaComponent(0.50), str, font: .regular(size: 15), 5, .center)
        
        self.supportLabel.attributedText = NSMutableAttributedString().color(AppColors.blackThemeColor!, "For any queries or support, please contact us at ", font: AppFonts.Regular.size(size: 12), 5, .center).color(AppColors.blackThemeColor!, "support@peko.one", font: AppFonts.SemiBold.size(size: 12), 5, .center)
        
        
        self.order_id = self.orderResponse?.orderId ?? 0
        
        self.confirmationNumberLabel.text = "\(self.orderResponse?.corporateTxnId?.value ?? 0)"
      
        let data = self.orderResponse?.data?.first
        
        self.prNumberLabel.text = data?.bookingReferenceId ?? ""
        
        self.hotelNameLabel.text = data?.hotel?.name ?? ""
       
        let checkInDate = (data?.hotel?.checkInDate ?? "").toDate(format: "yyyy-MM-dd")
        let checkOutDate = (data?.hotel?.checkOutDate ?? "").toDate(format: "yyyy-MM-dd")
        
        self.checkInDateLabel.text = checkInDate.formate(format: "EEE MMM dd yyyy")
        self.checkInTimeLabel.text = "" //bookingModel.orderResponseModel?.hotelContact?.checkInTime ?? ""
        
        self.checkOutDateLabel.text = checkOutDate.formate(format: "EEE MMM dd yyyy")
        self.checkOutTimeLabel.text = "" //bookingModel.orderResponseModel?.hotelContact?.checkOutTime ?? ""
        
        let noOfNight = checkInDate.diffInDays(toDate:checkOutDate)
        
        self.noOfNightLabel.text = "\(noOfNight) Night"
        
        let passengers = data?.passengers?.count ?? 0
        let room = data?.hotel?.rooms?.count ?? 0
        
        self.guestDetailLabel.text = "\(passengers) Guest" + " | " + "\(room) Room"
       
        let imageURL = objHotelBookingManager?.hotelListData?.propertyInfo?.imageUrl ?? ""

        self.hotelImgView.sd_setImage(with: URL(string: imageURL))
        self.roomDetailLabel.text = "" //bookingModel.orderResponseModel?.hotelContact?.address ?? ""
             
    }
    
    // MARK: - Options 
    @IBAction func optionsMoreButtonClick(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        /*
        actionSheet.addAction(UIAlertAction(title: "Download Invoice", style: .default, handler: { action in
            let bookingModel = self.historyArray[indexPath.row]
          
            let order_id = bookingModel.id ?? 0
            self.viewPDF(order_id: order_id)
        }))
        */
        actionSheet.addAction(UIAlertAction(title: "Cancel Booking", style: .destructive, handler: { action in
            self.cancelBookingButtonClick()
        }))
        actionSheet.addAction(UIAlertAction(title: "Support", style: .default, handler: { action in
            self.supportMail()
        }))
        actionSheet.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { action in
                
        }))
        
        self.present(actionSheet, animated: true)
    }
    
    
    // MARK: - Download Invoice
    @IBAction func downloadInvoiceButtonClick(_ sender: Any) {
        self.viewPDF()
    }
    
    
    // MARK: -
    // MARK: - Cancel Booking
    @objc func cancelBookingButtonClick(){
        let actionSheet = UIAlertController(title: "", message: "Are you sure you want to cancel your booking?", preferredStyle: .alert)
        
        actionSheet.addAction(UIAlertAction(title: "Yes, Cancel Booking", style: .destructive, handler: { action in
            self.cancelBooking()
        }))
        actionSheet.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { action in
            
        }))
        self.present(actionSheet, animated: true)
    }
    // MARK: -
    func cancelBooking() {
        
        /*
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
        */
    }
    // MARK: - Download PDF
    
    func downloadPdfFromServer(){
       
        HPProgressHUD.show()
        HotelBookingViewModel().getDownloadInvoice(o_id: self.order_id) { response, error in
            HPProgressHUD.hide()
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    self.createPDF(with: response?.data?.pdfFile?.data ?? [UInt8](), order_id: self.order_id)
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
                self.viewPDF()
            }
            
        }catch let failedError {
           // HPProgressHUD.hide()
            print("Failed to write the pdf data due to \(failedError.localizedDescription)")
            self.showAlert(title: "", message: "Failed to write the pdf data due to \(failedError.localizedDescription)")
        }
    }

    /// Verify your created PDF file
    func viewPDF() {
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
            self.downloadPdfFromServer()
        }
    }
    
    
    
    // MARK: - Send Mail Button
    @IBAction func sendMailButtonClick(_ sender: Any) {
        self.supportMail()
    }
    
}
/*
// MARK: -
extension HotelBookingSuccessViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.section == 0 {
            
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            cell.textLabel?.font = AppFonts.Regular.size(size: 12)
            cell.textLabel?.textAlignment = .center
            
            let str = "Thank you for choosing \(objHotelBookingManager?.hotelPreBookResponse?.hotel?.name ?? "") for your upcoming stay. We are delighted to confirm your reservation and provide you with the details of your booking. Please review the following information:"
            
            cell.textLabel?.attributedText = NSMutableAttributedString().color(AppColors.blackThemeColor!, str, font: AppFonts.Light.size(size: 12), 5, .center)
            
            cell.textLabel?.numberOfLines = 0
            return cell
            
           
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HotelBookedTableViewCell") as! HotelBookedTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            cell.cancelButton.isHidden = true
            
            if let image = objHotelBookingManager!.hotelData?.images?.first as? HotelBookingHotelImageModel{
                cell.photImgView.sd_setImage(with: URL(string: image.path ?? ""))
            }
            let noOfNight = objHotelBookingManager?.searchRequest?.checkInDate?.diffInDays(toDate: (objHotelBookingManager?.searchRequest?.checkOutDate)!)
            cell.noOfNightLabel.text = "\(noOfNight ?? 0) Night"
            
            cell.detailLabel.text = (objHotelBookingManager?.searchRequest?.noOfTravellers ?? "") + " | " + "\(objHotelBookingManager?.searchRequest?.travellersArray?.count ?? 0) Room"
            
            cell.checkInDateLabel.text = objHotelBookingManager?.searchRequest?.checkInDate?.formate(format: "EEE MMM dd yyyy")
            cell.checkInTimeLabel.text = ""
          
            cell.checkOutDateLabel.text = objHotelBookingManager?.searchRequest?.checkOutDate?.formate(format: "EEE MMM dd yyyy")
            cell.checkOutTimeLabel.text = ""
            
            cell.hotelnameLabel.text = objHotelBookingManager!.hotelData?.name ?? ""
            cell.addressLabel.text = objHotelBookingManager!.hotelData?.address ?? ""
            
            return cell
        }
        
        
        
       
    }
}
*/
