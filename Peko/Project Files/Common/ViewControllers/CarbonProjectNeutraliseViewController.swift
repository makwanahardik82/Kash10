//
//  CarbonProjectNeutraliseViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 23/03/24.
//

import UIKit

class CarbonProjectNeutraliseViewController: MainViewController {

    @IBOutlet weak var logoCollectionView: UICollectionView!
    @IBOutlet weak var locationLabel: PekoLabel!
    @IBOutlet weak var nameLabel: PekoLabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var detailTableView: UITableView!
    
    @IBOutlet weak var progressPecentageLabel: PekoLabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var customAmountView: PekoFloatingTextFieldView!
    
    @IBOutlet weak var equationLabel: PekoLabel!
    
    @IBOutlet weak var creditsLabel: PekoLabel!
    var selectedIndex = -1
    var responseData:CarbonProjectNeutralizeResponseDataModel?
    
    static func storyboardInstance() -> CarbonProjectNeutraliseViewController? {
        return AppStoryboards.Carbon.instantiateViewController(identifier: "CarbonProjectNeutraliseViewController") as? CarbonProjectNeutraliseViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.view.backgroundColor = .white
        self.setTitle(title: "Zero Carbon")
        
        let height = (screenWidth * 0.79) + 375
        self.headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: height)
        
        self.detailTableView.tableHeaderView = self.headerView
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        self.detailTableView.separatorStyle = .none
        
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
        self.imageCollectionView.backgroundColor = .clear
        
        self.logoCollectionView.delegate = self
        self.logoCollectionView.dataSource = self
        self.logoCollectionView.backgroundColor = .clear
        
        self.nameLabel.text = objCarbonManager?.selectedProjectModel?.name ?? ""
        self.locationLabel.text = (objCarbonManager?.selectedProjectModel?.city ?? "") + ", " + (objCarbonManager?.selectedProjectModel?.country ?? "")
        
        progressView.progress = 0.0
        progressPecentageLabel.text = "0%"
        
