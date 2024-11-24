//
//  SavedTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 21/02/24.
//

import UIKit

class SavedTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: PekoLabel!
    @IBOutlet weak var subTitleLabel: PekoLabel!
   
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
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
