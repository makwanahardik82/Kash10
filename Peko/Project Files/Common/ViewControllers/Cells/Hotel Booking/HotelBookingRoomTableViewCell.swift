//
//  HotelBookingRoomTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 04/01/24.
//

import UIKit

class HotelBookingRoomTableViewCell: UITableViewCell {

    @IBOutlet weak var roomIndexLabel: PekoLabel!
    @IBOutlet weak var containerView: UIView!
   
    @IBOutlet weak var radioImgView: UIImageView!
  //  @IBOutlet weak internal var photoImgView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
   // @IBOutlet weak var extraAmountLabel: UILabel!
    @IBOutlet weak var roomDescLabel: UILabel!
    
    @IBOutlet weak var cancellationLabel: UILabel!
    
    @IBOutlet weak var maxGuestLabel: PekoLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
