//
//  GiftCardProductTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 10/05/23.
//

import UIKit

class GiftCardProductTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
   
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var buyNowButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
