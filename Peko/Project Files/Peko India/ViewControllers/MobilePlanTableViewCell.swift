//
//  MobilePlanTableViewCell.swift
//  Peko India
//
//  Created by Hardik Makwana on 11/12/23.
//

import UIKit

class MobilePlanTableViewCell: UITableViewCell {

    @IBOutlet weak var validatyLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
  
    @IBOutlet weak var detailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
