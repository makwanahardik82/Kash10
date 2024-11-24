//
//  PekoStoreCartTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 19/05/23.
//

import UIKit

class PekoStoreCartTableViewCell: UITableViewCell {

    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
   // @IBOutlet weak var deliveryTimeLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
   // @IBOutlet weak var qtyButton: UIButton!
    
 //   @IBOutlet weak var removeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
