//
//  BillBeneficiaryTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 26/02/24.
//

import UIKit

class BillBeneficiaryTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImgView: UIImageView!
   
    @IBOutlet weak var titleLabel: PekoLabel!
    
    @IBOutlet weak var detailLabel: PekoLabel!
    
    @IBOutlet weak var payNowButton: PekoButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
