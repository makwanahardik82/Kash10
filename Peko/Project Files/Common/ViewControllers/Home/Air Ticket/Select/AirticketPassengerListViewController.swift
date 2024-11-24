//
//  AirticketPassengerListViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 09/03/24.
//

import UIKit

class AirticketPassengerListViewController: MainViewController {

    @IBOutlet weak var addressTableView: UITableView!
    
    @IBOutlet weak var totalCountLabel: PekoLabel!
    var adultArray = [AirTicketPassangerDetailsModel]()
    var childArray = [AirTicketPassangerDetailsModel]()
    var total_adult = 0
    var total_child = 0
    var infants = 0
    var total_guest = 0
    
    static func storyboardInstance() -> AirticketPassengerListViewController? {
        return AppStoryboards.Air_Ticket.instantiateViewController(identifier: "AirticketPassengerListViewController") as? AirticketPassengerListViewController
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Add Passengers")
        self.view.backgroundColor = .white
   
        self.addressTableView.delegate = self
        self.addressTableView.dataSource = self
        self.addressTableView.register(UINib(nibName: "PassengerAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "PassengerAddressTableViewCell")
        self.addressTableView.backgroundColor = .clear
        self.addressTableView.separatorStyle = .none
        
        if objAirTicketManager!.passangerArray.count != 0 {
            adultArray = objAirTicketManager!.passangerArray.filter({ $0.isChild == false })
            childArray = objAirTicketManager!.passangerArray.filter({ $0.isChild == true })
        }
        
        total_adult = objAirTicketManager?.request.travellerDictionary["adult"] as! Int
        total_child = objAirTicketManager?.request.travellerDictionary["child"] as! Int //!
        infants = objAirTicketManager?.request.travellerDictionary["infants"] as! Int // !
        
        self.updateCount()
        
    }
    func updateCount() {
        self.totalCountLabel.text = "\(objAirTicketManager!.passangerArray.count)/\(objAirTicketManager?.request.passengersCount ?? "0")"
       
    }
    func manageGuest(){
        objAirTicketManager!.passangerArray.removeAll()
        objAirTicketManager!.passangerArray.append(contentsOf: self.adultArray)
        objAirTicketManager!.passangerArray.append(contentsOf:self.childArray)
        self.addressTableView.reloadData()
        self.updateCount()
    }
    // MARK: -
    @objc func deleteAdultButtonClick(sender:UIButton) {
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete it?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            self.adultArray.remove(at: sender.tag)
            self.manageGuest()
            self.addressTableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
        self.present(alert, animated: true)
    }
    @objc func editAdultButtonClick(sender:UIButton) {
        if let vc = AirticketAddPassengerDetailViewController.storyboardInstance() {
            vc.isEdit = true
            vc.passengerModel = self.adultArray[sender.tag]
            vc.completionBlock = { child in
                DispatchQueue.main.async {
                    var c = child
                    c.isChild = false
                    self.adultArray[sender.tag] = child
                    self.manageGuest()
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    // MARK
    
    // MARK: -
    @objc func deleteChildButtonClick(sender:UIButton) {
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete it?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            self.childArray.remove(at: sender.tag)
            self.manageGuest()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
        self.present(alert, animated: true)
    }
    @objc func editChildButtonClick(sender:UIButton) {
        if let vc = AirticketAddPassengerDetailViewController.storyboardInstance() {
            vc.isEdit = true
            vc.passengerModel = self.childArray[sender.tag]
            vc.completionBlock = { child in
                DispatchQueue.main.async {
                    var c = child
                    c.isChild = true
                    self.childArray[sender.tag] = c
                    self.manageGuest()
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
// MARK: - AirticketPassengerListViewController
extension AirticketPassengerListViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if total_adult == 0 {
                return 0
            }
        }else{
            if total_child == 0 {
                return 0
            }
        }
        return 40.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
        view?.backgroundColor = .clear
        
        let titleLabel = view?.viewWithTag(101) as! UILabel
        let countLabel = view?.viewWithTag(102) as! UILabel
        
        if section == 0 {
            titleLabel.text = "Adult"
            countLabel.text = "\(self.adultArray.count)/\(total_adult) added"
            if total_adult == 0 {
                view?.isHidden = true
            }
        }else{
            titleLabel.text = "Children"
            countLabel.text = "\(self.childArray.count)/\(total_child) added"
            if total_child == 0 {
                view?.isHidden = true
            }
        }
        view?.clipsToBounds = true
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            if total_adult == 0 {
                return 0
            }
        }else{
            if total_child == 0 {
                return 0
            }
        }
        return 70.0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableCell(withIdentifier: "FooterViewCell")
        view?.backgroundColor = .clear
        
        let button = view?.viewWithTag(201) as! UIButton
        button.removeTarget(nil, action: nil, for: .allEvents)

        if section == 0 {
            button.setTitle("Add Adult", for: .normal)
            button.addTarget(self, action: #selector(addAdultButtonClick(sender: )), for: .touchUpInside)
        }else{
            button.setTitle("Add Children", for: .normal)
            button.addTarget(self, action: #selector(addChildButtonClick(sender: )), for: .touchUpInside)
        }
        view?.clipsToBounds = true
        return view
        
    }
    @objc func addAdultButtonClick(sender:UIButton) {
        
        if (total_adult) == self.adultArray.count {
          
            self.showAlert(title: "", message: "You have already selected \((objAirTicketManager?.passangerArray.count ?? 0)) passenger. Remove before adding a new one.")
            
        }else{
            if let vc = AirticketAddPassengerDetailViewController.storyboardInstance() {
                vc.completionBlock = { child in
                    DispatchQueue.main.async {
                        var c = child
                        c.isChild = false
                        self.adultArray.append(c)
                        self.manageGuest()
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    @objc func addChildButtonClick(sender:UIButton) {
        if (total_child) == self.childArray.count {
          
            self.showAlert(title: "", message: "You have already selected \((objAirTicketManager?.passangerArray.count ?? 0)) passenger. Remove before adding a new one.")
            
        }else{
            
            if let vc = AirticketAddPassengerDetailViewController.storyboardInstance() {
                vc.completionBlock = { child in
                    DispatchQueue.main.async {
                        var c = child
                        c.isChild = true
                        self.childArray.append(c)
                        self.manageGuest()                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return self.adultArray.count
        }else{
            return self.childArray.count
        }
        // return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PassengerAddressTableViewCell") as! PassengerAddressTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.clipsToBounds = true
        cell.editButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        
        cell.editButton.removeTarget(nil, action: nil, for: .allEvents)
        cell.deleteButton.removeTarget(nil, action: nil, for: .allEvents)
     
        if indexPath.section == 0{
            let adult = self.adultArray[indexPath.row]
            cell.nameLabel.text = adult.honor + " " + adult.first_name + " " + adult.last_name
            cell.detailLabel.text = "Passport No. : \(adult.passportNumber)\nPassport Expiry : \(adult.passportExpiryDate?.formate(format: "dd/mm/yyyy") ?? "")"
            
            cell.editButton.addTarget(self, action: #selector(editAdultButtonClick(sender: )), for: .touchUpInside)
            cell.deleteButton.addTarget(self, action: #selector(deleteAdultButtonClick(sender: )), for: .touchUpInside)
      
        }else{
            let child = self.adultArray[indexPath.row]
            cell.nameLabel.text = child.honor + " " + child.first_name + " " + child.last_name
            cell.detailLabel.text = "Passport No. : \(child.passportNumber)\nPassport Expiry : \(child.passportExpiryDate?.formate(format: "dd/mm/yyyy") ?? "")"
            
            
            cell.editButton.addTarget(self, action: #selector(editChildButtonClick(sender: )), for: .touchUpInside)
            cell.deleteButton.addTarget(self, action: #selector(deleteChildButtonClick(sender: )), for: .touchUpInside)
     
        }
        
        return cell
    }
}
