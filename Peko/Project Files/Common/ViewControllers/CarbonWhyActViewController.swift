//
//  CarbonWhyActViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 05/03/24.
//

import UIKit

class CarbonWhyActViewController: MainViewController {

    @IBOutlet weak var impactTableView: UITableView!
   
    
    var actArray = [
        [
            "icon":"icon_why_act_1",
            "title":"Wildfires have increased by 14%"
        ],
        [
            "icon":"icon_why_act_2",
            "title":"Glacier Volumes have decreased by 68%"
        ],
        [
            "icon":"icon_why_act_3",
            "title":"Ocean Temperatures per decade  have increased by 0.13 °F"
        ],
        [
            "icon":"icon_why_act_4",
            "title":"Global snow cover has declined  by 5.8%"
        ],
        [
            "icon":"icon_why_act_5",
            "title":"Hurricane intensity has increased by 8%"
        ],
        [
            "icon":"icon_why_act_6",
            "title":"Global average temperature has increased by 2.7 °C"
        ],
        [
            "icon":"icon_why_act_7",
            "title":"Species in ecosystem have declined by  13.6% "
        ],
        [
            "icon":"icon_why_act_8",
            "title":"Global farming productivity has fallen by  21%"
        ],
        [
            "icon":"icon_why_act_9",
            "title":"Heatwave intensity will increase by  10% by 2050"
        ],
        [
            "icon":"icon_why_act_10",
            "title":"Global fresh water will outstrip supply by 40% by 2050 "
        ]
    ]
    
    static func storyboardInstance() -> CarbonWhyActViewController? {
        return AppStoryboards.Carbon.instantiateViewController(identifier: "CarbonWhyActViewController") as? CarbonWhyActViewController
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
    }
    
    
    @IBAction func neutralisebuttonClick(_ sender: Any) {
        if let vc = CarbonAllProjectsViewController.storyboardInstance() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    
}
// MARK: - UITableView
extension CarbonWhyActViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarbonListTableViewCell") as! CarbonListTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        let dic  = self.actArray[indexPath.row]
        cell.titleLabel.text = dic["title"]
        cell.iconImgView.image = UIImage(named: dic["icon"]!)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}
