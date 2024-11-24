//
//  CarbonChartCollectionViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 28/03/24.
//

import UIKit

class CarbonChartCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var barViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: PekoLabel!
    @IBOutlet weak var barView: UIView!
    
    @IBOutlet weak var valueLabel: PekoLabel!
    
    @IBOutlet weak var valueContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
