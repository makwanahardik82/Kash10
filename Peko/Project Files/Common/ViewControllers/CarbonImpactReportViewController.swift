//
//  ImpactReportViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 05/03/24.
//

import UIKit

class CarbonImpactReportViewController: MainViewController {

    @IBOutlet weak var impactTableView: UITableView!
   
    @IBOutlet weak var totalLabel: PekoLabel!
    
    var total = 0.0
    
    var impactArray = [
        [
            "icon":"icon_carbon_1",
            "title":"46 Trees planted"
        ],
        [
            "icon":"icon_carbon_2",
            "title":"428L of Gasoline"
        ],
        [
            "icon":"icon_carbon_3",
            "title":"127,000 of smartphones worth charging power"
        ],
        [
            "icon":"icon_carbon_4",
            "title":"42 of BBQ propane tanks"
        ],
        [
            "icon":"icon_carbon_5",
            "title":"500 CO2 of Fire extinguishers"
        ],
        [
            "icon":"icon_carbon_6",
            "title":"6,000 km of a diesel car"
        ],
        [
            "icon":"icon_carbon_7",
            "title":"42 Refrigerators Worth Emissions for a year"
        ],
        [
            "icon":"icon_carbon_8",
            "title":"42 times Fueling up an SUV"
        ],
        [
            "icon":"icon_carbon_9",
            "title":"72 Trips worth of emission from Amsterdam to Rome"
        ],
        [
            "icon":"icon_carbon_10",
            "title":"1500 kg2 plastic waste being dumped in water bodies"
        ]
        
    ]
    
    static func storyboardInstance() -> CarbonImpactReportViewController? {
        return AppStoryboards.Carbon.instantiateViewController(identifier: "CarbonImpactReportViewController") as? CarbonImpactReportViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.view.backgroundColor = .white
        self.setTitle(title: "Zero Carbon")
      
        self.impactTableView.delegate = self
        self.impactTableView.dataSource = self
        self.impactTableView.backgroundColor = .clear
        self.impactTableView.register(UINib(nibName: "CarbonListTableViewCell", bundle: nil), forCellReuseIdentifier: "CarbonListTableViewCell")
        self.impactTableView.separatorStyle = .none
        
        
//        Total 232 CO2
        
        let color = UIColor(named: "747474")
        self.totalLabel.attributedText = NSMutableAttributedString().color(color!, "Total \(self.total.withCommas()) CO", font: .regular(size: 14), 5, .center).subscriptString(color!, _subscriptString: "2", font: .regular(size: 12), 5, .center).color(color!, " Ton Neutralized", font: .regular(size: 14), 5, .center)
           
    }
}
// MARK: - UITableView
extension CarbonImpactReportViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.impactArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarbonListTableViewCell") as! CarbonListTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        let dic  = self.impactArray[indexPath.row]
        cell.titleLabel.text = dic["title"]
        cell.iconImgView.image = UIImage(named: dic["icon"]!)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}
