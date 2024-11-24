//
//  AboutViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 07/01/23.
//

import UIKit

class AboutViewController: MainViewController {

    @IBOutlet weak var aboutLabel: UILabel!
    
    
    static func storyboardInstance() -> AboutViewController? {
        return AppStoryboards.About.instantiateViewController(identifier: "AboutViewController") as? AboutViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        
        self.setTitle(title: "About Us")
        
        
        self.aboutLabel.attributedText = NSMutableAttributedString().color(.black, "Our goal goes beyond just helping people avail quality services on time\n\n",  font: AppFonts.Bold.size(size: 16), 8).color(AppColors.blackThemeColor!, "We have embarked on this ambitious journey with the greater purpose of transforming your life into a more seamless and gratifying one.", font: AppFonts.Regular.size(size: 15), 8)
    }
    
    // MARK: - Terms
    @IBAction func termsButtonClick(_ sender: Any) {
        self.openURL(urlString: Constants.terms_url)
    }
    // MARK: - Privacy
    @IBAction func privacyButtonClick(_ sender: Any) {
        self.openURL(urlString: Constants.privacy_url)
    }
    
}
