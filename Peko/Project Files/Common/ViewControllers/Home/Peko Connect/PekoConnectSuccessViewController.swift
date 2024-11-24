//
//  PekoConnectSuccessViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 22/05/23.
//

import UIKit
import Lottie

class PekoConnectSuccessViewController: MainViewController {

    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var supportLabel: UILabel!
 
    var serviceProvider = ""
    static func storyboardInstance() -> PekoConnectSuccessViewController? {
        return AppStoryboards.PekoConnect.instantiateViewController(identifier: "PekoConnectSuccessViewController") as? PekoConnectSuccessViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Peko Connect")
        self.view.backgroundColor = .white
        
        
        animationView.loopMode = .loop
        animationView.play()
        
     //   self.titleLabel.attributedText = self.titleAttributeString
        self.detailLabel.attributedText = NSMutableAttributedString().color(.black, "Thank you for your enquiry, someone\nfrom the ", font: .regular(size: 14), 5, .center).color(.black, serviceProvider, font: .bold(size: 14), 5, .center).color(.black, " Express Group will reach out to you shortly", font: .regular(size: 14), 5, .center)
       
        self.supportLabel.attributedText = NSMutableAttributedString().color(AppColors.blackThemeColor!, "For any queries or support, please contact us at ", font: AppFonts.Regular.size(size: 12), 5, .center).color(AppColors.blackThemeColor!, "support@peko.one", font: AppFonts.SemiBold.size(size: 12), 5, .center)
     
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Support
    @IBAction func supportMailButtonClick(_ sender: Any) {
        self.supportMail()
    }
    // MARK - Back to Connect
    @IBAction func backToVCButtonClick(_ sender: Any) {
        let viewControllers = self.navigationController?.viewControllers
        
        self.navigationController?.popToViewController(viewControllers![1], animated: true)
        
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
