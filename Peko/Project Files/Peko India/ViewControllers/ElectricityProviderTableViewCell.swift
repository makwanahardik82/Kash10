//
//  ElectricityProviderTableViewCell.swift
//  Peko India
//
//  Created by Hardik Makwana on 12/12/23.
//

import UIKit

class ElectricityProviderTableViewCell: UITableViewCell {
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
