//
//  AirlineTicketDetailsTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 07/03/24.
//

import UIKit

class AirlineTicketDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var departureLabel: PekoLabel!
    @IBOutlet weak var passengerlabel: PekoLabel!
    
    @IBOutlet weak var flightLogoImgView: UIImageView!
    @IBOutlet weak var flightNameLabel: PekoLabel!
    
    @IBOutlet weak var sourceAirportNameLabel: PekoLabel!
    @IBOutlet weak var takeOffTimeLabel: PekoLabel!
    @IBOutlet weak var takeOffDateLabel: PekoLabel!
    @IBOutlet weak var sourceAirportCityLabel: PekoLabel!
    
    @IBOutlet weak var sourceAirportTerminalLabel: PekoLabel!
    
    @IBOutlet weak var destinationAirportLabel: PekoLabel!
    @IBOutlet weak var reachTimeLabel: PekoLabel!
    @IBOutlet weak var reachDateLabel: PekoLabel!
    @IBOutlet weak var destinationAirportCityLabel: PekoLabel!
    @IBOutlet weak var destinationAirportTerminalLabel: PekoLabel!
  
    @IBOutlet weak var checkInBaggageLabel: PekoLabel!
    
    @IBOutlet weak var cabinLabel: PekoLabel!
    
   // @IBOutlet weak var amountLabel: PekoLabel!
    
  //  @IBOutlet weak var durationLabel: PekoLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
