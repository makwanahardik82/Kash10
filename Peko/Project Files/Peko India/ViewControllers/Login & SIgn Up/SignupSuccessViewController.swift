//
//  SignupSuccessViewController.swift
//  Peko India
//
//  Created by Hardik Makwana on 21/12/23.
//

import UIKit

class SignupSuccessViewController: MainViewController {

    @IBOutlet weak var animationView: PekoAnimationView!
    
    
    static func storyboardInstance() -> SignupSuccessViewController? {
        return AppStoryboards.SignUp.instantiateViewController(identifier: "SignupSuccessViewController") as? SignupSuccessViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = false
        self.setTitle(title: "")
        self.animationView.setGIF(gifName: "payment_success.gif", loopCount: 1)
       // self.animationView.delegate = self
      
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.animationView.startAnimation()
    }
    @IBAction func goBackToLoginButtonClick(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: false)
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
