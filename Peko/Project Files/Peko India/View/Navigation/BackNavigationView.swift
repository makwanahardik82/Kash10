//
//  BackNavigationView.swift
//  Sharaf Exchange
//
//  Created by Hardik Makwana on 11/10/22.
//

import UIKit

class BackNavigationView: UIView {

    @IBOutlet weak var titleLabel: PekoLabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var notificationButton: UIButton!
    
    @IBOutlet weak var trolleyView: UIView!
   @IBOutlet weak var trolleyButton: UIButton!
    @IBOutlet weak var trolleyItemCountLabel: UILabel!
  
    @IBOutlet weak var orderHistoryView: UIView!
    @IBOutlet weak var historyButton: UIButton!
   
    @IBOutlet weak var trolleyImgView: UIImageView!
  
    @IBOutlet weak var bharatBillPayImgView: UIImageView!
  
    @IBOutlet weak var subscriptionHistoryButton: PekoButton!
    var view: UIView!
 //   var type:NavigateBarType?
  
    
    func xibSetup() {
        backgroundColor = UIColor.clear
        view = loadNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        view.backgroundColor = .clear
        view.clipsToBounds = false
        // Adding custom subview on top of our view
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view!]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view!]))
        self.titleLabel.font = AppFonts.SemiBold.size(size: 16)
        
        if objShareManager.getAppTarget() == .PekoUAE {
            self.historyButton.tintColor = .white
            self.trolleyImgView.tintColor = .white
        }else if objShareManager.getAppTarget() == .PekoIndia {
            self.historyButton.tintColor = .black
            self.trolleyImgView.tintColor = .black
        }
        
    }
    
    func loadNib() -> UIView {
        //        let bundle = Bundle(for: type(of: self))
        //        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: "BackNavigationView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }

}
