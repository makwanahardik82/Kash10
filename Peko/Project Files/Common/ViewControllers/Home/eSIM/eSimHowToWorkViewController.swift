//
//  eSimHowToWorkViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 17/04/24.
//

import UIKit

class eSimHowToWorkViewController: MainViewController {

    @IBOutlet weak var welcomeLabel: PekoLabel!
    @IBOutlet weak var howWorkLabel: PekoLabel!
    
    @IBOutlet weak var benegfits_1Label: PekoLabel!
    @IBOutlet weak var benegfits_2Label: PekoLabel!
    @IBOutlet weak var benegfits_3Label: PekoLabel!
    @IBOutlet weak var benegfits_4Label: PekoLabel!
    
    @IBOutlet weak var androidImgView: UIImageView!
    @IBOutlet weak var iphoneImgView: UIImageView!
    
    @IBOutlet weak var lineLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var androidButton: UIButton!
    @IBOutlet weak var iPhoneButton: UIButton!
    
    @IBOutlet weak var androidStackView: UIStackView!
    @IBOutlet weak var iphoneStackView: UIStackView!
   
    
    
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
    
    static func storyboardInstance() -> eSimHowToWorkViewController? {
        return AppStoryboards.eSim.instantiateViewController(identifier: "eSimHowToWorkViewController") as? eSimHowToWorkViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Travel eSIM")
        self.view.backgroundColor = .white
     
        
        let normalFont:UIFont = .regular(size: 14)
        let normalColor = UIColor(red: 103/255.0, green: 103/255.0, blue: 103/255.0, alpha: 1.0)
        let lineSpace = 7.0
        
        self.welcomeLabel.attributedText = NSMutableAttributedString().color(normalColor, "eSIM, short for embedded SIM, is a technology that allows you to activate a mobile plan without needing a physical SIM card. Instead of inserting a SIM card into your device, eSIM is built into the device itself, enabling you to connect to a mobile network seamlessly.", font: normalFont, lineSpace)
        
        self.howWorkLabel.attributedText = NSMutableAttributedString().color(normalColor, "eSIM works by utilizing a small, built-in chip within your device. This chip is programmable, allowing you to activate a mobile plan from a network provider that supports eSIM. Once activated, your device can connect to the cellular network as if it had a traditional SIM card inserted. Check what devices are eSIM compatible -", font: normalFont, lineSpace)
        
        
        self.benegfits_1Label.attributedText = NSMutableAttributedString().color(.black, "Enhanced Connectivity: ", font: .bold(size: 14), lineSpace).color(normalColor, "Seamlessly manage multiple phone numbers on a single device, catering to various personal and professional needs.", font: normalFont, lineSpace)
        self.benegfits_2Label.attributedText = NSMutableAttributedString().color(.black, "Effortless Mobility: ", font: .bold(size: 14), lineSpace).color(normalColor, "Bid farewell to the hassles of swapping SIM cards. With eSIM, stay connected seamlessly during travel, ensuring uninterrupted communication wherever you are.", font: normalFont, lineSpace)
        self.benegfits_3Label.attributedText = NSMutableAttributedString().color(.black, "Optimized Device Space: ", font: .bold(size: 14), lineSpace).color(normalColor, "By transitioning to eSIM, free up valuable space on your device for what matters most—be it your favourite apps, precious photos, or cherished memories.", font: normalFont, lineSpace)
        
        self.benegfits_4Label.attributedText = NSMutableAttributedString().color(normalColor, "Installing your new eSIM is a simple and speedy process. Upon completing your purchase, you'll receive an email from the eSIM provider containing an installation guide. The eSIM installation is entirely digital, requiring no physical intervention on your phone, and it's safe to retain your physical SIM card throughout the process.\n\nBoth iPhone and Android devices seamlessly integrate the installation of eSIM cards\n\n", font: normalFont, lineSpace).color(.black, "Please note: - ", font: .bold(size: 14), lineSpace).color(normalColor, "No computer is required for the purchase or installation, as both can be completed directly on your phone. - The installation is entirely digital, eliminating the need to wait for a physical SIM card. - The installation can be performed anywhere in the world, even after arriving at your destination.\n\nThroughout the installation, minor adjustments to your settings are needed. The following guide will assist you through each step, enabling you to get online within minutes.", font: normalFont, lineSpace)
        
        
        self.androidButtonClick(self.androidButton)
        
        
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
