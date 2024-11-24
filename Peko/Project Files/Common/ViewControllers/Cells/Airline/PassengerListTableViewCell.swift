//
//  PassengerListTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 13/03/24.
//

import UIKit

class PassengerListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: PekoLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
