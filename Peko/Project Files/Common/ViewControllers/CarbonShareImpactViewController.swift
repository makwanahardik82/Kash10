//
//  CarbonShareImpactViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 05/03/24.
//

import UIKit
import WDScrollableSegmentedControl

class CarbonShareImpactViewController: MainViewController {

    @IBOutlet weak var shareTableView: UITableView!
    @IBOutlet weak var segmentControl: WDScrollableSegmentedControl!
    
    @IBOutlet var pressFooterView: UIView!
    static func storyboardInstance() -> CarbonShareImpactViewController? {
         return AppStoryboards.Carbon.instantiateViewController(identifier: "CarbonShareImpactViewController") as? CarbonShareImpactViewController
     }
     
     override func viewDidLoad() {
         super.viewDidLoad()

         self.isBackNavigationBarView = true
         self.view.backgroundColor = .white
         self.setTitle(title: "Zero Carbon")
       
         self.segmentControl.delegate = self
         segmentControl.font = AppFonts.Medium.size(size: 16)
         segmentControl.buttonSelectedColor = .black
         segmentControl.buttonHighlightColor = .black
         segmentControl.buttonColor = .grayTextColor
         segmentControl.indicatorColor = .redButtonColor
         //segmentControl.normalIndicatorColor = UIColor(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1.0)
         segmentControl.indicatorHeight = 3
         segmentControl.buttons = ["PR Template", "Ads", "Resources"]
         segmentControl.leftAlign = true
         
         self.shareTableView.backgroundColor = .clear
         self.shareTableView.separatorStyle = .none
         self.shareTableView.delegate = self
         self.shareTableView.dataSource = self
         
         self.pressFooterView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth * 1.30)
         self.shareTableView.tableFooterView = self.pressFooterView
        // Do any additional setup after loading the view.
    }
}
extension CarbonShareImpactViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentControl.selectedIndex != 0{
            return 1
        }
        return  0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        if self.segmentControl.selectedIndex == 1 {
            cell.textLabel?.text = "What is the difference between weather and climate?"
            cell.textLabel?.font = .regular(size: 14)
        }else if self.segmentControl.selectedIndex == 2 {
            cell.textLabel?.attributedText = NSMutableAttributedString().color(.redButtonColor, "■     ").underline(.black, "What is the difference between weather and climate?", font: .regular(size: 14))
        }
        return cell
        
    }
}
extension CarbonShareImpactViewController:WDScrollableSegmentedControlDelegate {
    func didSelectButton(at index: Int) {
        DispatchQueue.main.async {
            if index == 0 {
                self.shareTableView.tableFooterView = self.pressFooterView
            }else{
                self.shareTableView.tableFooterView = nil
            }
            self.shareTableView.reloadData()
        }
    }
}
