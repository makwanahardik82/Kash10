//
//  LogisticsConfirmShipmentViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 08/09/23.
//

import UIKit

import KMPlaceholderTextView

class LogisticsConfirmShipmentViewController: MainViewController {
    
    
    @IBOutlet weak var shipmentTypeLabel: PekoLabel!
    @IBOutlet weak var senderAddressLabel: PekoLabel!
    @IBOutlet weak var receiverAddressLabel: PekoLabel!
    @IBOutlet weak var dontentTypeLabel: PekoLabel!
    @IBOutlet weak var noOfPiecesLabel: PekoLabel!
    
    
    @IBOutlet weak var shipmentTermConditionLabel: UILabel!
    @IBOutlet weak var shieldTermConditionLabel: UILabel!
   
    @IBOutlet weak var shipmentCheckButton: UIButton!
    @IBOutlet weak var shieldTermCheckButton: UIButton!
    
    @IBOutlet weak var subTotalLabel: PekoLabel!
    @IBOutlet weak var shippingChargeLabel: PekoLabel!
    @IBOutlet weak var discountAmountLabel: PekoLabel!
    
    @IBOutlet weak var vatChargesLabel: PekoLabel!
    
    @IBOutlet weak var totalAmontLabel: PekoLabel!
    
    
    // @IBOutlet weak var deliveryChargeLabel: UILabel!
    
    
    

    static func storyboardInstance() -> LogisticsConfirmShipmentViewController? {
        return AppStoryboards.Logistics.instantiateViewController(identifier: "LogisticsConfirmShipmentViewController") as? LogisticsConfirmShipmentViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isBackNavigationBarView = true
        self.setTitle(title: "Logistics")
        self.view.backgroundColor = .white
        
        self.shipmentTypeLabel.text = (objLogisticsManager?.shipmentDetailModel?.serviceType ?? "")
        
        self.senderAddressLabel.text = objLogisticsManager?.getFormatedAddress(address: (objLogisticsManager?.senderAddress)!)
        
        self.receiverAddressLabel.text = objLogisticsManager?.getFormatedAddress(address: (objLogisticsManager?.receiverAddress)!)
        
        self.dontentTypeLabel.text = objLogisticsManager?.shipmentDetailModel?.content ?? ""
        self.noOfPiecesLabel.text = objLogisticsManager?.shipmentDetailModel?.noOfPieces ?? ""
        
        
        
        
        let currencyCode = objUserSession.currency
        
        self.subTotalLabel.text = currencyCode + " " + (objLogisticsManager?.calculateRateResponseModel?.TotalAmountBeforeTax ?? "0.0").toDouble().withCommas()
        self.shippingChargeLabel.text = currencyCode + " " + (0.0).withCommas()
        self.discountAmountLabel.text = currencyCode + " " + (0.0).withCommas()
        self.vatChargesLabel.text = currencyCode + " " + (objLogisticsManager?.calculateRateResponseModel?.TaxAmount?.withCommas())!
        
        self.totalAmontLabel.text = currencyCode + " " + (objLogisticsManager?.calculateRateResponseModel?.TotalAmount ?? 0.0).withCommas()
        
    }
    
    @IBAction func shipmentTermCheckButtonClick(_ sender: Any) {
        self.shipmentCheckButton.isSelected = !self.shipmentCheckButton.isSelected
    }
    // MARK: - Submit
    @IBAction func shieldTermCheckButtonClick(_ sender: Any) {
        self.shieldTermCheckButton.isSelected = !self.shieldTermCheckButton.isSelected
    }
    
    // MARK: - Submit
    @IBAction func confirmButtonClick(_ sender: Any) {
       
        /*
        let weekday = objLogisticsManager?.shipmentSchedulePickupDate?.formate(format: "EEEE").lowercased()
        
        if weekday == "sunday" || weekday == "friday" {
            self.showAlert(title: "", message: "Pickup is not available on Friday and Sunday")
            return
        }
        */
        if !self.shipmentCheckButton.isSelected {
            self.showAlert(title: "", message: "Please accept you prepared all the documents required to export this shipment from United Arab Emirates to United Arab Emirates")
            return
        }
        if !self.shieldTermCheckButton.isSelected {
            self.showAlert(title: "", message: "Please read and accept the Shipping Terms and Conditions and the Shield Terms and Conditions.")
            return
        }
       // objLogisticsManager?.shipmentRemarkComment = self.remarkTxt.text!
        
        if let reviewPaymentVC = PaymentReviewViewController.storyboardInstance() {
            reviewPaymentVC.paymentPayNow = .Logistics
            self.navigationController?.pushViewController(reviewPaymentVC, animated: true)
        }
         
    }
    
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//
    
}
