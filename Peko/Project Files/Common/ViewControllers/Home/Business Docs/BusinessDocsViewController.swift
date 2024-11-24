//
//  BusinessDocsViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 10/10/23.
//

import UIKit

import SDWebImage

class BusinessDocsViewController: MainViewController {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
  
    var categoryArray = [BusinessDocsCategoryModel]()
    
    static func storyboardInstance() -> BusinessDocsViewController? {
        return AppStoryboards.BusinessDocs.instantiateViewController(identifier: "BusinessDocsViewController") as? BusinessDocsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Business Docs")
     
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.dataSource = self
        self.categoryCollectionView.backgroundColor = .clear
        
        self.getAllCategory()
        // Do any additional setup after loading the view.
    }
    
    // MARK: -
    func getAllCategory(){
        HPProgressHUD.show()
        BusinessDocsViewModel().getAllCategory { response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response??.status, status == true {
                DispatchQueue.main.async {
              //      print(response)
                    self.categoryArray = response??.data?.categoryDataWithCounts ?? [BusinessDocsCategoryModel]()
                    self.categoryCollectionView.reloadData()
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
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }
}
extension BusinessDocsViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = screenWidth // (screenWidth - 30) / 4
        return CGSize(width: width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCategoryCell", for: indexPath) 
        
        let imgView = cell.viewWithTag(101) as! UIImageView
        let titleLabel = cell.viewWithTag(102) as! UILabel
        let subTitleLabel = cell.viewWithTag(103) as! UILabel
       
        let dic = self.categoryArray[indexPath.row]
        
        titleLabel.text = dic.categoryName
        subTitleLabel.text = "\(dic.documentCount?.value ?? 0) Files"
        
        imgView.sd_setImage(with: URL(string: dic.categoryImage ?? ""))
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let docList = BusinessDocsListViewController.storyboardInstance() {
            docList.categoryModel = self.categoryArray[indexPath.row]
            self.navigationController?.pushViewController(docList, animated: true)
        }
    }
}
