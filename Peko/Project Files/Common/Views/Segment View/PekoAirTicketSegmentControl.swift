//
//  PekoAirTicketSegmentControl.swift
//  Peko
//
//  Created by Hardik Makwana on 10/03/24.
//

import UIKit

protocol PekoAirTicketSegmentControlDelegate {
    func selectedSegmentIndex(index:Int)
}

class PekoAirTicketSegmentControl: UIView {
    
    @IBOutlet weak var view_1: UIView!
    @IBOutlet weak var view_2: UIView!
   
    @IBOutlet weak var segment1ArrowImgView: UIImageView!
    @IBOutlet weak var segment1Label1: PekoLabel!
    @IBOutlet weak var segment1Label2: PekoLabel!
    
    @IBOutlet weak var segment2ArrowImgView: UIImageView!
    @IBOutlet weak var segment2Label1: PekoLabel!
    @IBOutlet weak var segment2Label2: PekoLabel!
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
   
    @IBOutlet weak var segmentLine1: UILabel!
    @IBOutlet weak var segmentLine2: UILabel!
  
    
//    @IBOutlet weak var firstButton: UIButton!
//    @IBOutlet weak var secondButton: UIButton!
//   
//    @IBOutlet weak var lineLabelLeadingConstraint: NSLayoutConstraint!
  
    var delegate:PekoSegmentControlDelegate?
    var view: UIView!
    var selectedIndex = 1
    
    let selectedColor:UIColor = .redButtonColor
    let unSelectedColor:UIColor = .darkGray
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSegmentControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSegmentControl()
    }
    
    
    @IBInspectable var firstSegmentTitle: String? {
        willSet{
            self.segment1Label1.text = newValue?.localizeString()
            self.segment2Label2.text = newValue?.localizeString()
        }
    }
    @IBInspectable var secondSegmentTitle: String? {
        willSet {
            self.segment1Label2.text = newValue?.localizeString()
            self.segment2Label1.text = newValue?.localizeString()
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
      
        self.segmentLine1.backgroundColor = self.selectedColor
        self.segmentLine2.backgroundColor = self.selectedColor
        
    }
    
    func loadNib() -> UIView {
        let nib = UINib(nibName: "PekoAirTicketSegmentControl", bundle: nil)
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
          
            self.segment1Label1.textColor = self.selectedColor
            self.segment1Label2.textColor = self.selectedColor
            self.segment1ArrowImgView.tintColor = self.selectedColor
            
            self.segment2Label1.textColor = self.unSelectedColor
            self.segment2Label2.textColor = self.unSelectedColor
            self.segment2ArrowImgView.tintColor = self.unSelectedColor
            
            self.segmentLine1.isHidden = false
            self.segmentLine2.isHidden = true
            
        }else if sender.tag == 2 {

            self.segment2Label1.textColor = self.selectedColor
            self.segment2Label2.textColor = self.selectedColor
            self.segment2ArrowImgView.tintColor = self.selectedColor
            
            self.segment1Label1.textColor = self.unSelectedColor
            self.segment1Label2.textColor = self.unSelectedColor
            self.segment1ArrowImgView.tintColor = self.unSelectedColor
            
            self.segmentLine1.isHidden = true
            self.segmentLine2.isHidden = false
            
        }
        self.selectedIndex = sender.tag
        if (self.delegate != nil) {
            self.delegate?.selectedSegmentIndex(index: sender.tag)
        }
    }

}
