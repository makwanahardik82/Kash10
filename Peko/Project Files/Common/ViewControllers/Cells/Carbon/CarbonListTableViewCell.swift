//
//  CarbonListTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 05/03/24.
//

import UIKit

class CarbonListTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImgView: UIImageView!
    
    @IBOutlet weak var titleLabel: PekoLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
