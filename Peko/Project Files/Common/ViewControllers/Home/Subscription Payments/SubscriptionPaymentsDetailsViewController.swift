//
//  SubscriptionPaymentsDetailsViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 20/07/23.
//

import UIKit
import SDWebImage
import Alamofire
import SkeletonView

class SubscriptionPaymentsDetailsViewController: MainViewController {

    @IBOutlet weak var detailTableView: UITableView!
    
    var allPlanArray = [SubscriptionPlanModel]()
    var isShowSkeletonView = true
    var productModel:SubscriptionProductModel?
   
    static func storyboardInstance() -> SubscriptionPaymentsDetailsViewController? {
        return AppStoryboards.SubscriptionPayments.instantiateViewController(identifier: "SubscriptionPaymentsDetailsViewController") as? SubscriptionPaymentsDetailsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Subscriptions")
        self.view.backgroundColor = .white
        
        self.detailTableView.backgroundColor = .clear
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        self.detailTableView.separatorStyle = .none
        self.detailTableView.isUserInteractionEnabled = false
        self.getAllPlans()
    }
    
    // MARK: - Get All Plan
    func getAllPlans() {
        let product_id = objSubscriptionPaymentManager?.product?.id ?? 0
        
        SubscriptionPaymentsViewModel().getProductDetail(product_id: product_id) { response, error in
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                
            }else if let status = response??.status, status == true {
                self.productModel = response??.data?.data!
                self.detailTableView.isUserInteractionEnabled = true
              //  self.isShowSkeletonView = false
                self.detailTableView.reloadData()
            }else{
                var msg = ""
                if response??.message != nil {
                    msg = response??.message ?? ""
                }else if response??.error?.count != nil {
                    msg = response??.error ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
        SubscriptionPaymentsViewModel().getAllPlans(product_id: product_id) { response, error in
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                
            }else if let status = response??.status, status == true {
                DispatchQueue.main.async {
                    self.allPlanArray = response??.data?.planDatas ?? [SubscriptionPlanModel]()
                    self.detailTableView.isUserInteractionEnabled = true
                    self.isShowSkeletonView = false
                    self.detailTableView.reloadData()
                    //   self.paymentPlanCollectionView.reloadData()
                }
            }else{
                var msg = ""
                if response??.message != nil {
                    msg = response??.message ?? ""
                }else if response??.error?.count != nil {
                    msg = response??.error ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
    }
    
    // MARK: - Buy Now Button
    @IBAction func buyNowButtonClick(_ sender: Any) {
        
//        if objSubscriptionPaymentManager?.plan == nil {
//            self.showAlert(title: "", message: "Please select plan")
//        }else{
//            
//            if let vc = SubscriptionPaymentsDetailsViewController.storyboardInstance() {
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//            
//        }
    }
}

// MARK: - UITableViewCell
extension SubscriptionPaymentsDetailsViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            if self.isShowSkeletonView {
                return 2
            }
            return self.allPlanArray.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionPaymentsHeaderTableViewCell") as! SubscriptionPaymentsHeaderTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.nameLabel.numberOfLines = 2
            
            if self.productModel == nil {
                cell.showAnimatedGradientSkeleton()
            }else{
                cell.hideSkeleton()
                cell.nameLabel.text = self.productModel?.name ?? "" //objSubscriptionPaymentManager?.product?.name ?? ""
                cell.subTitleLabel.attributedText = NSMutableAttributedString().color(.black, (self.productModel?.description ?? ""),font: AppFonts.Medium.size(size: 14), 8)
                
                cell.detailsLabel.attributedText = NSMutableAttributedString().color(.grayTextColor, (self.productModel?.highlights ?? ""),font: AppFonts.Regular.size(size: 14), 4)
                
                if objShareManager.appTarget == .PekoUAE {
                    cell.logoImgView.sd_setImage(with: URL(string: (self.productModel?.productImage ?? "")), placeholderImage: nil)
                }else{
                    cell.logoImgView.sd_setImage(with: URL(string: (self.productModel?.image ?? "")), placeholderImage: nil)
                }
            }
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionPaymentsPlanTableViewCell") as! SubscriptionPaymentsPlanTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            if self.isShowSkeletonView {
                cell.conatinerView.showAnimatedGradientSkeleton()
            }else{
                cell.conatinerView.hideSkeleton()
                let planModel = self.allPlanArray[indexPath.row]
                let price = (planModel.price ?? "0.0").toDouble()
                cell.planNameLabel.text = planModel.name ?? ""
                cell.priceLabel.text = objUserSession.currency + price.withCommas()
          
                
                if objShareManager.appTarget == .PekoUAE {
                    cell.subscriptionTypeLabel.text = planModel.subscriptionType ?? ""
                    cell.subDetailLabel.text = (planModel.subscriptionType ?? "") + " at " + objUserSession.currency + price.withCommas()
                    cell.detailLabel.attributedText = NSMutableAttributedString().color(.grayTextColor, (planModel.includes ?? ""),font: AppFonts.Regular.size(size: 12), 4)
                }else{
                    cell.subscriptionTypeLabel.text = ""
                    cell.subDetailLabel.text = planModel.validity ?? ""
                    cell.detailLabel.attributedText = NSMutableAttributedString().color(.grayTextColor, (planModel.features ?? ""),font: AppFonts.Regular.size(size: 12), 4)
                }
                
                
                cell.offerContainerView.isHidden = true
            }
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        objSubscriptionPaymentManager?.plan = self.allPlanArray[indexPath.row]
       
        if let vc = SubscriptionPaymentsCompanyDetailViewController.storyboardInstance() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
}


// MARK: - UICollectionView Cell
class SubscriptionPaymentsPlanTableViewCell:UITableViewCell {
    @IBOutlet weak var planNameLabel: UILabel!
    
    @IBOutlet weak var offerContainerView: UIView!
    @IBOutlet weak var offerLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var subscriptionTypeLabel: UILabel!
    @IBOutlet weak var subDetailLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var conatinerView: UIView!
    
}

class SubscriptionPaymentsHeaderTableViewCell:UITableViewCell{
    
    @IBOutlet weak var logoImgView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var detailsLabel: UILabel!
}



