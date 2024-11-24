//
//  UpcomingPaymentsCollectionViewCell.swift
//  Peko India
//
//  Created by Hardik Makwana on 09/12/23.
//

import UIKit

class UpcomingPaymentsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cardTrailingConstraint: NSLayoutConstraint!
   @IBOutlet weak var cardLeadingConstraint: NSLayoutConstraint!
  
    @IBOutlet weak var view_1: UIView!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var logoImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.view_1.isSkeletonable = true
    }

}
