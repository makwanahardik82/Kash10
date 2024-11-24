//
//  AddressListTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 23/02/24.
//

import UIKit

class AddressListTableViewCell: UITableViewCell {
    @IBOutlet weak var view_1: UIView!
    
    @IBOutlet weak var radioImgView: UIImageView!
    @IBOutlet weak var nameLabel: PekoLabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var detailLabel: PekoLabel!
    
    @IBOutlet weak var emailLabel: PekoLabel!
    
    @IBOutlet weak var phoneNumberLabel: PekoLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
