//
//  AirTicketAddLuggageViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 10/03/24.
//

import UIKit

class AirTicketAddLuggageViewController: MainViewController {

    @IBOutlet weak var collectionView: UICollectionView!
   
    @IBOutlet weak var segmentControl: PekoAirTicketSegmentControl!
   
    var baggagesArray = [AirTicketAncBaggagesModel]()
    var selectedIndex = -1
    
    var completionBlock:((_ baggagesModel:AirTicketAncBaggagesModel) -> Void)?
  
    
    static func storyboardInstance() -> AirTicketAddLuggageViewController? {
        return AppStoryboards.Air_Ticket.instantiateViewController(identifier: "AirTicketAddLuggageViewController") as? AirTicketAddLuggageViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Add Extra Luggage")
        self.view.backgroundColor = .white
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .clear
        
//        self.segmentControl.firstSegmentTitle = ""
//        self.segmentControl.secondSegmentTitle = ""
//
        if let journey = objAirTicketManager?.selectedAirlinesDataModel?.journey?.first, let first =  journey.flightSegments?.first, let last =  journey.flightSegments?.last {
           
            self.segmentControl.firstSegmentTitle = first.departureAirportCode ?? ""
            self.segmentControl.secondSegmentTitle = last.arrivalAirportCode ?? ""
        }
        if objAirTicketManager?.airTicketWayType != .OneWay {
            
        }else{
            self.segmentControl.view_2.isHidden = true
        }
        self.segmentControl.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func clearButtonClick(_ sender: Any) {
        self.selectedIndex = -1
        self.collectionView.reloadData()
    }
    @IBAction func addButtonClick(_ sender: Any) {
        if selectedIndex == -1 {
            self.showAlert(title: "", message: "Please select baggage option")
        }else{
            if self.completionBlock != nil {
                let model = self.baggagesArray[self.selectedIndex]
                self.completionBlock!(model)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }

}
// MARK: -
extension AirTicketAddLuggageViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.baggagesArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenWidth - 50) / 2
        return CGSize(width: width, height: 70)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LuggageCollectionViewCell", for: indexPath) as! LuggageCollectionViewCell
        cell.backgroundColor = .clear
        
        let model = self.baggagesArray[indexPath.row]
        cell.descriptionLabel.text = model.ancillary?.ancillaryDescription ?? ""
        if let fare = model.fare?.first {
            cell.amountLabel.text = (fare.sellingCurrency ?? "") + " " + (fare.sellingAmount?.value.withCommas() ?? "")
        }
     
        if selectedIndex == indexPath.row {
            cell.radioImgView.image = UIImage(named: "icon_radio_red")
        }else{
            cell.radioImgView.image = UIImage(named: "icon_radio_unselected")
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        collectionView.reloadData()
    }
}
// MARK: -
extension AirTicketAddLuggageViewController:PekoSegmentControlDelegate{
    func selectedSegmentIndex(index: Int) {
        
    }
}


// MARK: -
class LuggageCollectionViewCell:UICollectionViewCell {
    
    @IBOutlet weak var radioImgView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: PekoLabel!
    
    @IBOutlet weak var amountLabel: PekoLabel!
    
}
