//
//  PassengerAddressTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 08/03/24.
//

import UIKit

class PassengerAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: PekoLabel!
    @IBOutlet weak var detailLabel: PekoLabel!
    @IBOutlet weak var editButton: UIButton!
  
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
