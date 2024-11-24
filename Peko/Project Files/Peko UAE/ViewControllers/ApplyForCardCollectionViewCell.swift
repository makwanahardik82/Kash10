//
//  ApplyForCardCollectionViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 05/01/23.
//

import UIKit

class ApplyForCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bannerImgView: UIImageView!
    @IBOutlet weak var view_1: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view_1.isSkeletonable = true
    }

}
