//
//  AirTicketPassengerCabinViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 07/03/24.
//

import UIKit

class AirTicketPassengerCabinViewController: MainViewController {
    
    @IBOutlet weak var travellerTableView: UITableView!
    
    @IBOutlet weak var countLabel: PekoLabel!
    //  var roomArray = [Dictionary<String, Any>]()
    
    var completionBlock:((_ dic: [String:Int], _ cabin:String) -> Void)?
    
    var travellerDictionary:[String:Int] = [
        "adult":1,
        "child":0,
        "infants":0
    ]
    
    var cabinArray = [
        "Economy",
        "Business Class",
        "First Class",
        "Premium Economy"
    ]
    var selectedCabinClass = ""
    
    static func storyboardInstance() -> AirTicketPassengerCabinViewController? {
        return AppStoryboards.Air_Ticket.instantiateViewController(identifier: "AirTicketPassengerCabinViewController") as? AirTicketPassengerCabinViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     //   self.isBackNavigationBarView = true
        self.view.backgroundColor = .white
       // self.setTitle(title: "Select Passengers & Class")
        
        travellerTableView.delegate = self
        travellerTableView.dataSource = self
        travellerTableView.separatorStyle = .none
        travellerTableView.backgroundColor = .clear
        
        self.setCount()
    }
    func setCount(){
        let total_adult = travellerDictionary["adult"]!
        let total_child = travellerDictionary["child"]!
        let infants = travellerDictionary["infants"]!
        
        let total_guest = total_adult + total_child + infants
        
        self.countLabel.attributedText = NSMutableAttributedString().color(.black, "\(total_guest) Travelers").color(.redButtonColor, " • ").color(.black, "\(self.selectedCabinClass)")
        
        self.travellerTableView.reloadData()
    }
    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Done Button
    @IBAction func doneButtonClick(_ sender: Any) {
        if self.completionBlock != nil {
            self.completionBlock!(self.travellerDictionary, self.selectedCabinClass)
        }
        self.closeButtonClick(UIButton())
      //  self.navigationController?.popViewController(animated: false)
        //  self.closeButtonClick(UIButton())
    }
    // MARK: - ADULTS
    @objc func adultPlusButtonClick(sender:UIButton) {
        if let adult = self.travellerDictionary["adult"]{
            let count = adult + 1
            self.travellerDictionary["adult"] = count
        }
        self.setCount()
    }
    @objc func adultMinusButtonClick(sender:UIButton) {
        if let adult = self.travellerDictionary["adult"]{
            let count = adult - 1
            self.travellerDictionary["adult"] = count <= 1 ? 0:count
            
        }
        self.setCount()
    }
    // MARK: - Children
    @objc func childrenPlusButtonClick(sender:UIButton) {
        if let adult = self.travellerDictionary["child"]{
            let count = adult + 1
            self.travellerDictionary["child"] = count
        }
        self.setCount()
    }
    @objc func childrenMinusButtonClick(sender:UIButton) {
        if let adult = self.travellerDictionary["child"]{
            
            let count = adult - 1
            self.travellerDictionary["child"] = count <= 0 ? 0:count
        }
        self.setCount()
    }
    // MARK: - Infants
    @objc func infantsMinusButtonClick(sender:UIButton) {
        if let adult = self.travellerDictionary["infants"]{
            let count = adult - 1
            self.travellerDictionary["infants"] = count <= 0 ? 0:count
        }
        self.setCount()
    }
    @objc func infantsPlusButtonClick(sender:UIButton) {
        if let adult = self.travellerDictionary["infants"]{
            let count = adult + 1
            self.travellerDictionary["infants"] = count
        }
        self.setCount()
    }
    
}
// MARK: - HotelBookingSelectTravellerViewController
extension AirTicketPassengerCabinViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderViewCell")
        cell?.backgroundColor = .clear
        
        let label = cell?.viewWithTag(101) as! UILabel
        
        if section == 0 {
            label.text = "Select Passengers"
        }else{
            label.text = "Select Class"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return cabinArray.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
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
            
            cell.infantsPlusButton.addTarget(self, action: #selector(infantsPlusButtonClick(sender:)), for: .touchUpInside)
            cell.infantsMinusButton.addTarget(self, action: #selector(infantsMinusButtonClick(sender:)), for: .touchUpInside)
            
            
            cell.roomNoLabel.text = "Room \(indexPath.section + 1)"
            
            if let adult = self.travellerDictionary["adult"]{
                cell.adultCountLabel.text = "\(adult)"
            }
            if let child = self.travellerDictionary["child"]{
                cell.childrenCountLabel.text = "\(child)"
            }
            if let infants = self.travellerDictionary["infants"]{
                cell.infantsCountLabel.text = "\(infants)"
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CabinTableViewCell") as!CabinTableViewCell
            
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            let title = cabinArray[indexPath.row]
            cell.titleLabel.text = title
            if selectedCabinClass == title {
                cell.radioImgView.image = UIImage(named: "icon_radio_selected_red")
            }else{
                cell.radioImgView.image = UIImage(named: "icon_radio_unselected_red")
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.selectedCabinClass = cabinArray[indexPath.row]
            tableView.reloadData()
            self.setCount()
        }
    }
}

// MARK: -
class CabinTableViewCell:UITableViewCell {
    @IBOutlet weak var radioImgView: UIImageView!
    
    @IBOutlet weak var titleLabel: PekoLabel!
}
