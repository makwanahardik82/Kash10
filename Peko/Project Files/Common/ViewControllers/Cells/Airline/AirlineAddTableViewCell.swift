//
//  AirlineAddTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 08/03/24.
//

import UIKit

class AirlineAddTableViewCell: UITableViewCell {

    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: PekoLabel!
    @IBOutlet weak var selectButton: PekoButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
