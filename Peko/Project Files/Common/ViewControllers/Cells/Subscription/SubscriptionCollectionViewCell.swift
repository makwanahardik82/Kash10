//
//  SubscriptionCollectionViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 09/02/24.
//

import UIKit

class SubscriptionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutSubviews()
        self.layoutSkeletonIfNeeded()
    }

}
