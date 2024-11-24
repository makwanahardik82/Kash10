//
//  HotelBookingSelectTravellerViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 10/01/24.
//

import UIKit

class HotelBookingSelectTravellerViewController: MainViewController {

    @IBOutlet weak var travellerTableView: UITableView!
   
    @IBOutlet weak var countLabel: PekoLabel!
    var roomArray = [Dictionary<String, Any>]()
    
    var completionBlock:((_ array: [Dictionary<String, Any>]) -> Void)?
   
    
    static func storyboardInstance() -> HotelBookingSelectTravellerViewController? {
        return AppStoryboards.HotelBooking.instantiateViewController(identifier: "HotelBookingSelectTravellerViewController") as? HotelBookingSelectTravellerViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.isBackNavigationBarView = true
//        self.setTitle(title: "Select Room & Guests")
        self.view.backgroundColor = .white
      
        if roomArray.count == 0 {
            self.addRoomButtonClick(UIButton())
        }
        
        travellerTableView.delegate = self
        travellerTableView.dataSource = self
        travellerTableView.separatorStyle = .none
        travellerTableView.backgroundColor = .clear
        self.setCount()
    }
    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
    // MARK: - Add Room Button
    @IBAction func addRoomButtonClick(_ sender: Any) {
        
        let dic = [
            "adult":1,
            "child":0,
        //    "infants":0
        ]
        self.roomArray.append(dic)
        self.setCount()
    }
    
    func setCount(){
        let total_adult = self.roomArray.compactMap { $0["adult"] as? Int }.reduce(0, +)
        let total_child = self.roomArray.compactMap { $0["child"] as? Int }.reduce(0, +)
      
        //let infants = self.roomArray.compactMap { $0["infants"] as? Int }.reduce(0, +)
        
        let total_guest = total_adult + total_child // + infants
        
        self.countLabel.attributedText = NSMutableAttributedString().color(.black, "\(total_guest) Guests").color(.redButtonColor, " • ").color(.black, "\(self.roomArray.count) Room")
      
        self.travellerTableView.reloadData()
    }
    
