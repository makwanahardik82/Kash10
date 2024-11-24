//
//  PekoStoreProductDetailViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 18/05/23.
//

import UIKit

import WDScrollableSegmentedControl
import SwiftyStarRatingView

class PekoStoreProductDetailViewController: MainViewController {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var detailTableView: UITableView!
   
    @IBOutlet var headerView: UIView!
    @IBOutlet var footerView: UIView!
    
    @IBOutlet weak var saleView: UIView!
    @IBOutlet weak var outOfStockView: UIView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var actualPriceLabel: UILabel!
    @IBOutlet weak var segmentControl: WDScrollableSegmentedControl!
    
  //  @IBOutlet weak var warrantyLabel: UILabel!
   
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var buyNowButton: UIButton!
    
    @IBOutlet weak var productImageCollectionView: UICollectionView!
  
    @IBOutlet weak var ratingDetailLabel: UILabel!
    @IBOutlet weak var starView: SwiftyStarRatingView!
    
    @IBOutlet weak var buttonsContainerView: UIView!
    
    var product:PekoStoreProductModel?
    var cart_product:PekoStoreCartModel?
    var photoArray = [PekoStoreProductPhotoModel]()
    
    static func storyboardInstance() -> PekoStoreProductDetailViewController? {
        return AppStoryboards.PekoStore.instantiateViewController(identifier: "PekoStoreProductDetailViewController") as? PekoStoreProductDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.setTitle(title: "Product Details")
        
        self.isBackNavigationBarView = true
        self.setTitle(title: "Office Supplies")
        self.backNavigationView?.trolleyView.isHidden = false
        // self.backNavigationView?.orderHistoryView.isHidden = false
        self.backNavigationView?.view.clipsToBounds = false
        
        self.navigationTitleView?.trolleyView.isHidden = false
        self.navigationTitleView?.view.clipsToBounds = false
        
        let height = (screenWidth * 0.79) + 250
        self.headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: height)
        
        self.detailTableView.backgroundColor = .clear
        self.detailTableView.separatorStyle = .none
        self.detailTableView.tableHeaderView = self.headerView
        self.detailTableView.tableFooterView = self.footerView
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        
        self.productImageCollectionView.dataSource = self
        self.productImageCollectionView.delegate = self
        
        self.productNameLabel.text = product?.name ?? ""
        self.categoryLabel.text = product?.category?.categoryName ?? ""
       
        self.priceLabel.text = objUserSession.currency + " " + (product?.price ?? "")
        if (product?.price ?? "") == (product?.actualPrice ?? ""){
            self.actualPriceLabel.text = ""
        }else{
            self.actualPriceLabel.attributedText = NSMutableAttributedString().strike(.grayTextColor, objUserSession.currency + " " + (product?.actualPrice ?? ""), font: AppFonts.Regular.size(size: 14))

        }
       
      
        self.starView.value = 0
        self.ratingDetailLabel.text = "0 review"
        
        self.segmentControl.delegate = self
        segmentControl.font = AppFonts.SemiBold.size(size: 18)
        segmentControl.buttonSelectedColor = .black
        segmentControl.buttonHighlightColor = .black
        segmentControl.buttonColor = .grayTextColor
        segmentControl.indicatorColor = .redButtonColor
        //segmentControl.normalIndicatorColor = UIColor(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1.0)
        segmentControl.indicatorHeight = 3
        segmentControl.buttons = ["Overview", "Features", "Reviews"]
        segmentControl.leftAlign = true
        
