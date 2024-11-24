//
//  PekoIndiaSegmentControl.swift
//  Peko
//
//  Created by Hardik Makwana on 11/12/23.
//

import UIKit

protocol PekoIndiaSegmentControlDelegate {
    func selectedSegmentIndex(index:Int)
}

class PekoIndiaSegmentControl: UIView {

    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
 
    var view: UIView!
    var delegate:PekoIndiaSegmentControlDelegate?
   
    @IBInspectable var firstSegmentTitle: String? {
        didSet {
            self.firstButton.setTitle(self.firstSegmentTitle?.localizeString(), for: .normal)
        }
    }
    @IBInspectable var secondSegmentTitle: String? {
        didSet {
            self.secondButton.setTitle(self.secondSegmentTitle?.localizeString(), for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSegmentControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSegmentControl()
    }
    // MARK: -
    func setupSegmentControl(){
        self.xibSetup()
        self.segmentButtonClick(self.firstButton)
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
        let nib = UINib(nibName: "PekoIndiaSegmentControl", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
// MAEK: -
    // MARK: -
    @IBAction func segmentButtonClick(_ sender: UIButton) {
   
        if sender.tag == 1 {
            self.firstButton.titleLabel?.font = AppFonts.SemiBold.size(size: 16)
            self.secondButton.titleLabel?.font = AppFonts.Medium.size(size: 16)
            self.firstButton.setTitleColor(AppColors.blackThemeColor, for: .normal)
            self.secondButton.setTitleColor(UIColor(named: "999999"), for: .normal)
            
            firstButton.isSelected = true
            secondButton.isSelected = false
            
        }else if sender.tag == 2 {
            self.secondButton.titleLabel?.font = AppFonts.SemiBold.size(size: 16)
            self.firstButton.titleLabel?.font = AppFonts.Medium.size(size: 16)
            self.secondButton.setTitleColor(AppColors.blackThemeColor, for: .normal)
            self.firstButton.setTitleColor(UIColor(named: "999999"), for: .normal)
            
            firstButton.isSelected = false
            secondButton.isSelected = true
        }
        if (self.delegate != nil) {
            self.delegate?.selectedSegmentIndex(index: sender.tag)
        }
    }
}
