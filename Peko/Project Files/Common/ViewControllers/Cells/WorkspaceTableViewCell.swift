//
//  WorkspaceTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 09/11/23.
//

import UIKit

class WorkspaceTableViewCell: UITableViewCell {

    @IBOutlet weak var view_1: UIView!
    @IBOutlet weak var offerConatinerView: UIView!
    
    @IBOutlet weak var offerLabel: UILabel!
    // @IBOutlet weak var planIconImgView: UIImageView!
    
    @IBOutlet weak var planNameLabel: PekoLabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var planPriceLabel: PekoLabel!
    @IBOutlet weak var subTitleLabel: PekoLabel!
    
    @IBOutlet weak var planDescLabel: PekoLabel!
    
    @IBOutlet weak var highlightsLabel: PekoLabel!
    
 //   @IBOutlet weak var selectButtonContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
