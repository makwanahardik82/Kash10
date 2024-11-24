//
//  AirTicketSeatViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 21/03/24.
//

import UIKit

protocol AirTicketSeatViewControllerDelegate {
    
    func seatSelected(vc:AirTicketSeatViewController)
    
}
class AirTicketSeatViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
   
    var cabinArray = [AirTicketAncSeatMapCabinModel]()
    
    private var airRowArray = [AirTicketAncSeatMapCabinDeckAirRowModel]()
    
    var delegate:AirTicketSeatViewControllerDelegate?
    
    var selectedSeatArray:[AirTicketAncSeatMapCabinDeckAirRowAirSeatsModel] = [AirTicketAncSeatMapCabinDeckAirRowAirSeatsModel]() {
        willSet{
            if self.delegate != nil {
                self.delegate?.seatSelected(vc: self)
            }
        }
    }
    var maximumSeat:Int = 0
    
    static func storyboardInstance() -> AirTicketSeatViewController? {
        return AppStoryboards.Air_Ticket.instantiateViewController(identifier: "AirTicketSeatViewController") as? AirTicketSeatViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let abc = cabinArray.first?.deck?.first?.airRow {
            self.airRowArray = abc
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .clear
        
        
        // Do any additional setup after loading the view.
    }

}
extension AirTicketSeatViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.airRowArray.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let seat = self.airRowArray[section].airSeats
        return (seat?.count ?? 0) + 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 23, height: 22)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeatCollectionViewCell", for: indexPath) as! SeatCollectionViewCell
        cell.backgroundColor = .clear
        cell.selectButton.isUserInteractionEnabled = false
        cell.selectButton.removeTarget(nil, action: nil, for: .allEvents)

        let sectionModel = self.airRowArray[indexPath.section] // .airSeats
        
        let seatArray = sectionModel.airSeats
        
        if indexPath.row == 3 {
            cell.containerView.backgroundColor = .clear
            cell.selectButton.setTitle("\(sectionModel.rowNumber?.value ?? 0)", for: .normal)
        }else{
            cell.selectButton.setTitle("", for: .normal)
            
            var index:Int = 0
            if indexPath.row < 3 {
                index = indexPath.row
            }else{
                index = indexPath.row - 1
            }
            let seatModel:AirTicketAncSeatMapCabinDeckAirRowAirSeatsModel = seatArray![index]
            cell.starImgView.isHidden = true
            
            if (seatModel.availability ?? "").uppercased() == "VAC" {
                
                if seatModel.chargeable ?? false {
                    cell.starImgView.isHidden = false
                    cell.containerView.backgroundColor = UIColor(red: 89/255.0, green: 89/255.0, blue: 89/255.0, alpha: 1.0)
                }else{
                    cell.containerView.backgroundColor = UIColor(red: 215/255.0, green: 215/255.0, blue: 215/255.0, alpha: 1.0)
                }
                
                let result = self.selectedSeatArray.contains { model in
                    return model.seatCode == seatModel.seatCode
                }
                if result {
                    cell.containerView.backgroundColor = .redButtonColor
                }else{
                    cell.selectButton.isUserInteractionEnabled = true
                    cell.selectButton.addAction {
                        
                        if self.selectedSeatArray.count < self.maximumSeat {
                            self.selectedSeatArray.append(seatModel)
                            collectionView.reloadData()
                        }else{
                            self.showAlert(title: "", message: "You have already selected \(self.selectedSeatArray.count) seat. Remove before adding a new one.")
                        }
                    }
                }
            }else if (seatModel.availability ?? "").uppercased() == "NOS" {
                cell.containerView.backgroundColor = .clear
            }else{
                cell.containerView.backgroundColor = UIColor(red: 1.0, green: 187/255.0, blue: 187/255.0, alpha: 1.0)
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
// MARK: -
class SeatCollectionViewCell:UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var starImgView: UIImageView!
    
    @IBOutlet weak var selectButton: UIButton!
    
}
