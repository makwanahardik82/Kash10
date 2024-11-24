//
//  LogisticsSuccessViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 29/02/24.
//

import UIKit

class LogisticsSuccessViewController: MainViewController {

    @IBOutlet weak var shipmentTypeLabel: PekoLabel!
    @IBOutlet weak var senderAddressLabel: PekoLabel!
    @IBOutlet weak var receiverAddressLabel: PekoLabel!
    @IBOutlet weak var contentTypeLabel: PekoLabel!
    @IBOutlet weak var noOfPiecesLabel: PekoLabel!
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var trackingNumberLabel: PekoLabel!
    
    var trakingID:String = ""
    
    static func storyboardInstance() -> LogisticsSuccessViewController? {
        return AppStoryboards.Logistics.instantiateViewController(identifier: "LogisticsSuccessViewController") as? LogisticsSuccessViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Logistics")
        self.view.backgroundColor = .white
        
        self.trackingNumberLabel.attributedText = NSMutableAttributedString().color(.black, "Tracking Number: ").color(.redButtonColor, self.trakingID)
        
        self.shipmentTypeLabel.text = (objLogisticsManager?.shipmentDetailModel?.serviceType ?? "")
        
        self.senderAddressLabel.text = objLogisticsManager?.getFormatedAddress(address: (objLogisticsManager?.senderAddress)!)
        
        self.receiverAddressLabel.text = objLogisticsManager?.getFormatedAddress(address: (objLogisticsManager?.receiverAddress)!)
      
        self.contentTypeLabel.text = objLogisticsManager?.shipmentDetailModel?.content ?? ""
        self.noOfPiecesLabel.text = objLogisticsManager?.shipmentDetailModel?.noOfPieces ?? ""
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        self.containerView.roundCorners([.topLeft, .topRight], radius: 14)
    }

    @IBAction func trackOrderButtonClick(_ sender: Any) {
        if let trackVC = LogisticsTrackOrderViewController.storyboardInstance() {
            self.navigationController?.pushViewController(trackVC, animated: true)
        }
    }
    // MARK: -
    @IBAction func copyButtonClick(_ sender: Any) {
        UIPasteboard.general.string = self.trakingID
        self.showAlert(title: "", message: "Copied")
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
