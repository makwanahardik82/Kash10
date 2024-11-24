//
//  CarbonDashboardViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 09/07/23.
//

import UIKit
import Cirque

class CarbonDashboardViewController: MainViewController {

    @IBOutlet weak var totalTitleLabel: PekoLabel!
    @IBOutlet weak var footPrintLabel: PekoLabel!
    // @IBOutlet weak var segmentControl: PekoSegmentControl!
    @IBOutlet weak var actionCollectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var actionCollectionView: UICollectionView!
 //   @IBOutlet weak var footPrintCollectionView: UICollectionView!
    @IBOutlet weak var arcContainerView: UIView!
    @IBOutlet var headerView: UIView!
    
    @IBOutlet weak var carbonTableView: UITableView!
    
    @IBOutlet weak var totalLabel: PekoLabel!
  
    var counters:CarbonDashboardDataCountersModel?
    var projectArray = [CarbonProjectModel]()
    var isSkeletonView = true
    
    let actionArray = [
        [
            "title":"Impact Report",
            "icon":"icon_carbon_support_impact_report"
        ],
        [
            "title":"Share your Impact ",
            "icon":"icon_carbon_support_share_impact"
        ],
        [
            "title":"Why Act?",
            "icon":"icon_carbon_support_why_act"
        ],
        [
            "title":"Transaction",
            "icon":"icon_carbon_support_transaction"
        ],
        [
            "title":"Buy Credits",
            "icon":"icon_carbon_support_credit"
        ],
        [
            "title":"Support",
            "icon":"icon_carbon_support"
        ]
    ]
    
    var array = ["Your carbon footprint", "Total CO2 Neutralized", "Active Projects"]
    
    static func storyboardInstance() -> CarbonDashboardViewController? {
        return AppStoryboards.Carbon.instantiateViewController(identifier: "CarbonDashboardViewController") as? CarbonDashboardViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.isBackNavigationBarView = true
        self.view.backgroundColor = .white
        self.setTitle(title: "Zero Carbon")
      
        //  segmentControl.delegate = self
        
        let height = ((screenWidth - 66) / 3) * 2
        self.actionCollectionViewHeightConstraint.constant = height + 10
        self.headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 625 + (height))
        carbonTableView.tableHeaderView = self.headerView
     
        carbonTableView.register(UINib(nibName: "CarbonProjectsTableViewCell", bundle: nil), forCellReuseIdentifier: "CarbonProjectsTableViewCell")
        carbonTableView.register(UINib(nibName: "CarbonTransactionsTableViewCell", bundle: nil), forCellReuseIdentifier: "CarbonTransactionsTableViewCell")
        
        carbonTableView.delegate = self
        carbonTableView.dataSource = self
        carbonTableView.separatorStyle = .none
        carbonTableView.backgroundColor = .clear
        
        self.actionCollectionView.backgroundColor = .clear
        self.actionCollectionView.delegate = self
        self.actionCollectionView.dataSource = self
        self.actionCollectionView.register(UINib(nibName: "DashboardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DashboardCollectionViewCell")

        totalTitleLabel.attributedText = NSMutableAttributedString().color(.black, "Total Ared community\nCO", font: .regular(size: 17), 8, .center).subscriptString(.black, _subscriptString: "2", font: .regular(size: 17), 8, .center).color(.black, " neutralised", font: .regular(size: 17), 8, .center)
        
        carbonTableView.isUserInteractionEnabled = false
        self.headerView.showAnimatedGradientSkeleton()
        self.geDashboardDetails()
        
        objCarbonManager = CarbonManager.sharedInstance
    }
    // MARK: - Buy Now
    @IBAction func buyNowButtonClick(_ sender: Any) {
        if let allVC = CarbonAllProjectsViewController.storyboardInstance() {
            self.navigationController?.pushViewController(allVC, animated: true)
        }
    }
    
    // Calculate Button
    @IBAction func calculatorButtonClick(_ sender: Any) {
        if let calcVC = CarbonCalculatorViewController.storyboardInstance() {
            self.navigationController?.pushViewController(calcVC, animated: true)
        }
        
//        if let calcVC = CarbonCalculatorDetailViewController.storyboardInstance() {
//            self.navigationController?.pushViewController(calcVC, animated: true)
//        }
    }
    
    // MARK: - More Button Click
    @IBAction func moreButtonClick(_ sender: Any) {
        if let allVC = CarbonAllProjectsViewController.storyboardInstance() {
            self.navigationController?.pushViewController(allVC, animated: true)
        }
    }
    
