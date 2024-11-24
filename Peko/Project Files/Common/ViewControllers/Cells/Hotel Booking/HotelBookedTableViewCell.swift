//
//  HotelBookedTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 11/01/24.
//

import UIKit

class HotelBookedTableViewCell: UITableViewCell {

    @IBOutlet weak var photImgView: UIImageView!
    @IBOutlet weak var hotelnameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var prNumberLabel: UILabel!
    @IBOutlet weak var confirmationNumberLabel: UILabel!
    
    @IBOutlet weak var checkInDateLabel: PekoLabel!
    @IBOutlet weak var checkInTimeLabel: PekoLabel!
    
    @IBOutlet weak var checkOutDateLabel: PekoLabel!
    @IBOutlet weak var checkOutTimeLabel: PekoLabel!
    
    @IBOutlet weak var noOfNightLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var cancelButton: PekoButton!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
