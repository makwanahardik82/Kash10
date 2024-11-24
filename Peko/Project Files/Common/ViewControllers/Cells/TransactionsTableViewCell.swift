//
//  TransactionsTableViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 08/01/23.
//

import UIKit

class TransactionsTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var billAmountLabel: UILabel!
    @IBOutlet weak var cashbackLabel: UILabel!
   // @IBOutlet weak var paymentAmountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutSubviews()
        self.layoutSkeletonIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