    // MARK: -
    func geDashboardDetails(){
        CarbonViewModel().getDashboardDetails(){ response, error in
            if error != nil {
                #if DEBUG
            self.showAlert(title: "", message: error?.localizedDescription ?? "")
#else
            self.showAlert(title: "", message: "Something went wrong please try again")
#endif

            }else if let status = response??.status, status == true {
                DispatchQueue.main.async {
                    print(response)
                    self.counters = response??.data?.counters
                    self.projectArray = response??.data?.projects ?? [CarbonProjectModel]()
//                    self.counters = response
//                    self.projectArray = response.??.projectArray
                    self.isSkeletonView = false
                    self.carbonTableView.isUserInteractionEnabled = true
                    self.carbonTableView.reloadData()
                    self.actionCollectionView.reloadData()
                    self.headerView.hideSkeleton()
//                    self.questionAnswerModel = response??.data?.data!
//                    self.totalQuestion = response??.data?.recordsTotal ?? 0
                    self.setData()
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
    func setData(){
        self.footPrintLabel.attributedText = NSMutableAttributedString().color(.black, (self.counters?.co2FootPrint?.value ?? 0.0).withCommas(), font: .bold(size: 40), 5, .center).color(.black, " TONS CO", font: .regular(size: 23), 5, .center).subscriptString(.black, _subscriptString: "2", font: .regular(size: 23), 5, .center)
        
        self.totalLabel.text = (self.counters?.communityOffset?.value ?? 0.0).withCommas()
       
       // objCarbonManager?.co2FootPrint = (self.counters?.co2FootPrint?.value ?? 0.0)
    }
}
// MARK: - UITableView
extension CarbonDashboardViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarbonProjectsTableViewCell") as! CarbonProjectsTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let projectModel = self.projectArray[indexPath.row]
        
        cell.titleLabel.text = projectModel.name ?? ""
        cell.imgView.sd_setImage(with: URL(string: projectModel.logo ?? ""))
        cell.descriptionLabel.text = projectModel.description ?? ""
        cell.addressLabel.text = (projectModel.city ?? "") + ", " + (projectModel.country ?? "")
        let str = projectModel.body?.html?.html2AttributedString ?? ""
        cell.descriptionLabel.text = str
//
//        let titleLabel = cell.viewWithTag(101) as! UILabel
//        
//        titleLabel.text
//        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let allVC = CarbonProjectDetailViewController.storyboardInstance() {
            objCarbonManager?.selectedProjectModel = self.projectArray[indexPath.row]
            self.navigationController?.pushViewController(allVC, animated: true)
        }
    }
}
// MARK: -
extension CarbonDashboardViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == self.footPrintCollectionView {
//            return CGSize(width: 260, height: 110)
//        }else 
        if collectionView == self.actionCollectionView{
            let width = (screenWidth - 66) / 3
            return CGSize(width: width, height: width)
        }
       
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == self.footPrintCollectionView {
//            return array.count
//        }else 
        if collectionView == self.actionCollectionView{
            return actionArray.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCollectionViewCell", for: indexPath) as! DashboardCollectionViewCell
        cell.backgroundColor = .clear
        
        if isSkeletonView {
            cell.view_1.showAnimatedGradientSkeleton()
        }else{
            cell.view_1.hideSkeleton()
            let dic = self.actionArray[indexPath.row]
            cell.titleLabel.font = UIFont.regular(size: 10)
            cell.titleLabel.text = dic["title"]
            cell.logoImgView.image = UIImage(named: dic["icon"]!)
            
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0: // Impact
            if let importVC = CarbonImpactReportViewController.storyboardInstance() {
                importVC.total = self.counters?.userOffset?.value ?? 0.0
                self.navigationController?.pushViewController(importVC, animated: true)
            }
            break
        case 1: // Share
            if let shareVC = CarbonShareImpactViewController.storyboardInstance() {
                self.navigationController?.pushViewController(shareVC, animated: true)
            }
            break
        case 2: // WHy
            if let whyVC = CarbonWhyActViewController.storyboardInstance() {
                self.navigationController?.pushViewController(whyVC, animated: true)
            }
            break
        case 3: // Transaction
            
            
            break
        case 4: // Buy Credit
            if let allVC = CarbonAllProjectsViewController.storyboardInstance() {
                self.navigationController?.pushViewController(allVC, animated: true)
            }
            break
        case 5: // Support
            if let helpVC = HelpViewController.storyboardInstance() {
                self.navigationController?.pushViewController(helpVC, animated: true)
            }
            break
        default:
            break
        }
    }
}

