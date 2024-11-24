//
//  PekoStoreHistoryListTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 13/03/24.
//

import UIKit

class PekoStoreHistoryListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productImgView: UIImageView!

    @IBOutlet weak var deliveryLabel: PekoLabel!
    @IBOutlet weak var productNameLabel: PekoLabel!
    
    @IBOutlet weak var trackButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
