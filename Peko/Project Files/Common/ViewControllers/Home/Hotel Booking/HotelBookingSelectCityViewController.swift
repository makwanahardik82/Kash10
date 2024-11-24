//
//  HotelBookingSelectCityViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 01/03/24.
//

import UIKit

class HotelBookingSelectCityViewController: MainViewController {

    @IBOutlet weak var cityTableView: UITableView!
    
    @IBOutlet weak var searchView: PekoFloatingTextFieldView!
    var completionBlock:((_ selectedString: String) -> Void)?
    
    var recentArray:[String] {
        get{
            let defaults = UserDefaults.standard
            let array = defaults.array(forKey: "RecentCityArray")  as? [String] ?? [String]() // ?? [Int]()
            return array
        }
        set{
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "RecentCityArray")
            defaults.synchronize()
        }
    }
    
    var searchArray = [String]()
    
    static func storyboardInstance() -> HotelBookingSelectCityViewController? {
        return AppStoryboards.HotelBooking.instantiateViewController(identifier: "HotelBookingSelectCityViewController") as? HotelBookingSelectCityViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.isBackNavigationBarView = true
//        self.setTitle(title: "Select Destination")
        self.view.backgroundColor = .white
      
        self.searchArray = Constants.cityArray
        
        self.cityTableView.delegate = self
        self.cityTableView.dataSource = self
      //  self.cityTableView.register(UINib(nibName: "HotelCityTableViewCell", bundle: nil), forCellReuseIdentifier: "HotelCityTableViewCell")
        self.cityTableView.backgroundColor = .clear
        self.cityTableView.separatorStyle = .none
        
        self.searchView.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
// MARK: -
extension HotelBookingSelectCityViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Recent Searches"
        }else{
            return "Popular Cities"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return recentArray.count
        }else{
            return searchArray.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotelCityTableViewCell") as! HotelCityTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
      
        var name = ""
        if indexPath.section == 0 {
            name = self.recentArray[indexPath.row]
        }else{
            name = searchArray[indexPath.row]
        }
        cell.titleLabel.text = name
        cell.detailLabel.text = ""
        cell.shortNameLabel.text = name.prefix(3).uppercased()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        var name = ""
        if indexPath.section == 0 {
            name = self.recentArray[indexPath.row]
        }else{
            name = searchArray[indexPath.row]
            if recentArray.contains(name){
                
            }else{
                recentArray.append(name)
            }
        }
        
        if self.completionBlock != nil {
            self.completionBlock!(name)
        }
        self.closeButtonClick(UIButton())
    }
}

extension HotelBookingSelectCityViewController:PekoFloatingTextFieldViewDelegate {
    func textChange(textView: PekoFloatingTextFieldView) {
        if self.searchView.text?.count == 0 {
            self.searchArray = Constants.cityArray
        }else{
            
            let searchString = self.searchView.text?.lowercased() ?? ""
            
            let array = self.searchArray.filter { ($0.lowercased()).contains(searchString)}
            
            // $0.airport_name?.lowercased().contains(textField.text?.lowercased() ?? "")
            self.searchArray = array
        }
        self.cityTableView.reloadData()
    }
    
    func dropDownClick(textView: PekoFloatingTextFieldView) {
        
    }
}

// MARK: -
class HotelCityTableViewCell:UITableViewCell {
    @IBOutlet weak var shortNameLabel: PekoLabel!
    @IBOutlet weak var titleLabel: PekoLabel!
    @IBOutlet weak var detailLabel: PekoLabel!
    
}
