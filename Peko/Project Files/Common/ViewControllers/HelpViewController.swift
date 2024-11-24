//
//  HelpViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 07/01/23.
//

import UIKit
import KMPlaceholderTextView
import MessageUI

class HelpViewController: MainViewController {

    @IBOutlet weak var detailLabel: PekoLabel!
    // @IBOutlet weak var bodyTxtView: KMPlaceholderTextView!
    
    static func storyboardInstance() -> HelpViewController? {
        return AppStoryboards.Help.instantiateViewController(identifier: "HelpViewController") as? HelpViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Help & Support")
        self.view.backgroundColor = .white
        
        
        detailLabel.attributedText = NSMutableAttributedString().color(.redButtonColor, "We are glad to have you here! ", font: .regular(size: 10), 5).color(.black, "Our dedicated support team is diligently working to assist you. Your feedback is valuable to us as it drives us forward. For further assistance or any queries, please don't hesitate to get in touch with us.", font: .regular(size: 10), 5)
            
            //.color(.black, "\n\nFor further assistance or any queries, please don't hesitate to get in touch with us.", font: .regular(size: 10), 5)
        // Do any additional setup after loading the view.
    }
    // MARK: -
    @IBAction func callButtonClick(_ sender: Any) {
        if let phoneCallURL = URL(string: "telprompt://866007356") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    // MARK: -
    @IBAction func mailButtonClick(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.navigationBar.tintColor = UIColor.white
            
            mailComposerVC.setToRecipients([Constants.support_email])
            mailComposerVC.setSubject("\(NSLocalizedString("Feedback for App", comment: ""))")
            
            let appVersion = "App Version : \(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "")"
            let osVersion = "OS Version : \(UIDevice.current.systemVersion)"
            let deviceModel = "Device Model : \(UIDevice.modelName)"
            
            let body = "\n\n\n\n\n\n\(appVersion)\n\(osVersion)\n\(deviceModel)"
            
            mailComposerVC.setMessageBody(body, isHTML: false)
            
            mailComposerVC.navigationBar.barTintColor = UIColor.white
            mailComposerVC.navigationBar.backgroundColor = UIColor.white
            
            mailComposerVC.navigationBar.tintColor = UIColor.black
            mailComposerVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
            
            self.present(mailComposerVC, animated: true, completion: { () in
                //  UIApplication.sharedApplicationtatusBarStyle = UIStatusBarStyle.LightContent
                
            })
            // self.present(mailComposerVC, animated: true, completion: nil)
            
        }
    }
    
    // MARK: - WHATS APP
    @IBAction func whatsAppButtonClick(_ sender: Any) {
        let urlWhats = "whatsapp://send?phone=\(Constants.WhatsAppHelpNumber)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }
                else {
                    print("Install Whatsapp")
                    
                  //  UIApplication.shared.open(URL(string: "https://api.whatsapp.com/send?phone=\(Constants.WhatsAppHelpNumber)")!, options: [:], completionHandler: nil)
                // &text=Invitation
                }
            }
        }
    }
    
    // MARK: - Raise Ticket
    @IBAction func raiseTicketButtonClick(_ sender: Any) {
        if let raiseVC = RaiseTicketViewController.storyboardInstance() {
            self.navigationController?.pushViewController(raiseVC, animated: true)
        }
    }
    // MARK: - FAQ
    @IBAction func faqButtonCLick(_ sender: Any) {
        if let faqVC = FAQViewController.storyboardInstance(){
            self.navigationController?.pushViewController(faqVC, animated: true)
        }
    }
    // MARK: - TCIKETS
    @IBAction func ticketButtonClick(_ sender: Any) {
        if let ticketVC = TicketsViewController.storyboardInstance(){
            self.navigationController?.pushViewController(ticketVC, animated: true)
        }
        
    }
    
    /*
    // MARK: - Submit Button CLick
    @IBAction func submitButtonClick(_ sender: Any) {
        
        if self.bodyTxtView.text.isEmpty {
            return
        }else{
            self.view.endEditing(true)
            HPProgressHUD.show()
            WSManager.postRequest(url: ApiEnd.ADD_SUPPORT, param: [:], resultType: ResponseModel<SupportModel>.self) { response, error  in
                
                HPProgressHUD.hide()
                if error != nil {
                    #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

                }else if let status = response?.status, status == true {
                    DispatchQueue.main.async {
                        self.showAlertWithCompletion(title: "Thank you!", message: "Your submission is received and we will contact you soon") { action in
                            self.navigationController?.popViewController(animated: true)
                        }
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
    */
    // MARK: - Set Statubar Style
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return objShareManager.appTarget == .PekoUAE ? .lightContent:.darkContent
//    }

}
// MARK: MFMailComposeViewControllerDelegate Method
//extension HelpViewController:MFMailComposeViewControllerDelegate {
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//}