        self.customAmountView.delegate = self
        self.getNeutraliseDetails()
        // Do any additional setup after loading the view.
    }
    func setProgress(){
        
        if objCarbonManager?.co2Tons == 0.0 {
            self.progressView.progress = 0.0
            self.progressPecentageLabel.text = String(format: "%d%%", 0)
        }else{
            let value = (objCarbonManager?.co2Tons ?? 0.0) / (Double(self.responseData?.co2FootPrint ?? "0.0") ?? 0.0)
            self.progressView.progress = Float(value)
            self.progressPecentageLabel.text = String(format: "%d%%", Int(value * 100))
        }
       
    }
    // MARK: -
    @IBAction func neutraliseButtonClick(_ sender: Any) {
        
        if objCarbonManager?.co2AmountInAED == 0.0 {
            self.showAlert(title: "", message: "Please enter amount or select package")
        }else{
            if let reviewVC = PaymentReviewViewController.storyboardInstance() {
                reviewVC.paymentPayNow = .ZeroCarbon
                self.navigationController?.pushViewController(reviewVC, animated: true)
            }
        }
    }
    
    // MARK: -
    func getNeutraliseDetails(){
        HPProgressHUD.show()
        CarbonViewModel().getNeutraliseDetails(p_id:objCarbonManager?.selectedProjectModel?.id ?? 0){ response, error in
            HPProgressHUD.hide()
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response??.status, status == true {
                DispatchQueue.main.async {
                    print(response)
                    self.responseData = response??.data!
                   // objCarbonManager?.selectedProjectModel = response??.data
                    
                    let price = (objCarbonManager?.selectedProjectModel?.rate?.priceToPartner ?? "0.0").toDouble()
                    let aedPrice = price * (self.responseData?.usdToAed ?? 0.0)
                   
                    self.equationLabel.text = objUserSession.currency + "\(aedPrice.decimalPoints(point: 1) ) = 1 Credit"
                    
                    self.setProgress()
                   // self.setData()
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
}

// MARK: - UITableView
extension CarbonProjectNeutraliseViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return objCarbonManager?.selectedProjectModel?.packages?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110//UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarbonPackageTableViewCell") as! CarbonPackageTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        let packageModel = objCarbonManager?.selectedProjectModel?.packages![indexPath.row]
        
        cell.titleLabel.text = packageModel?.name ?? ""
        let credits = Double(packageModel?.credits ?? "0.0")
        let amount = (Double(packageModel?.amount ?? "0.0") ?? 0.0) * (self.responseData?.usdToAed ?? 0.0)

        cell.detailLabel.attributedText = NSMutableAttributedString().color(.white, "Buy \(credits?.decimalPoints(point: 1) ?? "") Credits with 10 tons ", font: .regular(size: 12)).subscriptString(.white, _subscriptString: "2", font: .regular(size: 12))
        cell.amountLabel.text = objUserSession.currency + amount.decimalPoints(point: 1)
        
        cell.imgView.sd_setImage(with: URL(string: (packageModel?.logo ?? "")), placeholderImage: nil)
        
        if selectedIndex == indexPath.row {
            cell.radioImgView.image = UIImage(named: "icon_radio_red")
        }else{
            cell.radioImgView.image = UIImage(named: "icon_radio_unselected_white")
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        
        self.customAmountView.text = ""
        let packageModel = objCarbonManager?.selectedProjectModel?.packages![indexPath.row]
        
        let credits = Double(packageModel?.credits ?? "0.0")!
        let amount = ((Double(packageModel?.amount ?? "0.0") ?? 0.0) * (self.responseData?.usdToAed ?? 0.0))

        objCarbonManager?.co2Tons = credits
        objCarbonManager?.co2AmountInAED = amount
        objCarbonManager?.co2AmountInUSD = Double(packageModel?.amount ?? "0.0") ?? 0.0
        
        objCarbonManager?.selectedPackageModel = objCarbonManager?.selectedProjectModel?.packages![indexPath.row]
        
        self.setProgress()
        tableView.reloadData()
    }
}

// MARK: - UICollectionView
extension CarbonProjectNeutraliseViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.imageCollectionView {
            return objCarbonManager?.selectedProjectModel?.photos!.count ?? 0
        }else if collectionView == self.logoCollectionView {
            return objCarbonManager?.selectedProjectModel?.ProjectGoalsAssociation?.count ?? 0
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.imageCollectionView {
            return CGSize(width: screenWidth - 95, height: self.imageCollectionView.bounds.height)
        }else if collectionView == self.logoCollectionView {
            return CGSize(width: 45, height: 30)
        }
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.imageCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCollectionViewCell", for: indexPath)
            cell.backgroundColor = .clear
            let imgView = cell.viewWithTag(201) as! UIImageView
            imgView.contentMode = .scaleAspectFill
            imgView.backgroundColor = .clear
            
            let photoModel = objCarbonManager?.selectedProjectModel?.photos![indexPath.row] // ?.count
            
            // let photoModel = self.photoArray[indexPath.row]
            imgView.sd_setImage(with: URL(string: (photoModel?.projectImageUrl ?? "")), placeholderImage: nil)
            
            return cell
        }else if collectionView == self.logoCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LogoCollectionViewCell", for: indexPath)
            cell.backgroundColor = .clear
            let imgView = cell.viewWithTag(101) as! UIImageView
            imgView.contentMode = .scaleAspectFit
            imgView.backgroundColor = .clear
            
            let logoModel = objCarbonManager?.selectedProjectModel?.ProjectGoalsAssociation![indexPath.row]
            
             imgView.sd_setImage(with: URL(string: (logoModel?.logo ?? "")), placeholderImage: nil)
            
            return cell
            
            
        }
        return UICollectionViewCell()
        
    }
}
// MARK: -
extension CarbonProjectNeutraliseViewController:PekoFloatingTextFieldViewDelegate{
    func textChange(textView: PekoFloatingTextFieldView) {
        if textView.text!.count != 0 {
            
            let amount = textView.text?.toDouble() ?? 0.0
            objCarbonManager?.co2AmountInAED = amount
         
            objCarbonManager?.co2AmountInAED = amount
            objCarbonManager?.co2AmountInUSD = amount / (self.responseData?.usdToAed ?? 0.0)
            
            let price = (objCarbonManager?.selectedProjectModel?.rate?.priceToPartner ?? "0.0").toDouble()
          
            let aedPrice = price * (self.responseData?.usdToAed ?? 0.0)
         
           
            if objCarbonManager?.co2AmountInAED != 0 {
                objCarbonManager?.co2Tons = (objCarbonManager?.co2AmountInAED ?? 0.0) / aedPrice
                self.creditsLabel.text = "\((objCarbonManager?.co2Tons ?? 0).rounded().decimalPoints(point: 1)) Credit"
            }
            objCarbonManager?.selectedPackageModel = nil
            self.selectedIndex = -1
            self.detailTableView.reloadData()
            self.setProgress()
        }else{
            self.creditsLabel.text = ""
        }
    }
    
    func dropDownClick(textView: PekoFloatingTextFieldView) {
        
    }
}

// MARK: -
class CarbonPackageTableViewCell:UITableViewCell {
    @IBOutlet weak var titleLabel: PekoLabel!
    @IBOutlet weak var detailLabel: PekoLabel!
    @IBOutlet weak var amountLabel: PekoLabel!
    @IBOutlet weak var radioImgView: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    
}
