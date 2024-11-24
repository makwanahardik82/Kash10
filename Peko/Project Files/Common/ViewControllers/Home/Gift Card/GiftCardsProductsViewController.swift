//
//  GiftCardsProductsViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 09/05/23.
//

import UIKit

import SkeletonView

class GiftCardsProductsViewController: MainViewController {

    @IBOutlet weak var searchTxt: PekoTextField!
    // @IBOutlet weak var scrollView: UIScrollView!
  //  @IBOutlet weak var segmentControl: PekoSegmentControl!
    
    @IBOutlet weak var giftCardCollectionView: UICollectionView!
//    @IBOutlet weak var giftCardView: UIView!
//    @IBOutlet weak var purchasedView: UIView!
//
//    @IBOutlet weak var giftTableView: UITableView!
  
    var giftProductUAEArray = [GiftCardProductModel]()
    var giftProductIndiaArray = [GiftCardProductIndiaModel]()
    
    var searchGiftProductUAEArray = [GiftCardProductModel]()
    var searchGiftProductIndiaArray = [GiftCardProductIndiaModel]()
    
    
    var offset = 1
    var isPageRefreshing:Bool = false
    var selectedCategoryID = 122
    
    var isSkeletonView = true
    
    static func storyboardInstance() -> GiftCardsProductsViewController? {
        return AppStoryboards.GiftCards.instantiateViewController(identifier: "GiftCardsProductsViewController") as? GiftCardsProductsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Gift Cards")
        
        self.backNavigationView?.orderHistoryView.isHidden = false
        self.backNavigationView?.historyButton.addTarget(self, action: #selector(orderHistoryButtonClick), for: .touchUpInside)
        
        self.giftCardCollectionView.delegate = self
        self.giftCardCollectionView.dataSource = self
        self.giftCardCollectionView.backgroundColor = .clear
        self.giftCardCollectionView.isUserInteractionEnabled = false
        
        
        
        objGiftCardManager = GiftCardManager.sharedInstance
        self.getProducts()
        
        self.searchTxt.addTarget(self, action: #selector(textFieldDidChangeSelection), for: .editingChanged)
      
        // Do any additional setup after loading the view.
    }
    // MARK: - Hist
    @objc func orderHistoryButtonClick(){
        if let historyVC = GiftCardHistoryViewController.storyboardInstance(){
            self.navigationController?.pushViewController(historyVC, animated: true)
        }
    }
    // MARK: - Filter Button Click
    @IBAction func filterButtonClick(_ sender: Any) {
        if let catVC = GiftCardCategoryViewController.storyboardInstance() {
           
            self.present(catVC, animated: true)
        }
    }
    // MARK: -
    @objc func textFieldDidChangeSelection() {
        let searchText = self.searchTxt.text!.lowercased()
        
        if objShareManager.appTarget == .PekoUAE {
            let array1 = self.giftProductUAEArray.filter { ($0.name ?? "").lowercased().contains(searchText) }
            if array1.count == 0 {
                self.searchGiftProductUAEArray = self.giftProductUAEArray
            }else{
                self.searchGiftProductUAEArray = array1
            }
        }else{
            let array1 = self.giftProductIndiaArray.filter { ($0.product_name).lowercased().contains(searchText) }
            if array1.count == 0 {
                self.searchGiftProductIndiaArray = self.giftProductIndiaArray
            }else{
                self.searchGiftProductIndiaArray = array1
            }
        }
        self.giftCardCollectionView.reloadData()
     
    }
    
    // MARK: -
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.giftCardCollectionView.contentOffset.y >= (self.giftCardCollectionView.contentSize.height - self.giftCardCollectionView.bounds.size.height)) {
            if !isPageRefreshing {
                isPageRefreshing = true
                self.offset += 1
                self.getProducts()
            }
        }
    }
    
    /*
    // MARK: - Get Products
    func getCategory(){
        HPProgressHUD.show()
        GiftCardsProductsViewModel().getProducts(category_id: 122, offset: 0, limit: 16) { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
             //       self.giftProductArray = response?.data?.rows ?? [GiftCardProductModel]()
                    self.giftTableView.reloadData()
               
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
    */
    // MARK: - Get Products
    func getProducts(){
        if objShareManager.appTarget == .PekoUAE {
            self.getProductsUAE()
        }else{
            self.getProductsIndia()
        }
    }
    
