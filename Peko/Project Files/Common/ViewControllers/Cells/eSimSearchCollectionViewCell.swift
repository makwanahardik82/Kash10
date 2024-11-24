//
//  eSimSearchCollectionViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 10/04/24.
//

import UIKit

class eSimSearchCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var view_1: UIView!
    
    @IBOutlet weak var logoImgView: UIImageView!
    
    @IBOutlet weak var nameLabel: PekoLabel!
    
    @IBOutlet weak var voiceLabel: UILabel!
    @IBOutlet weak var validateLabel: UILabel!
    @IBOutlet weak var coverageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
