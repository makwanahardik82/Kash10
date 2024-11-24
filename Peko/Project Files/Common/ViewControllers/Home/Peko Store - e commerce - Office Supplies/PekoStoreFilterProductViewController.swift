//
//  PekoStoreFilterProductViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 15/02/24.
//

import UIKit

class PekoStoreFilterProductViewController: UIViewController {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var sortByCollectionView: UICollectionView!
    
    @IBOutlet weak var minPriceRangeTxt: UITextField!
    @IBOutlet weak var maxPriceRangeTxt: UITextField!
   
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
   
    var sortByArray = ["All", "Popular", "Recent", "Name",]
    var categoryArray = [PekoStoreCategoryModel]()
    
    
    var selectedCategoryID = ""
    var selectedCategoryName = ""
    var selectedSortBy = ""
    
    var minPriceRange = ""
    var maxPriceRange = ""
    
    var completionBlock:((_ categoryID:String, _ selectedSortBy:String, _ minPriceRange:String, _ maxPriceRange:String) -> Void)?
    
    
    static func storyboardInstance() -> PekoStoreFilterProductViewController? {
        return AppStoryboards.PekoStore.instantiateViewController(identifier: "PekoStoreFilterProductViewController") as? PekoStoreFilterProductViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = AppColors.blackThemeColor?.withAlphaComponent(0.8)
       
        self.sortByCollectionView.delegate = self
        self.sortByCollectionView.dataSource = self
        self.sortByCollectionView.backgroundColor = .clear
        
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.dataSource = self
        self.categoryCollectionView.backgroundColor = .clear

        self.minPriceRangeTxt.text = self.minPriceRange
        self.maxPriceRangeTxt.text = self.maxPriceRange
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.layoutIfNeeded()
        self.animation()
    }
    func animation(){
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .curveEaseIn, // curveEaseIn
                       animations: { () -> Void in
            
          //  self.superview?.layoutIfNeeded()
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: { (finished) -> Void in
            
        })
     
    }
    // MARK: - Close Button Click
    @IBAction func closeButtonClick(_ sender: Any) {
//        if self.completionBlock != nil {
//            self.completionBlock!(nil, false)
//        }
        self.dismiss(animated: false)
    }
   // MARK: - Filter Button Click
    @IBAction func applyFilterButtonClick(_ sender: Any) {
        if self.completionBlock != nil {
            self.completionBlock!(self.selectedCategoryID, self.selectedSortBy, self.minPriceRangeTxt.text!, self.maxPriceRangeTxt.text!)
        }
        self.dismiss(animated: false)
    }
}
extension PekoStoreFilterProductViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.sortByCollectionView == collectionView {
            return sortByArray.count
        }else if self.categoryCollectionView == collectionView {
            return categoryArray.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.sortByCollectionView == collectionView {
            let width = (screenWidth - 90) / 3
            return CGSize(width: width, height: 50)
        }else if self.categoryCollectionView == collectionView {
          //  return UICollectionViewFlowLayout.automaticSize
        }
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.sortByCollectionView == collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SortByCollectionViewCell", for: indexPath)
            
            let title = sortByArray[indexPath.row]
            let titleLabel = cell.viewWithTag(101) as! UILabel
            titleLabel.text = title
            
            let containerView = cell.viewWithTag(100)!
          
            if self.selectedSortBy == title {
                containerView.borderColor = .redButtonColor
                
            }else{
                containerView.borderColor = UIColor(named: "999999")
            }
            
            return cell
        }else if self.categoryCollectionView == collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath)
            
            let titleLabel = cell.viewWithTag(101) as! UILabel
            let containerView = cell.viewWithTag(100)!
          
            let categoryModel = categoryArray[indexPath.row]
          
            titleLabel.text = categoryModel.categoryName
            
            
            if "\(categoryModel.id ?? 0)" == self.selectedCategoryID {
                containerView.backgroundColor = UIColor(named: "F4F8FF")
                titleLabel.textColor = .black
            }else{
                containerView.backgroundColor = .clear
                titleLabel.textColor = .gray
            }
            
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.categoryCollectionView == collectionView {
            self.selectedCategoryID = "\(self.categoryArray[indexPath.row].id ?? 0)"
            collectionView.reloadData()
        }else{
            self.selectedSortBy = sortByArray[indexPath.row]
            collectionView.reloadData()
        }
    }
}
