//
//  PayLaterViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 20/01/23.
//

import UIKit

class PayLaterViewController: MainViewController {

    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var moreOptionView: UIView!
    @IBOutlet weak var payCollectionView: UICollectionView!
    static func storyboardInstance() -> PayLaterViewController? {
        return AppStoryboards.Pay_Later.instantiateViewController(identifier: "PayLaterViewController") as? PayLaterViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        
        self.setTitle(title: "Pay Later")
       
        self.payCollectionView.delegate = self
        self.payCollectionView.dataSource = self
        self.payCollectionView.register(UINib(nibName: "PayLaterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PayLaterCollectionViewCell")
        
        self.moreOptionView.isHidden = true
        
        self.termsLabel.attributedText = NSMutableAttributedString().underline(.black, "I agree to the terms and conditions as set out by the user agreement", font: AppFonts.Regular.size(size: 9))

        // Do any additional setup after loading the view.
    }
    
    @IBAction func checkEligibilityButtonClick(_ sender: Any) {
        self.moreOptionView.isHidden = false
    }
    @IBAction func checkBoxButtonClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    // MARK: - Pay Now Button Click
    @IBAction func payNowButtonClick(_ sender: Any) {
        if let receiptVC = PaymentReceiptViewController.storyboardInstance() {
            receiptVC.isFrom = .PayLater
            self.navigationController?.pushViewController(receiptVC, animated: true)
        }
    }
    // MARK: - Cancel Button Click
    @IBAction func cancelButtonClick(_ sender: Any) {
        self.moreOptionView.isHidden = true
    }
    
    // MARK: -
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
}
extension PayLaterViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PayLaterCollectionViewCell", for: indexPath)
        cell.backgroundColor = .clear
        
        return cell
    }
}
