//
//  CreateAccountSuccessViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 08/02/24.
//

import UIKit
import Lottie

class CreateAccountSuccessViewController: UIViewController {

  //  @IBOutlet weak var animationView: PekoAnimationView!
    @IBOutlet weak var animationView: LottieAnimationView!
    
    static func storyboardInstance() -> CreateAccountSuccessViewController? {
        return AppStoryboards.CreateAccount.instantiateViewController(identifier: "CreateAccountSuccessViewController") as? CreateAccountSuccessViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView.loopMode = .loop
        animationView.play()
       // self.animationView.setGIF(gifName: "payment_success.gif")
      
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goBackButtonClick(_ sender: Any) {
        objShareManager.navigateToViewController = .LoginVC
        self.navigationController?.popToRootViewController(animated: false)
    }

}
