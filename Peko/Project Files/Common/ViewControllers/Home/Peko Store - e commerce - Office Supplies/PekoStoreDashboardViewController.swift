//
//  PekoStoreDashboardViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 14/05/23.
//

import UIKit

class PekoStoreDashboardViewController: MainViewController {

   // @IBOutlet weak var searchTxt: UITextField!
 
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!

    @IBOutlet weak var segmentControl: PekoSegmentControl!
    var productArray = [PekoStoreProductModel]()
    var categoryArray = [PekoStoreCategoryModel]()
    
    var selectedCategoryID = ""
    var selectedCategoryName = ""
    var selectedSortBy = ""
    
    var minPriceRange = ""
    var maxPriceRange = ""
    
    var offset = 0
    var isPageRefreshing:Bool = false

    
    lazy var categoryCellWidth: Double = {
        return (screenWidth - 60.0) / 4.0
    }()
    
    lazy var productCellWidth: Double = {
        return (screenWidth - 24.0) / 2.0
    }()
    
    var cartProductIdArray = [Int]()
    
    var filterArray = ["Filter", "Popular", "Recent", "Name",]
    var isShowSkeletonView = true
 
   // var bottomRefreshControl:UIRefreshControl?
    
    static func storyboardInstance() -> PekoStoreDashboardViewController? {
        return AppStoryboards.PekoStore.instantiateViewController(identifier: "PekoStoreDashboardViewController") as? PekoStoreDashboardViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Office Supplies")
        self.view.backgroundColor = .white
        
        self.backNavigationView?.trolleyView.isHidden = false
        self.backNavigationView?.orderHistoryView.isHidden = false
        self.backNavigationView?.view.clipsToBounds = false
        
        self.backNavigationView?.historyButton.addTarget(self, action: #selector(orderHistory(button: )), for: .touchUpInside)
        
        self.productCollectionView.delegate = self
        self.productCollectionView.dataSource = self
        self.productCollectionView.backgroundColor = .clear
        
        self.filterCollectionView.delegate = self
        self.filterCollectionView.dataSource = self
        self.filterCollectionView.backgroundColor = .clear
  
         self.getProducts()
        self.getCategory()
        
    
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getCartDetails()
    }
    // MARK: - Order History
    @objc func orderHistory(button:UIButton){
        if let vc = PekoStoreHistoryListViewController.storyboardInstance() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    // MARK: - Get Cart Detail
    func getCartDetails(){
        PekoStoreTrolleyViewModel().getCartDetails() { response, error in
            if error != nil {
             //
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif
                objPekoStoreManager?.cartDetailModel = nil
                self.setTrolleyCount()
            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    objPekoStoreManager?.cartDetailModel = response?.data
                    self.setTrolleyCount()
                    
                    self.cartProductIdArray = (objPekoStoreManager?.cartDetailModel?.items?.compactMap({ $0.id }))!
                    print(self.categoryArray)
                    self.productCollectionView.reloadData()
                }
            }else{
                objPekoStoreManager?.cartDetailModel = nil
                self.setTrolleyCount()
            }
        }
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
    // MARK: - Category B
    @IBAction func filterButtonClick(_ sender: Any) {
        if let catVC = PickerListViewController.storyboardInstance() {
            catVC.array = self.categoryArray.compactMap({ $0.categoryName })
            catVC.selectedString = self.selectedCategoryName
            catVC.titleString = "Category"
            catVC.completionIndexBlock = { index in
                let cat = self.categoryArray[index]
                self.selectedCategoryID = "\(cat.id ?? 0)"
                self.selectedCategoryName = cat.categoryName ?? ""
                self.productArray.removeAll()
                self.getProducts()
            }
            let nav = UINavigationController(rootViewController: catVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    // MARK: - Get Products
    func getCategory(){
        PekoStoreDashboardViewModel().getCategories { response, error in
            if error != nil {
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    self.categoryArray = response?.data?.data ?? [PekoStoreCategoryModel]()
                   
//                    if self.categoryArray.count != 0 {
//                        let cat = self.categoryArray.first!
//                        self.selectedCategoryID = "\(cat.id ?? 0)"
//                        self.selectedCategoryName = cat.categoryName ?? ""
//                        self.productArray.removeAll()
//                        self.getProducts()
//                        
//                     //   self.productCollectionView.reloadData()
//                    }
                    
                    
                    
                    // self.c.reloadData()
                }
            }else{
//                var msg = ""
//                if response?.message != nil {
//                    msg = response?.message ?? ""
//                }else if response?.error?.count != nil {
//                    msg = response?.error ?? ""
//                }
//                self.showAlert(title: "", message: msg)
            }
        }
    }
    
//    // MARK: - Load More Product
//    @objc func loadMoreProduct() {
//        self.offset += 10
//        self.getProducts()
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.productCollectionView.contentOffset.y >= (self.productCollectionView.contentSize.height - self.productCollectionView.bounds.size.height)) {
            if !isPageRefreshing {
                isPageRefreshing = true
                self.offset += 10
                self.getProducts()
            }
        }
    }
    
    // MARK: - Get Products
    func getProducts(){
        PekoStoreDashboardViewModel().getProducts(category_id: self.selectedCategoryID, offset: self.offset, limit: 10, search: "", sortBy: self.selectedSortBy) { response, error in
            if error != nil {
               
#if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    self.productArray.append(contentsOf: response?.data?.rows ?? [PekoStoreProductModel]())
                    
                    if self.productArray.count < response?.data?.count ?? 0 {
                        self.isPageRefreshing = false
                    }else{
                        self.isPageRefreshing = true
                    }
                    self.isShowSkeletonView = false
                    self.productCollectionView.reloadData()
                 
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
 
}
extension PekoStoreDashboardViewController:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.productCollectionView {
            if isShowSkeletonView {
                return 10
            }
            return self.productArray.count
        }else if collectionView == filterCollectionView {
            return self.filterArray.count
            //return self.categoryArray.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        if collectionView == self.productCollectionView {
            return CGSize(width: self.productCellWidth, height: self.productCellWidth * 1.35)
        }else if collectionView == filterCollectionView {
            return CGSize(width: 100, height: 50) // UICollectionViewFlowLayout.automaticSize
        }
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.productCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
            
            if isShowSkeletonView {
                cell.view_1.showAnimatedGradientSkeleton()
            }else{
                cell.view_1.hideSkeleton()
                let product = self.productArray[indexPath.row]
                
                cell.nameLabel.text = product.name ?? ""
                cell.productImgView.sd_setImage(with: URL(string: (product.productImage ?? "")), placeholderImage: nil)
                
                let color = UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 1.0)
                
                cell.amountLabel.text = objUserSession.currency + "\(product.price ?? "")"
                
                let discount = product.discount?.toDouble()
                if discount == 0.0 {
                    // cell.discountLabel.isHidden = true
                    cell.actualAmountLabel.text = ""
                    cell.discountContainerView.isHidden = true
                }else{
                    //cell.discountLabel.isHidden = false
                    cell.discountContainerView.isHidden = false
                    
                    let discountString = discount?.decimalPoints(point: 0) ?? ""
                    
                    let discountType = product.discountType?.lowercased()
                    if discountType == "percentage" {
                        cell.discountLabel.text = "\(discountString)% OFF"
                    }else if discountType == "flat" {
                        cell.discountLabel.text = "\(discountString) FLAT"
                    }
                    
                    cell.actualAmountLabel.isHidden = false
                    cell.actualAmountLabel.attributedText = NSMutableAttributedString().strike(color, objUserSession.currency + " \(product.actualPrice ?? "")", font: AppFonts.SemiBold.size(size: 10), 5, .left)
                   
                }
                cell.reviewLabel.text = "0 Reviews"
                cell.ratingLabel.text = "0.0"
                
            }
            
            return cell
        }else if collectionView == filterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath)
            
            let titleLabel = cell.viewWithTag(101) as! UILabel
            titleLabel.text = self.filterArray[indexPath.row]
            
            let imgView = cell.viewWithTag(102) as! UIImageView
            let containerView = cell.viewWithTag(100) as! UIView
           
            if indexPath.row == 0 {
                imgView.isHidden = false
                containerView.borderWidth = 1
            }else{
                imgView.isHidden = true
                containerView.borderWidth = 0
            }
            
            // as! ProductCategoryCollectionViewCell
            /*
            let categoryModel = self.categoryArray[indexPath.row]
            
            cell.nameLabel.text = categoryModel.categoryName
            cell.categoryImgView.sd_setImage(with: URL(string: (categoryModel.categoryImage ?? "")), placeholderImage: nil)
           
            if self.selectedCategoryID == "\(categoryModel.id ?? 0)" {
                cell.borderImgView.image = UIImage(named: "icon_circle_red_border")
            }else{
                cell.borderImgView.image = UIImage(named: "icon_circle_gray_border")
            }
            */
           
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.productCollectionView {
            if let productVC = PekoStoreProductDetailViewController.storyboardInstance() {
                productVC.product = self.productArray[indexPath.row]
                self.navigationController?.pushViewController(productVC, animated: true)
            }
        }else if collectionView == filterCollectionView{
            if indexPath.row == 0 {
                
                if let filterVC = PekoStoreFilterProductViewController.storyboardInstance() {
                    
                    filterVC.categoryArray = self.categoryArray
                    filterVC.selectedCategoryID = selectedCategoryID
                    filterVC.selectedSortBy = selectedSortBy
                    filterVC.minPriceRange = minPriceRange
                    filterVC.maxPriceRange = maxPriceRange
                    
                    
                    filterVC.modalPresentationStyle = .overCurrentContext
                    filterVC.modalTransitionStyle = .crossDissolve
                    filterVC.completionBlock = { catID, sortBy, minPrice, maxPrice in
                        self.selectedCategoryID = catID
                        self.selectedSortBy = sortBy
                        self.minPriceRange = minPrice
                        self.maxPriceRange = maxPrice
                        
                        self.getProducts()
                    }
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                   appDelegate.window?.rootViewController!.present(filterVC, animated: false)
                }
                
            }else{
                selectedSortBy = self.filterArray[indexPath.row]
                self.getProducts()
            }
            
            /*
             let cat = self.categoryArray[indexPath.row]
            self.selectedCategoryID = "\(cat.id ?? 0)"
            self.selectedCategoryName = cat.categoryName ?? ""
            self.productArray.removeAll()
            self.getProducts()
             */
        }
    }
}

