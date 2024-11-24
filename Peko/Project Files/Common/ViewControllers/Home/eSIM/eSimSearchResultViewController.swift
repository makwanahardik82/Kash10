//
//  eSimSearchResultViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 10/04/24.
//

import UIKit

class eSimSearchResultViewController: MainViewController {

    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var searchtxt: PekoTextField!
    
    var isSkeletonView = false

  //  var packageArray = [ESimPackageModel]()
    private var eSimOperator:ESimPackageOperatorModel?
    private var eSimPackageArray:[ESimPackageOperatorPakageModel]?
    
    private var searchPackageArray:[ESimPackageOperatorPakageModel]?

   
    static func storyboardInstance() -> eSimSearchResultViewController? {
        return AppStoryboards.eSim.instantiateViewController(identifier: "eSimSearchResultViewController") as? eSimSearchResultViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Travel eSIM")
        self.view.backgroundColor = .white
      
        eSimOperator = objeSIMManager?.selectedPackage?.operators?.first
        eSimPackageArray = eSimOperator?.packages
        self.searchPackageArray = eSimPackageArray
        
        self.searchCollectionView.delegate = self
        self.searchCollectionView.dataSource = self
        self.searchCollectionView.backgroundColor = .clear
        self.searchCollectionView.register(UINib(nibName: "eSimSearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "eSimSearchCollectionViewCell")
      //  self.searchCollectionView.isUserInteractionEnabled = false
        
        self.searchtxt.addTarget(self, action: #selector(textFieldDidChangeSelection), for: .editingChanged)
       
        // Do any additional setup after loading the view.
    }
    
    // MARK: -
    @objc func textFieldDidChangeSelection() {
        let searchText = self.searchtxt.text!.lowercased()
        
        let array1 = self.eSimPackageArray!.filter { ($0.title ?? "").lowercased().contains(searchText) }
            if array1.count == 0 {
                self.searchPackageArray = self.eSimPackageArray
            }else{
                self.searchPackageArray = array1
            }
       
        self.searchCollectionView.reloadData()
     
    }
    /*
    func getPakacge(){
       
        eSimViewModel().getPackages { response, error in
         
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response?.status, status == true {
                DispatchQueue.main.async {
                    
                    self.packageArray = response?.data?.packages ?? [ESimPackageModel]()
                    self.searchCollectionView.isUserInteractionEnabled = true
                    self.isSkeletonView = false
                    self.searchCollectionView.reloadData()
//                    self.deviceListArray = response?.data?.deviceList ?? [MobileDeviceModel]()
//                    self.deviceTableView.reloadData()
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
}
// MARK: - UiCollection
extension eSimSearchResultViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isSkeletonView {
            return 10
        }
        return self.eSimPackageArray?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (screenWidth - 45) / 2
        let height = (width * 0.58) + 100
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eSimSearchCollectionViewCell", for: indexPath) as! eSimSearchCollectionViewCell
        cell.backgroundColor = .clear
        
        if self.isSkeletonView {
            cell.view_1.showAnimatedGradientSkeleton()
        }else{
            cell.view_1.hideSkeleton()
            
            let package = self.eSimPackageArray![indexPath.row]
            
            cell.nameLabel.text = self.eSimOperator?.title ?? ""
            cell.logoImgView.sd_setImage(with: URL(string: self.eSimOperator?.image?.url ?? ""))
            
            let voice = package.voice?.value ?? "N/A"
            let day = package.day?.value ?? 0
            let data = package.data ?? ""
            var dayString = ""
            let coverage = objeSIMManager?.selectedPackage?.country_code ?? ""
            if day == 0 {
                dayString = "N/A"
            }else if day == 1 {
                dayString = "1 Day"
            }else {
                dayString = "\(day) Days"
            }
            
            let color = UIColor(red: 101/255.0, green: 101/255.0, blue: 101/255.0, alpha: 1.0)
            cell.voiceLabel.attributedText = NSMutableAttributedString().color(color, "Voice: ", font: .regular(size: 8)).color(.black, voice, font: .medium(size: 8))
            cell.validateLabel.attributedText = NSMutableAttributedString().color(color, "Validate: ", font: .regular(size: 8)).color(.black, dayString, font: .medium(size: 8))
         
            cell.coverageLabel.attributedText = NSMutableAttributedString().color(color, "Coverage: ", font: .regular(size: 8), 0, .right).color(.black, coverage, font: .medium(size: 8), 0, .right)
            cell.dateLabel.attributedText = NSMutableAttributedString().color(color, "Data: ", font: .regular(size: 8), 0, .right).color(.black, data, font: .medium(size: 8), 0, .right)
            
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var array = self.eSimPackageArray
        objeSIMManager?.selectedeSimPackage = array?.first //array?.remove(at: indexPath.row)
        objeSIMManager?.otherSimPackagesArray = array!
        if let detail = eSimResultDetailViewController.storyboardInstance() {
            self.navigationController?.pushViewController(detail, animated: true)
        }
    }
}
