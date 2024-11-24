//
//  DashboardCollectionViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 16/02/24.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
  
    @IBOutlet weak var view_1: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
     //   self.view_1.isSkeletonable = true
       
    }
    
}
