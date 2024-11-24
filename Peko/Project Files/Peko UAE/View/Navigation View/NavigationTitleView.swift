//
//  NavigationTitleView.swift
//  Peko
//
//  Created by Hardik Makwana on 07/01/23.
//

import UIKit

class NavigationTitleView: UIView {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var trolleyView: UIView!
  
    @IBOutlet weak var trolleyButton: UIButton!
    @IBOutlet weak var trolleyItemCountLabel: UILabel!
    var view: UIView!
    @IBOutlet weak var orderHistoryView: UIView!
    @IBOutlet weak var historyButton: UIButton!
   
    func xibSetup() {
        
        backgroundColor = UIColor.clear
        view = loadNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        view.backgroundColor = .clear
        view.clipsToBounds = true
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
        
    }
    
    func loadNib() -> UIView {
        let nib = UINib(nibName: "NavigationTitleView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
