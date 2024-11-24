//
//  SubscriptionPaymentsViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 20/07/23.
//

import UIKit
import Alamofire
//
import SDWebImage
import SkeletonView

class SubscriptionPaymentsViewController: MainViewController {

    @IBOutlet weak var segmentControl: PekoSegmentControl!
        

    @IBOutlet weak var searchTxt: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
  
    //@IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var buyCollectionView: UICollectionView!
    // @IBOutlet weak var buyTableView: UITableView!
    
    var productsArray = [SubscriptionProductModel]()
    var searchProductsArray = [SubscriptionProductModel]()
   
    var offset = 1
    var isPageRefreshing:Bool = false
    var isShowSkeletonView = true
    
    static func storyboardInstance() -> SubscriptionPaymentsViewController? {
        return AppStoryboards.SubscriptionPayments.instantiateViewController(identifier: "SubscriptionPaymentsViewController") as? SubscriptionPaymentsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Subscriptions")
        self.backNavigationView?.orderHistoryView.isHidden = false
        self.backNavigationView?.historyButton.addTarget(self, action: #selector(orderHistoryButtonClick), for: .touchUpInside)
//        self.buyTableView.delegate = self
//        self.buyTableView.dataSource = self
//        self.buyTableView.backgroundColor = .clear
//        self.buyTableView.separatorStyle = .none
//        self.buyTableView.register(UINib(nibName: "SubscriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "SubscriptionTableViewCell")
        // Do any additional setup after loading the view.
        
        self.buyCollectionView.isUserInteractionEnabled = false
        self.buyCollectionView.backgroundColor = .clear
        self.buyCollectionView.delegate = self
        self.buyCollectionView.dataSource = self
        self.buyCollectionView.register(UINib(nibName: "SubscriptionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SubscriptionCollectionViewCell")
        self.segmentControl.delegate = self
            
        self.getAllProducts()
        self.searchTxt.addTarget(self, action: #selector(textFieldDidChangeSelection), for: .editingChanged)
      
    }
    // MARK: - Hist
    @objc func orderHistoryButtonClick(){
        if let historyVC = SubscriptionHistoryViewController.storyboardInstance(){
            self.navigationController?.pushViewController(historyVC, animated: true)
        }
    }
    
    // MARK: -
    @objc func textFieldDidChangeSelection() {
        let searchText = self.searchTxt.text!.lowercased()
        
        let array1 = self.productsArray.filter { ($0.name ?? "").lowercased().contains(searchText) }
        if array1.count == 0 {
            self.searchProductsArray = productsArray
        }else{
            self.searchProductsArray = array1
        }
        self.buyCollectionView.reloadData()
    }
    
   // MARK: - Get All products
    func getAllProducts(){
        
        SubscriptionPaymentsViewModel().getAllProducts(offset: self.offset, limit: 10, search: "", sortBy: "") { response, error in
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response??.status, status == true {
                DispatchQueue.main.async {
              //      print(response)
                    self.buyCollectionView.isUserInteractionEnabled = true
                    self.isShowSkeletonView = false
                    self.productsArray.append(contentsOf: response??.data?.data ?? [SubscriptionProductModel]())
                    self.searchProductsArray = self.productsArray
                    self.buyCollectionView.reloadData()
                    
                    if self.searchProductsArray.count < response??.data?.recordsTotal ?? 0 {
                        self.isPageRefreshing = false
                    }else{
                        self.isPageRefreshing = true
                    }
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
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }
}

// MARK: -
extension SubscriptionPaymentsViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isShowSkeletonView {
            return 10
        }
        return self.searchProductsArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenWidth - 10) / 2
        return CGSize(width: width, height: width * 1.10)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionCollectionViewCell", for: indexPath) as! SubscriptionCollectionViewCell
        cell.backgroundColor = .clear
        
        if self.isShowSkeletonView {
            cell.containerView.showAnimatedGradientSkeleton()
        }else{
            cell.containerView.hideSkeleton()

            let productModel = self.searchProductsArray[indexPath.row]
            
            cell.titleLabel.text = productModel.name ?? ""
            
//            if objShareManager.appTarget == .PekoUAE {
//                cell.imgView.sd_setImage(with: URL(string: (productModel.productImage ?? "")), placeholderImage: nil)
//                cell.priceLabel.text = objUserSession.currency + (productModel.price?.value ?? "") // ?? ""
//               
//            }else{
                cell.imgView.sd_setImage(with: URL(string: (productModel.image ?? "")), placeholderImage: nil)
                cell.priceLabel.text = productModel.discount?.value ?? ""
                cell.priceLabel.textColor = AppColors.greenThemeColor
          //  }
            
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        objSubscriptionPaymentManager = SubscriptionPaymentManager.sharedInstance
        objSubscriptionPaymentManager?.product = self.searchProductsArray[indexPath.row]
        
        if let detailVC = SubscriptionPaymentsDetailsViewController.storyboardInstance() {
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
// MARK: - Subscription
extension SubscriptionPaymentsViewController:PekoSegmentControlDelegate{
    func selectedSegmentIndex(index: Int) {
        self.scrollView.setContentOffset(CGPoint(x: Int(screenWidth) * (index - 1), y: 0), animated:true)
    }
}
extension SubscriptionPaymentsViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.buyCollectionView.contentOffset.y >= (self.buyCollectionView.contentSize.height - self.buyCollectionView.bounds.size.height)) {
            if !isPageRefreshing {
                isPageRefreshing = true
                self.offset += 1
                self.getAllProducts()
            }
        }
    }
}
