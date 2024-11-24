//
//  FinalPaymentTableViewCell.swift
//  Peko India
//
//  Created by Hardik Makwana on 13/12/23.
//

import UIKit

class FinalPaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImagView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var amountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
