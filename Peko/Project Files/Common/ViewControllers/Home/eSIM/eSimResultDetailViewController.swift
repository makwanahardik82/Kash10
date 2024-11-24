//
//  eSimResultDetailViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 15/04/24.
//

import UIKit
import WDScrollableSegmentedControl

class eSimResultDetailViewController: MainViewController {
    @IBOutlet weak var detailTableView: UITableView!
    
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var segmentControl: WDScrollableSegmentedControl!

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: PekoLabel!
    
    @IBOutlet weak var voiceLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var smsLabel: UILabel!
   
    @IBOutlet weak var validateLabel: UILabel!
    @IBOutlet weak var coverageLabel: UILabel!
   
    var infoArray = [Dictionary<String, String>]()
    
    static func storyboardInstance() -> eSimResultDetailViewController? {
        return AppStoryboards.eSim.instantiateViewController(identifier: "eSimResultDetailViewController") as? eSimResultDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Travel eSIM")
        self.view.backgroundColor = .white
     
      
        self.segmentControl.delegate = self
        segmentControl.font = AppFonts.Medium.size(size: 16)
        segmentControl.buttonSelectedColor = .black
        segmentControl.buttonHighlightColor = .black
        segmentControl.buttonColor = .grayTextColor
        segmentControl.indicatorColor = .redButtonColor
        //segmentControl.normalIndicatorColor = UIColor(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1.0)
        segmentControl.indicatorHeight = 3
        segmentControl.buttons = ["Additional Information", "Top-up Packages (\(objeSIMManager?.otherSimPackagesArray.count ?? 0))"]
        segmentControl.leftAlign = true
        
        self.detailTableView.tableHeaderView = self.headerView
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        self.detailTableView.backgroundColor = .clear
        self.detailTableView.separatorStyle = .none
        
        self.updateData()
        // Do any additional setup after loading the view.
    }
    func updateData(){
        
        let eSimOperator = objeSIMManager?.selectedPackage?.operators?.first
        let eSimPackageArray = eSimOperator?.packages
        
        self.titleLabel.text = eSimOperator?.title ?? ""
        self.imgView.sd_setImage(with: URL(string: eSimOperator?.image?.url ?? ""))
        let voice = objeSIMManager?.selectedeSimPackage?.voice?.value ?? "N/A"
        let day = objeSIMManager?.selectedeSimPackage?.day?.value ?? 0
        let data = objeSIMManager?.selectedeSimPackage?.data ?? "N/A"
        let sms = objeSIMManager?.selectedeSimPackage?.text?.value ?? "N/A"
        
        var dayString = ""
        let coverage = objeSIMManager?.selectedPackage?.title ?? ""
        
        if day == 0 {
            dayString = "N/A"
        }else if day == 1 {
            dayString = "1 Day"
        }else {
            dayString = "\(day) Days"
        }
        
        let color = UIColor(red: 101/255.0, green: 101/255.0, blue: 101/255.0, alpha: 1.0)
        self.voiceLabel.attributedText = NSMutableAttributedString().color(color, "Voice: ", font: .regular(size: 10)).color(.black, voice, font: .medium(size: 10))
        self.validateLabel.attributedText = NSMutableAttributedString().color(color, "Validate: ", font: .regular(size: 10)).color(.black, dayString, font: .medium(size: 10))
        
        self.dataLabel.attributedText = NSMutableAttributedString().color(color, "Data: ", font: .regular(size: 10)).color(.black, data, font: .medium(size: 10))
        self.smsLabel.attributedText = NSMutableAttributedString().color(color, "SMS: ", font: .regular(size: 10)).color(.black, sms, font: .medium(size: 10))
        self.coverageLabel.attributedText = NSMutableAttributedString().color(color, "Coverage: ", font: .regular(size: 10)).color(.black, coverage, font: .medium(size: 10))
        
        infoArray = [
            [
                "title":"NETWORK",
                "value":eSimOperator?.title ?? ""
            ],
            [
                "title":"PLAN TYPE",
                "value":eSimOperator?.plan_type ?? ""
            ],
            [
                "title":"eKYC (IDENTITY VERIFICATION)",
                "value":(eSimOperator?.is_kyc_verify ?? false) ? "Yes":"No"
            ],
            [
                "title":"TOP-UP OPTION",
                "value":"Available"
            ]
        ]
    }
    
    @IBAction func buyNowButtonClick(_ sender: Any) {
        if let vc = PaymentReviewViewController.storyboardInstance() {
            vc.paymentPayNow = .eSIM
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
// MARK: -
extension eSimResultDetailViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentControl.selectedIndex == 0{
            return 4
        }else{
            return objeSIMManager?.otherSimPackagesArray.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.segmentControl.selectedIndex == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "eSimInfoTableViewCell") as! eSimInfoTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            let dic = self.infoArray[indexPath.row]
            cell.titleLabel.text = dic["title"]
            cell.valueLabel.text = dic["value"]
         
            if indexPath.row % 2 == 0 {
                cell.view_1.backgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1.0)
               
            }else{
                cell.view_1.backgroundColor = .clear
                
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "eSimTopUpTableViewCell") as! eSimTopUpTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            let model = objeSIMManager?.otherSimPackagesArray[indexPath.row]
            
            let voice = model?.voice?.value ?? "N/A"
            let day = model?.day?.value ?? 0
            let data = model?.data ?? "N/A"
            let sms = model?.text?.value ?? "N/A"
            
            var dayString = ""
            var coverage = objeSIMManager?.selectedPackage?.title ?? ""
          
            if day == 0 {
                dayString = "N/A"
            }else if day == 1 {
                dayString = "1 Day"
            }else {
                dayString = "\(day) Days"
            }
            
            let str = "Voice: " + voice + "\n" +
            "SMS: " + sms + "\n" +
            "Validate: " + dayString + "\n" +
            "Data: " + data + "\n" +
            "Coverage: " + coverage
          
            cell.titleLabel.text = model?.title ?? ""
            let color = UIColor(red: 91/255.0, green: 91/255.0, blue: 91/255.0, alpha: 1.0)
            cell.detailLabel.attributedText = NSMutableAttributedString().color(color, str, font: .light(size: 10), 4)
           
            let amount = objUserSession.currency + (model?.price?.value ?? 0.0).withCommas()
                                                    
                                                    //* (objeSIMManager?.usdToAed ?? 0.0)).withCommas(decimalPoint: 2)
            cell.amountLabel.text = amount
            
            if model?.id == objeSIMManager?.selectedeSimPackage?.id {
                cell.containerView.borderWidth = 2
            }else{
                cell.containerView.borderWidth = 0
            }
            
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.segmentControl.selectedIndex == 0{
            
        }else{
            let model = objeSIMManager?.otherSimPackagesArray[indexPath.row]
            
            objeSIMManager?.selectedeSimPackage = model
            
            self.updateData()
            tableView.reloadData()
        }
        
    }
    
}

// MARK: - Segment
extension eSimResultDetailViewController:WDScrollableSegmentedControlDelegate{
    func didSelectButton(at index: Int) {
        DispatchQueue.main.async {
             self.detailTableView.reloadData()
        }
    }
}

// MARK: -
class eSimInfoTableViewCell:UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var view_1: UIView!
   
}

// MARK: -
class eSimTopUpTableViewCell:UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    //  @IBOutlet weak var view_1: UIView!
   
}
