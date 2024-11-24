//
//  SubscriptionTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 20/07/23.
//

import UIKit

class SubscriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var productImgView: UIImageView!
   
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var productPriceLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
