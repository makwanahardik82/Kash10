//
//  PekoConnectTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 22/05/23.
//

import UIKit

class PekoConnectTableViewCell: UITableViewCell {
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var view_1: UIView!
    
    @IBOutlet weak var detailLabel: PekoLabel!
    //    @IBOutlet weak var discountLabel: UILabel!
//    @IBOutlet weak var taglineLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
