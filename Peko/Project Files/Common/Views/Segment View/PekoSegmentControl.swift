//
//  PekoSegmentControl.swift
//  Peko
//
//  Created by Hardik Makwana on 01/12/23.
//

import UIKit

protocol PekoSegmentControlDelegate {
    func selectedSegmentIndex(index:Int)
}

class PekoSegmentControl: UIView {

    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
   
    @IBOutlet weak var lineLabelLeadingConstraint: NSLayoutConstraint!
  
    var delegate:PekoSegmentControlDelegate?
    var view: UIView!
    var selectedIndex = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSegmentControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSegmentControl()
    }
    
    
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
        
        self.firstButton.titleLabel?.font = AppFonts.SemiBold.size(size: 18)
        self.secondButton.titleLabel?.font = AppFonts.SemiBold.size(size: 18)
  
    }
    
    func loadNib() -> UIView {
        let nib = UINib(nibName: "PekoSegmentControlView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    // MARK: -
    func setupSegmentControl(){
        self.xibSetup()
        self.segmentButtonClick(self.firstButton)
    }

    // MARK: -
    @IBAction func segmentButtonClick(_ sender: UIButton) {
   
        if sender.tag == 1 {
            self.secondButton.setTitleColor(.grayTextColor, for: .normal)
            self.firstButton.setTitleColor(.black, for: .normal)
            self.lineLabelLeadingConstraint.constant = 0
        }else if sender.tag == 2 {
//            self.secondButton.titleLabel?.font = AppFonts.Medium.size(size: 16)
//            self.firstButton.titleLabel?.font = AppFonts.Light.size(size: 16)
            self.secondButton.setTitleColor(.black, for: .normal)
            self.firstButton.setTitleColor(.grayTextColor, for: .normal)
            self.lineLabelLeadingConstraint.constant = (screenWidth / 2.0)
        }
        self.selectedIndex = sender.tag
        if (self.delegate != nil) {
            self.delegate?.selectedSegmentIndex(index: sender.tag)
        }
    }
}
