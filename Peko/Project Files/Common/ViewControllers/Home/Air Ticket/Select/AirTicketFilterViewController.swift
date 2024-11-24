//
//  AirTicketFilterViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 07/03/24.
//

import UIKit
import WARangeSlider

class AirTicketFilterViewController: UIViewController {

    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
   
    @IBOutlet weak var priceRangeSlider: RangeSlider!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var minPriceRangeLabel: PekoLabel!
    
    @IBOutlet weak var maxPriceRangeLabel: PekoLabel!
    
    
    static func storyboardInstance() -> AirTicketFilterViewController? {
        return AppStoryboards.Air_Ticket.instantiateViewController(identifier: "AirTicketFilterViewController") as? AirTicketFilterViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColors.blackThemeColor?.withAlphaComponent(0.8)
       
        self.bottomConstraint.constant = -self.view.height
        
        self.priceRangeSlider.lowerValue = 5000
        self.priceRangeSlider.upperValue = 100000
        
        self.minPriceRangeLabel.text = objUserSession.currency + "5000"
        self.maxPriceRangeLabel.text = objUserSession.currency + "100000"
        
        priceRangeSlider.addTarget(self, action: #selector(rangeSliderChangeValue), for: .valueChanged)
        
        self.filterTableView.delegate = self
        self.filterTableView.dataSource = self
        self.filterTableView.backgroundColor = .clear
        self.filterTableView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.layoutIfNeeded()
        self.containerView.roundCorners([.topLeft, .topRight], radius: 30)
        self.animation()
    }
    
    // MARK: - ANIMATION
    func animation(){
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .curveEaseIn, // curveEaseIn
                       animations: { () -> Void in
            
          //  self.superview?.layoutIfNeeded()
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: { (finished) -> Void in
            
        })
    }
    
    // MARK: - 
    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated:true)
    }
    
    // MARK: -
    @IBAction func rangeSliderChangeValue(_ sender: RangeSlider) {
     
        print()
        print(self.priceRangeSlider.maximumValue)
        
        self.minPriceRangeLabel.text = objUserSession.currency + "\(Int(self.priceRangeSlider.lowerValue))"
        self.maxPriceRangeLabel.text = objUserSession.currency + "\(Int(self.priceRangeSlider.upperValue))"
    }
    
}
extension AirTicketFilterViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell")
        cell?.backgroundColor = .clear
        
        if section == 0 {
            
        }else{
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }else{
            return 10
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionTableViewCell")
        cell?.backgroundColor = .clear
        cell?.selectionStyle = .none
        
        return cell!
    }
}
