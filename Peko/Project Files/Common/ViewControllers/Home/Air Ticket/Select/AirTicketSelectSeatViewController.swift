//
//  AirTicketSelectSeatViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 10/03/24.
//

import UIKit
import WDScrollableSegmentedControl
class AirTicketSelectSeatViewController: MainViewController {

    @IBOutlet weak var segmentControl: WDScrollableSegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContainerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var tagCollectionView: UICollectionView!
    var seatArray = [AirTicketAncSeatMapModel]()
    var ancRulesModel:AirTicketAncRulesModel?
    
    var viewArray = [AirTicketSeatViewController]()
    
    var completionBlock:((_ array:[AirTicketAncSeatMapCabinDeckAirRowAirSeatsModel]) -> Void)?
  
    
    static func storyboardInstance() -> AirTicketSelectSeatViewController? {
        return AppStoryboards.Air_Ticket.instantiateViewController(identifier: "AirTicketSelectSeatViewController") as? AirTicketSelectSeatViewController
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isBackNavigationBarView = true
        self.setTitle(title: "Choose the Seat you want")
        self.view.backgroundColor = .white
   
        
      //  self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        let views:NSDictionary = ["containerView": self.scrollContainerView]
        //Width
        
        self.scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView(\(screenWidth * CGFloat(self.seatArray.count)))]|", options: [], metrics: nil, views: views as! [String : Any]))
       // self.scrollView.isScrollEnabled = true
     
       // = ["About", "How to Use", "Terms & Condition"]
        var array = [String]()
        for (index, element) in self.seatArray.enumerated() {
            if let qVC = AirTicketSeatViewController.storyboardInstance() {
                qVC.cabinArray = element.cabin ?? [AirTicketAncSeatMapCabinModel]()
                qVC.delegate = self
                qVC.maximumSeat = self.ancRulesModel?.ancillaryQuantity?.first?.max ?? 0
                addChild(qVC)
                self.stackView.addArrangedSubview(qVC.view)
                qVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                qVC.didMove(toParent: self)
                
                var title = element.cabin?.first?.deck?.first?.type
                let arrow = "\u{2192}" // U+2192
                title = title?.replacingOccurrences(of: "/", with: "   " + arrow + "   ")
                array.append(title ?? "")
                viewArray.append(qVC)
            }
        }
        
        self.segmentControl.delegate = self
        segmentControl.padding = 30
        segmentControl.font = AppFonts.SemiBold.size(size: 18)
        segmentControl.buttonSelectedColor = .redButtonColor
        segmentControl.buttonHighlightColor = .black
        segmentControl.buttonColor = UIColor(red: 158/255.0, green: 158/255.0, blue: 158/255.0, alpha: 1.0) // rgba(158, 158, 158, 1)
        segmentControl.indicatorColor = .redButtonColor
        //segmentControl.normalIndicatorColor = UIColor(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1.0)
        segmentControl.indicatorHeight = 3
        segmentControl.buttons = array
        segmentControl.leftAlign = true
        
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.register(UINib(nibName: "AirTicketTagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AirTicketTagCollectionViewCell")
        tagCollectionView.backgroundColor = .clear
       
    }
    
    //MARK:- Actions
    @objc func segmentValueChanged(segmentControl: DGSegmentedControl){
        if segmentControl.selectedIndex == 0 {
        }
    }

    // MARK: -
    @IBAction func clearButtonClick(_ sender: Any) {
        for element in self.viewArray {
            element.selectedSeatArray.removeAll()
            element.collectionView.reloadData()
        }
    }
    
    @IBAction func selectButtonClick(_ sender: Any) {
        if self.completionBlock != nil {
            var array = [AirTicketAncSeatMapCabinDeckAirRowAirSeatsModel]()
            for element in self.viewArray {
                array.append(contentsOf: element.selectedSeatArray)
            }
            self.completionBlock!(array)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK: -
extension AirTicketSelectSeatViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewArray.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let vc = self.viewArray[section]
        return vc.selectedSeatArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AirTicketTagCollectionViewCell", for: indexPath) as! AirTicketTagCollectionViewCell
        cell.backgroundColor = .clear
        
        let vc = self.viewArray[indexPath.section]
        let model = vc.selectedSeatArray[indexPath.row]
        
        cell.titleLabel.text = model.seatCode
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.viewArray[indexPath.section]
        vc.selectedSeatArray.remove(at: indexPath.row)
        vc.collectionView.reloadData()
    }
}
// MARK: -
extension AirTicketSelectSeatViewController:AirTicketSeatViewControllerDelegate{
    func seatSelected(vc: AirTicketSeatViewController) {
        self.tagCollectionView.reloadData()
    }
}

// MARK: - UIScrollViewDelegate
extension AirTicketSelectSeatViewController:UIScrollViewDelegate{
    
}
extension AirTicketSelectSeatViewController:WDScrollableSegmentedControlDelegate{
    func didSelectButton(at index: Int) {
        print(index)
        self.scrollView.setContentOffset(CGPoint(x: Int(screenWidth) * (index), y: 0), animated:true)
    }
}
