//
//  OnbaordingCollectionViewCell.swift
//  Peko
//
//  Created by Hardik Makwana on 03/01/23.
//

import UIKit

class OnbaordingCollectionViewCell: UICollectionViewCell {

  //  @IBOutlet weak var earthImgView: UIImageView!
  //  @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        let bottomPadding = UIApplication.safeArea.bottom
//        self.bottomViewHeightConstraint.constant = bottomPadding
//        
        
        // let bottomPadding = UIApplication.currentUIWindow().first?.safeAreaInsets.bottom ?? 0
//      
//        let window = UIApplication.shared.windows.first
//        let topPadding = window!.safeAreaInsets.top
//        let bottomPadding = window!.safeAreaInsets.bottom
        
    }

}
