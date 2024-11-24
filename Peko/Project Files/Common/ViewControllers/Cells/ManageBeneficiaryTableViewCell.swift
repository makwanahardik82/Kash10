//
//  ManageBeneficiaryTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 21/02/24.
//

import UIKit

class ManageBeneficiaryTableViewCell: UITableViewCell {

    @IBOutlet weak var paymentLabel: PekoLabel!
    @IBOutlet weak var nameLabel: PekoLabel!
    @IBOutlet weak var numberLabel: PekoLabel!
   
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var switchButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
