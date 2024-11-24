//
//  PaymentCollectionViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 05/01/23.
//

import UIKit

class PaymentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgImgView: UIImageView!
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var payNowButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
