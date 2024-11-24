//
//  PageControlView.swift
//  Peko
//
//  Created by Hardik Makwana on 13/04/23.
//

import UIKit

class PageControlView: UIView {
    
    @IBOutlet weak var dotImgView1: UIImageView!
    @IBOutlet weak var dotImgView2: UIImageView!
    @IBOutlet weak var dotImgView3: UIImageView!
    
    var view: UIView!
    
    let selectedColor:UIColor = .redButtonColor //UIColor(red: 31/255.0, green: 31/255.0, blue: 31/255.0, alpha: 1.0)
    let defaultColor = UIColor.white //UIColor(red: 212/255.0, green: 237/255.0, blue: 216/255.0, alpha: 1.0)
    
    var currentPage:Int {
        get{
            return self.currentPage
        }
        set{
            if newValue == 0 {
                self.dotImgView1.backgroundColor = selectedColor
                self.dotImgView2.backgroundColor = defaultColor
                self.dotImgView3.backgroundColor = defaultColor
            }else if newValue == 1 {
                self.dotImgView1.backgroundColor = defaultColor
                self.dotImgView2.backgroundColor = selectedColor
                self.dotImgView3.backgroundColor = defaultColor
            }else if newValue == 2 {
                self.dotImgView1.backgroundColor = defaultColor
                self.dotImgView2.backgroundColor = defaultColor
                self.dotImgView3.backgroundColor = selectedColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
    }
    
    
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
        let nib = UINib(nibName: "PageControlView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