// MARK: - Order TableView
extension PekoStoreDashboardViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 154
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PekoStoreOrdersTableViewCell") as! PekoStoreOrdersTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        
        return cell
    }
}

/*
// MARK: - UITextFielad Delegate
extension PekoStoreDashboardViewController:UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == self.searchTxt {
            self.getProducts()
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.searchTxt {
          //  self.getProducts()
        }
        textField.resignFirstResponder()
        return true
    }
}
*/
// MARK: - Subscription
extension PekoStoreDashboardViewController:PekoSegmentControlDelegate{
    func selectedSegmentIndex(index: Int) {
       // self.scrollView.setContentOffset(CGPoint(x: Int(screenWidth) * (index - 1), y: 0), animated:true)
    }
}


// MARK: - ProductCollectionViewCell
class ProductCollectionViewCell:UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
  //  @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var actualAmountLabel: UILabel!
    
    @IBOutlet weak var productImgView: UIImageView!
    
    @IBOutlet weak var discountContainerView: UIView!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var view_1: UIView!
    @IBOutlet weak var reviewLabel: UILabel!
    //    
//    @IBOutlet weak var addToCartButton: UIButton!
//    
//    @IBOutlet weak var updateQtyStackView: UIStackView!
//    
//    @IBOutlet weak var qtyLabel: UILabel!
//    @IBOutlet weak var addQtyButton: UIButton!
//    @IBOutlet weak var minusQtyButton: UIButton!
//    
//    @IBOutlet weak var outOfStockLabel: UILabel!
}

class ProductCategoryCollectionViewCell:UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var borderImgView: UIImageView!
    
    @IBOutlet weak var categoryImgView: UIImageView!
    
    
}


class PeoductCollectionHeaderReusableView:UICollectionReusableView{
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
}