        self.getProductDetail()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setTrolleyCount()
        self.checkProductExistinCart()
    }
    // MARK: -
    func setTrolleyCount() {
        let cartCount = objPekoStoreManager?.cartDetailModel?.items?.count ?? 0
        if cartCount == 0 {
            self.backNavigationView?.trolleyItemCountLabel.isHidden = true
        }else{
            self.backNavigationView?.trolleyItemCountLabel.isHidden = false
            self.backNavigationView?.trolleyItemCountLabel.text = "\(cartCount)"
        }
    }

    // MARK: - Check Product in Cart
    func checkProductExistinCart(){
        
        if (self.product?.quantity ?? 0) > 0 {
            self.buttonsContainerView.isHidden = false
            self.saleView.isHidden = false
            self.outOfStockView.isHidden = true
            
            let cartProductIdArray:[Int] = (objPekoStoreManager?.cartDetailModel?.items?.compactMap({ $0.id })) ?? [Int]()
            let productID:Int = self.product?.id ?? 0
            self.setBuyButton(flag: cartProductIdArray.contains(productID))
            
        }else{
            self.saleView.isHidden = true
            self.outOfStockView.isHidden = false
            self.buttonsContainerView.isHidden = true
        }
    }
    func setBuyButton(flag:Bool) {
        if flag {
           
            self.addToCartButton.isUserInteractionEnabled = false
            self.addToCartButton.alpha = 0.5
            
            self.buyNowButton.isUserInteractionEnabled = true
            self.buyNowButton.alpha = 1.0
            
        }else{
            self.addToCartButton.isUserInteractionEnabled = true
            self.addToCartButton.alpha = 1.0
            
            self.buyNowButton.isUserInteractionEnabled = false
            self.buyNowButton.alpha = 0.5
        }
    }
    // MARK: - Get Product Detail
    func getProductDetail() {
        PekoStoreDashboardViewModel().getProductDetails(product_id: "\(self.product?.id ?? 0)") { response, error in
            if error != nil {
                
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    self.photoArray = response?.data?.photos ?? [PekoStoreProductPhotoModel]()
                    self.productImageCollectionView.reloadData()
                    /*
                  //  self.productArray.append(contentsOf: response?.data?.rows ?? [PekoStoreProductModel]())
                    self.isShowSkeletonView = false
                    self.productCollectionView.reloadData()
                    
                    if self.productArray.count < response?.data?.count ?? 0 {
                        self.isPageRefreshing = false
                    }else{
                        self.isPageRefreshing = true
                    }
                    */
                    //self.bottomRefreshControl?.endRefreshing()
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
    
    // MARK: - Add to cart
    @IBAction func addToCartButtonClick(_ sender: Any) {
        self.addProductToCart()
    }
    
    // MARK: - Buy now button
    @IBAction func buyNowButtonClick(_ sender: Any) {
        self.trolleyButtonClick()
        /*
        if self.buyNowButton.isSelected {
            
            let qty = Int(self.qtyLabel.text ?? "1") ?? 0
            if qty == self.cart_product?.productQuantity {
                self.trolleyButtonClick()
            }
//            else{
//                self.updateProductToCart()
//            }
            
        }else{
            self.addProductToCart()
        }
        */
    }
    // MARK: -
    func addProductToCart(){
        HPProgressHUD.show()
        PekoStoreDashboardViewModel().addProductsToCart(product_id: self.product?.id ?? 0, qty: 1) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                 DispatchQueue.main.async {
                    
                    self.showAlertWithCompletion(title: "Success", message: response?.message ?? "") { action in
                        self.trolleyButtonClick()
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
    /*
    // MARK: - Update QTY
    func updateProductToCart(isAdd:Bool){
        HPProgressHUD.show()
        PekoStoreDashboardViewModel().updateProductsQTY(product_id: self.product?.p_id ?? 0, qty:1, isAdd: isAdd) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.success, status == true {
                DispatchQueue.main.async {
                    
                    self.showAlertWithCompletion(title: "Success", message: response?.message?.first ?? "") { action in
                       self.trolleyButtonClick()
                    }
                }
            }else{
                var msg = ""
                if response?.message != nil {
                    msg = response?.message?.first ?? ""
                }else if response?.error?.count != nil {
                    msg = response?.error ?? ""
                }
                self.showAlert(title: "", message: msg)
            }
        }
    }
    */
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }

}
// MARK: - CollectionView Delegate & Datasouce

extension PekoStoreProductDetailViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.productImageCollectionView {
            return self.photoArray.count
        }
//        else if collectionView == self.offerCollectionView {
//            return 2
//        }else if collectionView == self.colorCollectionView {
//            return 2
//        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth - 95, height: self.productImageCollectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if collectionView == self.productImageCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCollectionViewCell", for: indexPath)
            cell.backgroundColor = .clear
            let imgView = cell.viewWithTag(201) as! UIImageView
            imgView.contentMode = .scaleAspectFill
            
            let photoModel = self.photoArray[indexPath.row]
            imgView.sd_setImage(with: URL(string: (photoModel.productImageUrl ?? "")), placeholderImage: nil)
            
            return cell
        } 
        return UICollectionViewCell()
        
    }
}
// MARK: - TableView
extension PekoStoreProductDetailViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.segmentControl.selectedIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryTableViewCell")
            cell?.backgroundColor = .clear
            cell?.selectionStyle = .none
            
            return cell!
        }else if self.segmentControl.selectedIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDescriptionTableViewCell")
            cell?.backgroundColor = .clear
            cell?.selectionStyle = .none
            
            let descLabel = cell?.viewWithTag(101) as! UILabel
            
            descLabel.text = (self.product?.description ?? "") + "\n\n" + (self.product?.description ?? "")
            
            return cell!
        }else if self.segmentControl.selectedIndex == 2 {
            
        }
        return UITableViewCell()
    }
}


//// MARK: -
//extension PekoStoreProductDetailViewController:PekoSegmentControlDelegate{
//    func selectedSegmentIndex(index: Int) {
//        
//        if index == 1 {
//            self.productDescriptionLabel.isHidden = false
//            self.productHighlightLabel.isHidden = true
//        }else{
//            self.productDescriptionLabel.isHidden = true
//            self.productHighlightLabel.isHidden = false
//        }
//        
//    }
//}
// MAEK: - WDScrollableSegmentedControlDelegate
extension PekoStoreProductDetailViewController:WDScrollableSegmentedControlDelegate{
    func didSelectButton(at index: Int) {
        print("\n\n SELECT INDX = ", index)
        self.detailTableView.reloadData()
        /*
        self.overviewView.isHidden = true
        self.featuresView.isHidden = true
        self.reviewsView.isHidden = true
        
        if index == 0 {
            self.overviewView.isHidden = true
        }else if index == 1 {
            self.featuresView.isHidden = false
        //    self.productDescriptionLabel.layoutSubviews()
            self.featuresView.layoutSubviews()
        }else if index == 2 {
            self.reviewsView.isHidden = false
        }
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()
        */
//        let category = self.planCategoriesArray[index]
//        
//        let filter = self.planArray.filter { $0.PlanName?.lowercased() == category.lowercased() }
//        print(filter)
//        self.filterPlanArray = filter
//        self.planTableView.reloadData()
    }
}
