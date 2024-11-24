//
//  HotelBookingListTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 20/08/23.
//

import UIKit
import SwiftyStarRatingView

class HotelBookingListTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingView: SwiftyStarRatingView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var cancelationDetailLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
//    
//    @IBOutlet weak var roomDescLabel: UILabel!
//    @IBOutlet weak var bedDescLabel: UILabel!
//  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
