//
//  AirTicketAddMealViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 10/03/24.
//

import UIKit

class AirTicketAddMealViewController: MainViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var segmentControl: PekoAirTicketSegmentControl!
    var mealArray = [AirTicketAncMealModel]()
    
    var selectedIndex = -1
    var completionBlock:((_ mealModel:AirTicketAncMealModel) -> Void)?
  
    static func storyboardInstance() -> AirTicketAddMealViewController? {
        return AppStoryboards.Air_Ticket.instantiateViewController(identifier: "AirTicketAddMealViewController") as? AirTicketAddMealViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Add a meal")
        self.view.backgroundColor = .white
   
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .clear
        
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
// MARK: -
    
    @IBAction func clearButtonClick(_ sender: Any) {
        self.selectedIndex = -1
        self.collectionView.reloadData()
    }
    @IBAction func addButtonClick(_ sender: Any) {
        if selectedIndex == -1 {
            self.showAlert(title: "", message: "Please select meal option")
        }else{
            if self.completionBlock != nil {
                let model = self.mealArray[self.selectedIndex]
                self.completionBlock!(model)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
}
// MARK: -
extension AirTicketAddMealViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.mealArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenWidth - 50) / 2
        return CGSize(width: width, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCollectionViewCell", for: indexPath) as! MealCollectionViewCell
        cell.backgroundColor = .clear
        
        let model = self.mealArray[indexPath.row]
       
        cell.descLabel.text = model.ancillary?.ancillaryDescription ?? ""
       
//        if let fare = model.fare?.first {
//            cell.amountLabel.text = (fare.sellingCurrency ?? "") + " " + (fare.sellingAmount?.value.withCommas() ?? "")
//        }
        if selectedIndex == indexPath.row {
            cell.checkImgView.image = UIImage(named: "icon_box_check_red")
        }else{
            cell.checkImgView.image = UIImage(named: "icon_box_unchecked")
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        collectionView.reloadData()
    }
}
// MARK: -
extension AirTicketAddMealViewController:PekoSegmentControlDelegate{
    func selectedSegmentIndex(index: Int) {
        
    }
}

class MealCollectionViewCell:UICollectionViewCell {
    @IBOutlet weak var checkImgView: UIImageView!
    
    @IBOutlet weak var descLabel: PekoLabel!
}
