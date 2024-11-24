//
//  AddPassengersTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 08/03/24.
//

import UIKit

class AddPassengersTableViewCell: UITableViewCell {

    @IBOutlet weak var passengerCountLabel: PekoLabel!
    @IBOutlet weak var passengerTableView: UITableView!
    @IBOutlet weak var addPassengerButton: PekoButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
