//
//  HotelBookingHistoryTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 15/03/24.
//

import UIKit

class HotelBookingHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var hotelImgView: UIImageView!
    @IBOutlet weak var hotelNameLabel: PekoLabel!
    @IBOutlet weak var roomDetailLabel: PekoLabel!
   
    @IBOutlet weak var guestDetailLabel: PekoLabel!
    
    @IBOutlet weak var checkInDateLabel: PekoLabel!
    @IBOutlet weak var checkInTimeLabel: PekoLabel!
    
    @IBOutlet weak var checkOutDateLabel: PekoLabel!
    @IBOutlet weak var checkOutTimeLabel: PekoLabel!
    
    @IBOutlet weak var confirmationNumberLabel: PekoLabel!
    @IBOutlet weak var prNumberLabel: PekoLabel!
    
    
    @IBOutlet weak var noOfNightLabel: PekoLabel!
    
    @IBOutlet weak var view_1: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
