//
//  LogoAnimationView.swift
//  Peko
//
//  Created by Hardik Makwana on 15/12/23.
//

import UIKit
import Lottie

/*
class LogoAnimationView: UIView {

    private var animationView: LottieAnimationView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.animationView?.center = self.convert(self.center, from: self.superview)
    }
    
    
    func setup(){
        LottieAnimationView()
        
        
        let animationView = AnimationView(name: "Loading")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.widthAnchor.constraint(equalToConstant: 450).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 450).isActive = true
      //  animationView.contentMode = .scaleAspectFit
        //animationView.loopMode = .loop
        self.addSubview(animationView)
        self.animationView = animationView
    }
    /// Display the spinner
    func show() {
        DispatchQueue.main.async { [weak self] in
            self?.animationView?.play()
            self?.isHidden = false
        }
    }
    
    /// Hide the spinner
    func hide() {
        DispatchQueue.main.async { [weak self] in
            self?.animationView?.stop()
            self?.isHidden = true
        }
    }
}

*/