    func getProductsUAE(){
        GiftCardsProductsViewModel().getProducts(category_id: self.selectedCategoryID, offset: self.offset, limit: 10) { response, error in
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    if self.offset == 1 {
                        self.giftProductUAEArray.removeAll()
                    }
                    if response?.data != nil {
                        self.giftProductUAEArray.append(contentsOf: response?.data ?? [GiftCardProductModel]())
                        self.isPageRefreshing = false
                    }else{
                        self.isPageRefreshing = true
                    }
                    self.searchGiftProductUAEArray = self.giftProductUAEArray
//                    if self.giftProductUAEArray.count < response?.data?.count ?? 0 {
//                        self.isPageRefreshing = false
//                    }else{
//                        self.isPageRefreshing = true
//                    }
                    self.giftCardCollectionView.isUserInteractionEnabled = true
                    self.isSkeletonView = false
                    self.giftCardCollectionView.reloadData()
                }
            }else{
                if let code = response?.responseCode, code == "002"{
                    self.showAlertWithCompletion(title: "", message: "Your session has expired, please login again.") { action in
                        
                        DispatchQueue.main.async {
                            objUserSession.logout()
                            objShareManager.navigateToViewController = .LoginVC
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeViewController"), object: nil)
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
    }
    
    func getProductsIndia(){
        GiftCardsProductsViewModel().getProductsForIndia(category_id: self.selectedCategoryID, offset: self.offset, limit: 10) { response, error in
            if error != nil {
                #if DEBUG
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
                self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    
                    if response?.data?.rows != nil {
                        self.giftProductIndiaArray.append(contentsOf: response?.data?.rows ?? [GiftCardProductIndiaModel]())
                    }
                    self.searchGiftProductIndiaArray = self.giftProductIndiaArray
                    if self.giftProductIndiaArray.count < response?.data?.count ?? 0 {
                        self.isPageRefreshing = false
                    }else{
                        self.isPageRefreshing = true
                    }
                    self.giftCardCollectionView.isUserInteractionEnabled = true
                    self.isSkeletonView = false
                    self.giftCardCollectionView.reloadData()
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
    
    // MARK: -
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }
    
}
/*
extension GiftCardsProductsViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.giftProductArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GiftCardProductTableViewCell") as! GiftCardProductTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let produt = self.giftProductArray[indexPath.row]
        cell.titleLabel.text = produt.name
        cell.subTitleLabel.text = produt.description ?? ""
        
        if produt.image != nil {
            cell.imgView.sd_setImage(with: URL(string: (produt.image ?? "")), placeholderImage: nil)
        }else{
            cell.imgView.sd_setImage(with: URL(string: produt.images?.small ?? ""), placeholderImage: nil)
        }
        cell.buyNowButton.isUserInteractionEnabled = false
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        objGiftCardManager?.productModel = self.giftProductArray[indexPath.row]
        if let detail = GiftCardsProductsDetailViewController.storyboardInstance() {
           // detail.sku = self.giftProductArray[indexPath.row].sku ?? ""
            self.navigationController?.pushViewController(detail, animated: true)
        }
    }
}
*/
// MARK:
extension GiftCardsProductsViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isSkeletonView {
            return 10
        }
        return self.searchGiftProductUAEArray.count

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (screenWidth - 50) / 2
        return  CGSize(width: width, height: width * 0.88)
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftCardCollectionViewCell", for: indexPath) as! GiftCardCollectionViewCell
        cell.backgroundColor = .clear
        
        if self.isSkeletonView {
            cell.showAnimatedGradientSkeleton()
        }else{
            cell.hideSkeleton()
            cell.logoImgView.contentMode = .scaleAspectFit
            
            let produt = self.searchGiftProductUAEArray[indexPath.row]
            cell.titleLabel.text = produt.name
            cell.priceLabel.text = produt.description ?? ""
            
            if produt.image != nil {
                cell.logoImgView.sd_setImage(with: URL(string: (produt.image ?? "")), placeholderImage: UIImage(named: "gitf_card_placeholder"))
            }else{
                cell.logoImgView.sd_setImage(with: URL(string: produt.image ?? ""), placeholderImage: UIImage(named: "gitf_card_placeholder"))
            }
            
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.isSkeletonView {
         //   cell.showAnimatedGradientSkeleton()
        }else{
            
            DispatchQueue.main.async {
                objGiftCardManager?.productUAEModel = self.searchGiftProductUAEArray[indexPath.row]
                
                if let detail = GiftCardsProductsDetailViewController.storyboardInstance() {
                   // detail.sku = self.giftProductArray[indexPath.row].sku ?? ""
                    self.navigationController?.pushViewController(detail, animated: true)
                }
            }
            
        }
    }
}

//extension GiftCardsProductsViewController:PekoSegmentControlDelegate{
//    func selectedSegmentIndex(index: Int) {
//      //  self.scrollView.setContentOffset(CGPoint(x: Int(screenWidth) * (index - 1), y: 0), animated:true)
//    }
//}

class GiftCardCollectionViewCell:UICollectionViewCell {
    @IBOutlet weak var logoImgView: UIImageView!
    
    @IBOutlet weak var priceLabel: PekoLabel!
    @IBOutlet weak var titleLabel: PekoLabel!
}
