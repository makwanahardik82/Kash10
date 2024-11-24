//
//  CustomTabBar.swift
//  CustomTabBar
//
//  Created by Keihan Kamangar on 2021-06-07.
//

import UIKit
// import SDWebImage

class CustomTabBar: UITabBar {
    
    public var didTapButton: (() -> ())?
    
    public lazy var middleButton: UIButton! = {
        let middleButton = UIButton()
        
        middleButton.frame.size = CGSize(width: 60, height: 60)
        
       //let image = UIImage(systemName: "camera")!
       //middleButton.setImage(image, for: .normal)
        middleButton.setBackgroundImage(UIImage(named: "icon_tab_center"), for: .normal)
     //   middleButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
       // middleButton.backgroundColor = AppColors.orangeThemeColor
        middleButton.tintColor = .white
        middleButton.layer.cornerRadius = 8
        
        middleButton.addTarget(self, action: #selector(self.middleButtonAction), for: .touchUpInside)
        
        self.addSubview(middleButton)
        
        return middleButton
    }()
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if objShareManager.appTarget == .PekoUAE {

           
            
        }else if objShareManager.appTarget == .PekoIndia {
            self.layer.shadowRadius = 20.0
            self.backgroundColor = .red
            self.layer.masksToBounds = true
            self.isTranslucent = true
            self.barStyle = .blackOpaque
            self.layer.cornerRadius = 20
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.layer.borderWidth = 0.2
            self.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        self.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 0.4
        self.backgroundColor = .clear
//        self.layer.shadowOpacity = 0.4
//        self.layer.masksToBounds = false
//
        
    }
  
    override func layoutSubviews() {
        super.layoutSubviews()
        if objShareManager.appTarget == .PekoUAE {
            middleButton.center = CGPoint(x: frame.width / 2, y: 10)
            
            // CGPoint(x: frame.width / 2, y: frame.height / 3)
        }
        
    }
    
    // MARK: - Actions
    @objc func middleButtonAction(sender: UIButton) {
        didTapButton?()
    }
    
    // MARK: - HitTest
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        
        return self.middleButton.frame.contains(point) ? self.middleButton : super.hitTest(point, with: event)
    }
}
