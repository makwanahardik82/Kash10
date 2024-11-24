//
//  HotelBookingGuestListViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 13/03/24.
//

import UIKit

class HotelBookingGuestListViewController: MainViewController {

    @IBOutlet weak var addressTableView: UITableView!
   
    @IBOutlet weak var guestCountLabel: PekoLabel!
    
    var adultArray = [HotelBookingGuestModel]()
    var childArray = [HotelBookingGuestModel]()
    var total_adult = 0
    var total_child = 0
    var infants = 0
    var total_guest = 0
    
    static func storyboardInstance() -> HotelBookingGuestListViewController? {
        return AppStoryboards.HotelBooking.instantiateViewController(identifier: "HotelBookingGuestListViewController") as? HotelBookingGuestListViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isBackNavigationBarView = true
        self.setTitle(title: "Add Guests")
        self.view.backgroundColor = .white
   
        if objHotelBookingManager!.guestArray.count != 0 {
            adultArray = objHotelBookingManager!.guestArray.filter({ $0.isChild == false })
            childArray = objHotelBookingManager!.guestArray.filter({ $0.isChild == true })
        }
        
        total_adult = objHotelBookingManager?.searchRequest?.travellersArray!.compactMap { $0["adult"] as? Int }.reduce(0, +) ?? 0

        total_child = objHotelBookingManager?.searchRequest?.travellersArray!.compactMap { $0["child"] as? Int }.reduce(0, +) ?? 0
        infants = objHotelBookingManager?.searchRequest?.travellersArray!.compactMap { $0["infants"] as? Int }.reduce(0, +) ?? 0
       
        total_guest = total_adult + total_child + infants
       
        self.addressTableView.delegate = self
        self.addressTableView.dataSource = self
        self.addressTableView.register(UINib(nibName: "PassengerAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "PassengerAddressTableViewCell")
        self.addressTableView.backgroundColor = .clear
        self.addressTableView.separatorStyle = .none
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.updateCount()
    }
    func updateCount(){
        self.addressTableView.reloadData()
        self.guestCountLabel.text = "\(objHotelBookingManager!.guestArray.count)/\(total_guest)"
        
    }
    func manageGuest(){
        objHotelBookingManager!.guestArray.removeAll()
        objHotelBookingManager!.guestArray.append(contentsOf: self.adultArray)
        objHotelBookingManager!.guestArray.append(contentsOf:self.childArray)
        self.updateCount()
        self.addressTableView.reloadData()
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
        if let vc = HotelBookingGuestDetailViewController.storyboardInstance() {
            vc.isEdit = true
            vc.editGuestModel = self.adultArray[sender.tag]
            vc.completionBlock = { child in
                DispatchQueue.main.async {
                    let c = child
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
        if let vc = HotelBookingGuestDetailViewController.storyboardInstance() {
            vc.isEdit = true
            vc.editGuestModel = self.childArray[sender.tag]
            vc.completionBlock = { child in
                DispatchQueue.main.async {
                    let c = child
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
extension HotelBookingGuestListViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
        view?.backgroundColor = .clear
        
        let titleLabel = view?.viewWithTag(101) as! UILabel
        let countLabel = view?.viewWithTag(102) as! UILabel
      
        if section == 0 {
            titleLabel.text = "Adult"
            countLabel.text = "\(self.adultArray.count)/\(total_adult ) added"
          
        }else{
            titleLabel.text = "Children"
            countLabel.text = "\(self.childArray.count)/\(total_child ) added"
          
        }
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
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
        return view
        
    }
    @objc func addAdultButtonClick(sender:UIButton) {
        
        if (total_adult) == self.adultArray.count {
          
            self.showAlert(title: "", message: "You have already selected \((adultArray.count )) adult. Remove before adding a new one.")
            
        }else{
            if let vc = HotelBookingGuestDetailViewController.storyboardInstance() {
                vc.completionBlock = { adult in
                    DispatchQueue.main.async {
                        let c = adult
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
          
            self.showAlert(title: "", message: "You have already selected \((childArray.count )) child. Remove before adding a new one.")
            
        }else{
            if let vc = HotelBookingGuestDetailViewController.storyboardInstance() {
                vc.completionBlock = { child in
                    DispatchQueue.main.async {
                        let c = child
                        c.isChild = true
                        self.childArray.append(c)
                        self.manageGuest()
                       
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return adultArray.count
        }else{
            return childArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PassengerAddressTableViewCell") as! PassengerAddressTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.editButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        
        cell.editButton.removeTarget(nil, action: nil, for: .allEvents)
        cell.deleteButton.removeTarget(nil, action: nil, for: .allEvents)
       
        var guestModel:HotelBookingGuestModel?
        
        if indexPath.section == 0 {
            guestModel = adultArray[indexPath.row]
            cell.editButton.addTarget(self, action: #selector(editAdultButtonClick(sender: )), for: .touchUpInside)
            cell.deleteButton.addTarget(self, action: #selector(deleteAdultButtonClick(sender: )), for: .touchUpInside)
        }else{
            guestModel = childArray[indexPath.row]
            
            cell.editButton.addTarget(self, action: #selector(editChildButtonClick(sender: )), for: .touchUpInside)
            cell.deleteButton.addTarget(self, action: #selector(deleteChildButtonClick(sender: )), for: .touchUpInside)
        }
        
        cell.nameLabel.text = (guestModel?.first_name ?? "") + " " + (guestModel?.last_name ?? "")
        cell.detailLabel.text = "E-mail : \(guestModel?.email ?? "")\nMobile Number : \(guestModel?.phone_number ?? "")\nCountry : \(guestModel?.country ?? "")"
        
        return cell
    }
}
