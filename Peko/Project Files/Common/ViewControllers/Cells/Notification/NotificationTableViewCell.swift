//
//  NotificationTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 07/01/23.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var view_1: UIView!
    @IBOutlet weak var dateLabel: PekoLabel!
    @IBOutlet weak var logoImgView: UIImageView!
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
