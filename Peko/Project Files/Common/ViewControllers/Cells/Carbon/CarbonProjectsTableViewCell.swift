//
//  CarbonProjectsTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 03/01/24.
//

import UIKit

class CarbonProjectsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: PekoLabel!
    
    @IBOutlet weak var planLabel: UILabel!
    @IBOutlet weak var addressLabel: PekoLabel!
    
    @IBOutlet weak var descriptionLabel: PekoLabel!
    @IBOutlet weak var view_1: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
