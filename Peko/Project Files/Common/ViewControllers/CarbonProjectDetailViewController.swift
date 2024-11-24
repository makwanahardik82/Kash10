//
//  CarbonProjectDetailViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 03/01/24.
//

import UIKit
import MapKit
import WDScrollableSegmentedControl

class CarbonProjectDetailViewController: MainViewController {
    
    @IBOutlet weak var logoCollectionView: UICollectionView!
    @IBOutlet weak var locationLabel: PekoLabel!
    @IBOutlet weak var nameLabel: PekoLabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var detailTableView: UITableView!
    
    @IBOutlet weak var segmentControl: WDScrollableSegmentedControl!

    var array = [
        [
            "title":"Project Name ",
            "detail":"Land Use and Forestry, India"
        ],
        [
            "title":"Active Since",
            "detail":"20-20-2023"
        ],
        [
            "title":"Certification",
            "detail":"VERA"
        ],
        [
            "title":"Project Developer",
            "detail":"Forliance"
        ],
        [
            "title":"Technical Document",
            "detail":"Forliance"
        ],
        [
            "title":"Project Design Validated By",
            "detail":"Control Union"
        ],
        [
            "title":"Credits Verified By",
            "detail":"Control Union"
        ],
        [
            "title":"Registry",
            "detail":"Gold Standard Registry"
        ]
    ]
    
    static func storyboardInstance() -> CarbonProjectDetailViewController? {
        return AppStoryboards.Carbon.instantiateViewController(identifier: "CarbonProjectDetailViewController") as? CarbonProjectDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isBackNavigationBarView = true
        self.view.backgroundColor = .white
        self.setTitle(title: "Zero Carbon")
        
        let height = (screenWidth * 0.79) + 205
        self.headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: height)
        
        //  self.headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: (screenWidth * 0.65) + 195)
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
        
        self.segmentControl.delegate = self
        segmentControl.font = AppFonts.Medium.size(size: 16)
        segmentControl.buttonSelectedColor = .black
        segmentControl.buttonHighlightColor = .black
        segmentControl.buttonColor = .grayTextColor
        segmentControl.indicatorColor = .redButtonColor
        //segmentControl.normalIndicatorColor = UIColor(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1.0)
        segmentControl.indicatorHeight = 3
        segmentControl.buttons = ["Description", "Details"]
        segmentControl.leftAlign = true
        
        self.nameLabel.text = objCarbonManager!.selectedProjectModel!.name ?? ""
        self.locationLabel.text = (objCarbonManager?.selectedProjectModel?.city ?? "") + ", " + (objCarbonManager?.selectedProjectModel?.country ?? "")
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func neutraliseButtonClick(_ sender: Any) {
        if let vc = CarbonProjectNeutraliseViewController.storyboardInstance(){
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UITableView
extension CarbonProjectDetailViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentControl.selectedIndex == 0 {
            return 1
        }else if self.segmentControl.selectedIndex == 1 {
            return array.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.segmentControl.selectedIndex == 1 {
            return 40
        }
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if self.segmentControl.selectedIndex == 0 {
            
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.textLabel?.font = .regular(size: 14)
         //   cell.textLabel?.textColor = UIColor(named: "999999")
            
            let str = (objCarbonManager?.selectedProjectModel?.body?.html ?? "").html2AttributedString
            
            cell.textLabel?.attributedText = NSMutableAttributedString().color(UIColor(named: "999999")!, str ?? "", font: .regular(size: 14), 5)
            cell.textLabel?.numberOfLines = 0
         
            return cell
        }else if self.segmentControl.selectedIndex == 1 {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
            let dic = self.array[indexPath.row]
            
            cell.textLabel?.font = .regular(size: 14)
            cell.detailTextLabel?.font = .regular(size: 14)
            
            let color = UIColor(red: 118/255.0, green: 118/255.0, blue: 118/255.0, alpha: 1.0)
            
            cell.textLabel?.textColor = color
            cell.detailTextLabel?.textColor = color
            
            cell.textLabel?.text = dic["title"]
            cell.detailTextLabel?.text = dic["detail"]
            
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UICollectionView
extension CarbonProjectDetailViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
// MARK: - Segment
extension CarbonProjectDetailViewController:WDScrollableSegmentedControlDelegate{
    func didSelectButton(at index: Int) {
        DispatchQueue.main.async {
            self.detailTableView.reloadData()
        }
    }
}

// MARK: -
class CarbonProjectDetailTableViewCell:UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
}

// MARK: -
class CarbonProjectDetailMapTableViewCell:UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    //  @IBOutlet weak var detailLabel: UILabel!
}
// MARK: -
class CarbonProjectDetailPhotoTableViewCell:UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
}
