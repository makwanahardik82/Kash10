//
//  BackNavigationView.swift
//  Sharaf Exchange
//
//  Created by Hardik Makwana on 11/10/22.
//

import UIKit

class BackNavigationView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var notificationButton: UIButton!
    var view: UIView!
 //   var type:NavigateBarType?
  
    
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
        //        let bundle = Bundle(for: type(of: self))
        //        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: "BackNavigationView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }

}
