//
//  AirTicketTwoWayListTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 19/06/23.
//

import UIKit

class AirTicketTwoWayListTableViewCell: UITableViewCell {

    @IBOutlet weak var view_1: UIView!
    
    
    //MARK: - J 1
    @IBOutlet weak var j1_flightLogoImgView: UIImageView!
    @IBOutlet weak var j1_flightNameLabel: PekoLabel!
    
    @IBOutlet weak var j1_sourceAirportNameLabel: PekoLabel!
    @IBOutlet weak var j1_takeOffTimeLabel: PekoLabel!
    @IBOutlet weak var j1_takeOffDateLabel: PekoLabel!
   
    @IBOutlet weak var j1_destinationAirportLabel: PekoLabel!
    @IBOutlet weak var j1_reachTimeLabel: PekoLabel!
    @IBOutlet weak var j1_reachDateLabel: PekoLabel!
    @IBOutlet weak var j1_durationLabel: PekoLabel!
    
    @IBOutlet weak var j1_numberOfStopLabel: PekoLabel!
    
    
    //MARK: - J- 2
    @IBOutlet weak var j2_flightLogoImgView: UIImageView!
    @IBOutlet weak var j2_flightNameLabel: PekoLabel!
    
    @IBOutlet weak var j2_sourceAirportNameLabel: PekoLabel!
    @IBOutlet weak var j2_takeOffTimeLabel: PekoLabel!
    @IBOutlet weak var j2_takeOffDateLabel: PekoLabel!
   
    @IBOutlet weak var j2_destinationAirportLabel: PekoLabel!
    @IBOutlet weak var j2_reachTimeLabel: PekoLabel!
    @IBOutlet weak var j2_reachDateLabel: PekoLabel!
    @IBOutlet weak var j2_durationLabel: PekoLabel!
    
    @IBOutlet weak var j2_numberOfStopLabel: PekoLabel!
    
    @IBOutlet weak var classLabel: PekoLabel!
    
    @IBOutlet weak var amountLabel: PekoLabel!
 
//
    @IBOutlet weak var lineView: UIView!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
     
        let topPoint = CGPoint(x: 0, y: 0)
        let bottomPoint = CGPoint(x: self.lineView.bounds.width, y: 0)

        let color = UIColor(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1.0)
        self.lineView.createDashedLine(from: topPoint, to: bottomPoint, color: color, strokeLength: 8, gapLength: 4, width: 1)
      
    }
    
}
