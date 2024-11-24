//
//  AirTicketListTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 11/02/23.
//

import UIKit

class AirTicketListTableViewCell: UITableViewCell {

    @IBOutlet weak var view_1: UIView!
    
    @IBOutlet weak var flightLogoImgView: UIImageView!
    @IBOutlet weak var flightNameLabel: PekoLabel!
    
    @IBOutlet weak var sourceAirportNameLabel: PekoLabel!
    @IBOutlet weak var takeOffTimeLabel: PekoLabel!
    @IBOutlet weak var takeOffDateLabel: PekoLabel!
   
    @IBOutlet weak var destinationAirportLabel: PekoLabel!
    @IBOutlet weak var reachTimeLabel: PekoLabel!
    @IBOutlet weak var reachDateLabel: PekoLabel!
    
    @IBOutlet weak var classLabel: PekoLabel!
    
    @IBOutlet weak var amountLabel: PekoLabel!
    
    @IBOutlet weak var durationLabel: PekoLabel!
    
    @IBOutlet weak var numberOfStopLabel: PekoLabel!
    //    @IBOutlet weak var startTimeLabel: UILabel!
//    @IBOutlet weak var timeLabel: UILabel!
//    @IBOutlet weak var endTimeLabel: UILabel!
//    @IBOutlet weak var priceLabel: UILabel!
//   
//    @IBOutlet weak var flightLogoImgView: UIImageView!
//    @IBOutlet weak var flightNameLabel: UILabel!
    
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
        
       // self.lineView.layer.sublayers
        let topPoint = CGPoint(x: 0, y: 0)
        let bottomPoint = CGPoint(x: self.lineView.bounds.width, y: 0)

        let color = UIColor(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1.0)
        self.lineView.createDashedLine(from: topPoint, to: bottomPoint, color: color, strokeLength: 8, gapLength: 4, width: 1)
       // self.lineView.createDashedLine(from: topPoint, to: bottomPoint, color: color, strokeLength: 4, gapLength: 4, width: 1)
    }
}