    // MARK: - Done Button
    @IBAction func doneButtonClick(_ sender: Any) {
        if self.completionBlock != nil {
            self.completionBlock!(self.roomArray)
        }
        self.closeButtonClick(UIButton())
        //self.navigationController?.popViewController(animated: false)
      //  self.closeButtonClick(UIButton())
    }
    // MARK: - ADULTS
    @objc func adultPlusButtonClick(sender:UIButton) {
        var dic = self.roomArray[sender.tag]
        if let adult = dic["adult"] as? Int{
            let count = adult + 1
            dic["adult"] = count
        }
        self.roomArray[sender.tag] = dic
        self.setCount()
    }
    @objc func adultMinusButtonClick(sender:UIButton) {
        var dic = self.roomArray[sender.tag]
        if let adult = dic["adult"] as? Int{
            let count = adult - 1
            dic["adult"] = count <= 1 ? 0:count
            if adult <= 1 {
                return
            }
        }
        self.roomArray[sender.tag] = dic
        self.setCount()
    }
    // MARK: - Children
    @objc func childrenPlusButtonClick(sender:UIButton) {
        var dic = self.roomArray[sender.tag]
        if let adult = dic["child"] as? Int{
            let count = adult + 1
            dic["child"] = count
            var ageArray:[String] = (dic["childAge"] as? [String]) ?? [String]()
            ageArray.append("")
            dic["childAge"] = ageArray
        }
        self.roomArray[sender.tag] = dic
        self.setCount()
    }
    @objc func childrenMinusButtonClick(sender:UIButton) {
        var dic = self.roomArray[sender.tag]
        if let adult = dic["child"] as? Int{
            
            let count = adult - 1
            dic["child"] = count <= 0 ? 0:count
            if adult <= 0 {
                return
            }
            var ageArray:[String] = (dic["childAge"] as? [String]) ?? [String]()
            ageArray.removeLast()
            dic["childAge"] = ageArray
        }
        self.roomArray[sender.tag] = dic
        self.setCount()
    }
    // MARK: - Infants
    @objc func infantsMinusButtonClick(sender:UIButton) {
        var dic = self.roomArray[sender.tag]
        if let adult = dic["infants"] as? Int{
            let count = adult - 1
            dic["infants"] = count <= 0 ? 0:count
            if adult <= 0 {
                return
            }
            var ageArray:[String] = (dic["childAge"] as? [String]) ?? [String]()
            ageArray.removeLast()
            dic["childAge"] = ageArray
        }
        self.roomArray[sender.tag] = dic
        self.setCount()
    }
    @objc func infantsPlusButtonClick(sender:UIButton) {
        var dic = self.roomArray[sender.tag]
        if let adult = dic["infants"] as? Int{
            let count = adult + 1
            dic["infants"] = count
            var ageArray:[String] = (dic["childAge"] as? [String]) ?? [String]()
            ageArray.append("")
            dic["childAge"] = ageArray
        }
        self.roomArray[sender.tag] = dic
        self.setCount()
    }
    
}
// MARK: - HotelBookingSelectTravellerViewController
extension HotelBookingSelectTravellerViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.roomArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dic = self.roomArray[section]
        
        if let child = dic["child"] as? Int{
            return child + 1
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var dic = self.roomArray[indexPath.section]
      
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TravellerTableViewCell") as!TravellerTableViewCell
            
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            cell.adultPlusButton.tag = indexPath.section
            cell.adultMinusButton.tag = indexPath.section
            cell.childrenPlusButton.tag = indexPath.section
            cell.childrenMinusButton.tag = indexPath.section
            
            cell.infantsPlusButton.tag = indexPath.section
            cell.infantsMinusButton.tag = indexPath.section
            
            cell.adultPlusButton.addTarget(self, action: #selector(adultPlusButtonClick(sender:)), for: .touchUpInside)
            cell.adultMinusButton.addTarget(self, action: #selector(adultMinusButtonClick(sender: )), for: .touchUpInside)
            cell.childrenPlusButton.addTarget(self, action: #selector(childrenPlusButtonClick(sender:)), for: .touchUpInside)
            cell.childrenMinusButton.addTarget(self, action: #selector(childrenMinusButtonClick(sender: )), for: .touchUpInside)
            
//            cell.infantsPlusButton.addTarget(self, action: #selector(infantsPlusButtonClick(sender:)), for: .touchUpInside)
//            cell.infantsMinusButton.addTarget(self, action: #selector(infantsMinusButtonClick(sender:)), for: .touchUpInside)
          
            
            cell.roomNoLabel.text = "Room \(indexPath.section + 1)"
            
            if let adult = dic["adult"] as? Int{
                cell.adultCountLabel.text = "\(adult)"
            }
            if let child = dic["child"] as? Int{
                cell.childrenCountLabel.text = "\(child)"
            }
//            if let infants = dic["infants"] as? Int{
//                cell.infantsCountLabel.text = "\(infants)"
//            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TravellerChildAgeTableViewCell") as! TravellerChildAgeTableViewCell
            
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            cell.titleLabel.text = "Child \(indexPath.row) Age"
            
            var ageArray:[String] = dic["childAge"] as? [String] ?? [String]() //?? [String]() as! [String]
            cell.ageTxt.text = ageArray[indexPath.row - 1]
            
            cell.ageDropDownButton.addAction(for: .touchUpInside) {
                
                let pickerVC = PickerListViewController.storyboardInstance()
                pickerVC?.array = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
                pickerVC?.selectedString = cell.ageTxt.text!
                pickerVC?.titleString = "Age"
                pickerVC?.completionBlock = { string in
                    cell.ageTxt.text = string
                    ageArray[indexPath.row - 1] = string
                    dic["childAge"] = ageArray
                    self.roomArray[indexPath.section] = dic
                }
                let nav = UINavigationController(rootViewController: pickerVC!)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
            return cell
        }
       
    }
}
// MARK: -
class TravellerTableViewCell:UITableViewCell {
    
    @IBOutlet weak var roomNoLabel: UILabel!
    
    @IBOutlet weak var adultPlusButton: UIButton!
    @IBOutlet weak var adultMinusButton: UIButton!
    @IBOutlet weak var adultCountLabel: UILabel!
    
    @IBOutlet weak var childrenPlusButton: UIButton!
    @IBOutlet weak var childrenMinusButton: UIButton!
    @IBOutlet weak var childrenCountLabel: UILabel!
    
    @IBOutlet weak var infantsPlusButton: UIButton!
    @IBOutlet weak var infantsMinusButton: UIButton!
    @IBOutlet weak var infantsCountLabel: UILabel!
    
}
class TravellerChildAgeTableViewCell:UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ageDropDownButton: UIButton!
    @IBOutlet weak var ageTxt: UITextField!
}
