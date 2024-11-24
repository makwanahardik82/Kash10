//
//  eSimOrderHistoryDetailsViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 17/04/24.
//

import UIKit

class eSimOrderHistoryDetailsViewController: MainViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: PekoLabel!
    @IBOutlet weak var dateLabel: PekoLabel!
   
    @IBOutlet weak var voiceLabel: UILabel!
    @IBOutlet weak var smsLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
  
    @IBOutlet weak var validateLabel: UILabel!
    @IBOutlet weak var coverageLabel: UILabel!
 
    
    @IBOutlet weak var usageDataLabel: PekoLabel!
    @IBOutlet weak var usageSMSLabel: PekoLabel!
    @IBOutlet weak var usageVoiceLabel: PekoLabel!
    
    
    @IBOutlet weak var networkLabel: PekoLabel!
    @IBOutlet weak var planTypeLabel: PekoLabel!
    @IBOutlet weak var iccidNumberLabel: PekoLabel!
    @IBOutlet weak var coverageDetailLabel: PekoLabel!
    @IBOutlet weak var kycLabel: PekoLabel!
    @IBOutlet weak var topUpLabel: PekoLabel!
   
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var androidImgView: UIImageView!
    @IBOutlet weak var iphoneImgView: UIImageView!
    
    @IBOutlet weak var lineLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var androidButton: UIButton!
    @IBOutlet weak var iPhoneButton: UIButton!
    
    @IBOutlet weak var androidStackView: UIStackView!
    @IBOutlet weak var iphoneStackView: UIStackView!
   
    @IBOutlet weak var qrImageView: UIImageView!
    
    
    @IBOutlet weak var android_1Label: PekoLabel!
    @IBOutlet weak var android_2Label: PekoLabel!
    @IBOutlet weak var android_3Label: PekoLabel!
    @IBOutlet weak var android_4Label: PekoLabel!
    @IBOutlet weak var android_5Label: PekoLabel!
    @IBOutlet weak var android_6Label: PekoLabel!
    @IBOutlet weak var android_7Label: PekoLabel!
    @IBOutlet weak var android_8Label: PekoLabel!
   
    @IBOutlet weak var iPhone_1Label: PekoLabel!
    @IBOutlet weak var iPhone_2Label: PekoLabel!
    @IBOutlet weak var iPhone_3Label: PekoLabel!
    @IBOutlet weak var iPhone_4Label: PekoLabel!
    @IBOutlet weak var iPhone_5Label: PekoLabel!
    @IBOutlet weak var iPhone_6Label: PekoLabel!
    @IBOutlet weak var iPhone_7Label: PekoLabel!
    
    
    
    var historyModel:eSimHistoryModel?
    
    static func storyboardInstance() -> eSimOrderHistoryDetailsViewController? {
        return AppStoryboards.eSim.instantiateViewController(identifier: "eSimOrderHistoryDetailsViewController") as? eSimOrderHistoryDetailsViewController
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Order History")
        self.view.backgroundColor = .white
     
        self.scrollView.isHidden = true
        self.getDetails()
        
        
        self.androidButtonClick(self.androidButton)
        
        let normalFont:UIFont = .regular(size: 14)
        let normalColor = UIColor(red: 103/255.0, green: 103/255.0, blue: 103/255.0, alpha: 1.0)
        let lineSpace = 7.0
     
        self.android_1Label.attributedText = NSMutableAttributedString().color(.black, "Check Device Compatibility: ", font: .bold(size: 14), lineSpace).color(normalColor, "Ensure that your Android device supports eSIM functionality and that your network carrier offers eSIM services.", font: normalFont, lineSpace)
        
        self.android_2Label.attributedText = NSMutableAttributedString().color(.black, "Access Settings: ", font: .bold(size: 14), lineSpace).color(normalColor, "Open the \"Settings\" app on your Android phone.", font: normalFont, lineSpace)
        
        self.android_3Label.attributedText = NSMutableAttributedString().color(.black, "Navigate to Network & Internet: ", font: .bold(size: 14), lineSpace).color(normalColor, "In the settings menu, locate and tap on \"Network & Internet.\"", font: normalFont, lineSpace)
        
        self.android_4Label.attributedText = NSMutableAttributedString().color(.black, "Select Mobile Network: ", font: .bold(size: 14), lineSpace).color(normalColor, "Within the \"Network & Internet\" settings, select \"Mobile Network.\"", font: normalFont, lineSpace)
        
        self.android_5Label.attributedText = NSMutableAttributedString().color(.black, "Access Advanced Settings: ", font: .bold(size: 14), lineSpace).color(normalColor, "Look for an option such as \"Advanced\" or \"Advanced Settings\" within the Mobile Network menu and tap on it.", font: normalFont, lineSpace)
        
        self.android_6Label.attributedText = NSMutableAttributedString().color(.black, "Add Carrier: ", font: .bold(size: 14), lineSpace).color(normalColor, "Choose \"Carrier\" and then select \"Add Carrier\" or \"Add new plan.\"", font: normalFont, lineSpace)
        
        self.android_7Label.attributedText = NSMutableAttributedString().color(.black, "Scan QR Code: ", font: .bold(size: 14), lineSpace).color(normalColor, "Follow the on-screen instructions to scan the provided QR code that corresponds to the eSIM activation from your network carrier in the UAE.", font: normalFont, lineSpace)
        
        self.android_8Label.attributedText = NSMutableAttributedString().color(.black, "Activation: ", font: .bold(size: 14), lineSpace).color(normalColor, "Complete the eSIM activation process as instructed by your network carrier. Please note that the specific steps may vary slightly depending on the Android device model and the network carrier", font: normalFont, lineSpace)
        
        
        self.iPhone_1Label.attributedText = NSMutableAttributedString().color(.black, "Find and purchase your eSIM from the selected provider.", font: .bold(size: 14), lineSpace)
       
        self.iPhone_2Label.attributedText = NSMutableAttributedString().color(.black, "Receive eSIM QR: ", font: .bold(size: 14), lineSpace).color(normalColor, "Once the purchase is completed, you will receive an email containing the eSIM QR code from the provider.", font: normalFont, lineSpace)
       
        self.iPhone_3Label.attributedText = NSMutableAttributedString().color(.black, "Access Settings: ", font: .bold(size: 14), lineSpace).color(normalColor, "Open the \"Settings\" app on your iPhone.", font: normalFont, lineSpace)
       
        self.iPhone_4Label.attributedText = NSMutableAttributedString().color(.black, "Select Cellular: ", font: .bold(size: 14), lineSpace).color(normalColor, "Tap on \"Cellular\" from the settings menu.", font: normalFont, lineSpace)
       
        self.iPhone_5Label.attributedText = NSMutableAttributedString().color(.black, "Add Cellular Plan: ", font: .bold(size: 14), lineSpace).color(normalColor, "Choose \"Add Cellular Plan\" and scan the provided eSIM QR code.", font: normalFont, lineSpace)
       
        self.iPhone_6Label.attributedText = NSMutableAttributedString().color(.black, "Follow On-Screen Instructions: ", font: .bold(size: 14), lineSpace).color(normalColor, "Follow the on-screen instructions to complete the eSIM installation process.", font: normalFont, lineSpace)
       
        self.iPhone_7Label.attributedText = NSMutableAttributedString().color(.black, "Activation: ", font: .bold(size: 14), lineSpace).color(normalColor, "Enter any required activation information and complete the setup as instructed by your eSIM provider.", font: normalFont, lineSpace)
    
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: -
    @IBAction func androidButtonClick(_ sender: Any) {
        self.lineLeadingConstraint.constant = 0
        self.androidStackView.isHidden = false
        self.iphoneStackView.isHidden = true
        
        self.androidImgView.alpha = 1.0
        self.iphoneImgView.alpha = 0.5
    }
    
    // MARK: -
    @IBAction func iphoneButtonClick(_ sender: Any) {
        self.lineLeadingConstraint.constant = (screenWidth - 40) / 2
        
        self.androidStackView.isHidden = true
        self.iphoneStackView.isHidden = false
        
        self.androidImgView.alpha = 0.5
        self.iphoneImgView.alpha = 1.0
    }
    
    
    func getDetails(){
        HPProgressHUD.show()
        eSimViewModel().getHistoryDetail(orderID: self.historyModel?.id ?? 0, iccid: self.historyModel?.simDetails?.first?.iccid ?? "") { response, error in
            HPProgressHUD.hide()
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                   
                    print(response?.data)
                    self.setData(model: (response?.data)!)
                    self.scrollView.isHidden = false
//                    self.packageArray = response?.data?.packages ?? [ESimPackageModel]()
//                    self.searchCollectionView.isUserInteractionEnabled = true
//                    self.isSkeletonView = false
//                    self.searchCollectionView.reloadData()
                    //                    self.deviceListArray = response?.data?.deviceList ?? [MobileDeviceModel]()
                    //                    self.deviceTableView.reloadData()
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
    
    // MARK: - Details
    
    func setData(model:eSimHistoryDetailModel){
     
        self.titleLabel.text = model.packageDetails?.operatorName ?? ""
        self.imgView.sd_setImage(with: URL(string: model.packageDetails?.operatorImage ?? ""))
        self.dateLabel.text = model.usage?.expired_at ?? ""
        
        let voice = "N/A"
        let day = model.packageDetails?.validity ?? 0
        let data = model.packageDetails?.data ?? "N/A"
        let sms = "N/A"
        
        var dayString = ""
        let coverage = "" //objeSIMManager?.selectedPackage?.title ?? ""
      
        if day == 0 {
            dayString = "N/A"
        }else if day == 1 {
            dayString = "1 Day"
        }else {
            dayString = "\(day) Days"
        }
        
        let color = UIColor(red: 101/255.0, green: 101/255.0, blue: 101/255.0, alpha: 1.0)
        self.voiceLabel.attributedText = NSMutableAttributedString().color(color, "Voice: ", font: .regular(size: 8)).color(.black, voice, font: .medium(size: 8))
        self.validateLabel.attributedText = NSMutableAttributedString().color(color, "Validate: ", font: .regular(size: 8)).color(.black, dayString, font: .medium(size: 8))
     
        self.dataLabel.attributedText = NSMutableAttributedString().color(color, "Data: ", font: .regular(size: 8)).color(.black, data, font: .medium(size: 8))
        self.smsLabel.attributedText = NSMutableAttributedString().color(color, "SMS: ", font: .regular(size: 8)).color(.black, sms, font: .medium(size: 8))
        self.coverageLabel.attributedText = NSMutableAttributedString().color(color, "Coverage: ", font: .regular(size: 8)).color(.black, coverage, font: .medium(size: 8))
        
        let grayCol = UIColor(named: "555555")
        
        let u_data = model.usage?.remaining ?? 0
        let u_SMS = model.usage?.remaining_text ?? 0
        let u_Voice = model.usage?.remaining_voice ?? 0
        
        self.usageDataLabel.attributedText = NSMutableAttributedString().color(.black, "\(u_data) MB", font: .bold(size: 20)).color(grayCol!, " left of \(model.usage?.total ?? 0) MB", font: .regular(size: 14))
        self.usageSMSLabel.attributedText = NSMutableAttributedString().color(.black, "\(u_SMS) SMS", font: .bold(size: 20)).color(grayCol!, " left of \(model.usage?.total_text ?? 0) SMS", font: .regular(size: 14))
        self.usageVoiceLabel.attributedText = NSMutableAttributedString().color(.black, "\(u_Voice) Min", font: .bold(size: 20)).color(grayCol!, " left of \(model.usage?.total_voice ?? 0) min", font: .regular(size: 14))
        
        
        // MARK: -
        
        self.networkLabel.text = model.packageDetails?.package ?? ""
        
        self.planTypeLabel.text = model.packageDetails?.esim_type ?? ""
        
        self.iccidNumberLabel.text = model.simDetails?.iccid ?? ""
        
        self.coverageDetailLabel.text = ""
        
        self.kycLabel.text = "The validity period starts when the eSIM connects to any supported network/s."
        self.topUpLabel.text = "Available"
        
        
        self.qrImageView.sd_setImage(with: URL(string: model.simDetails?.qrcode_url ?? ""))
    }
}
