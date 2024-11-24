//
//  HPProgressHUD.swift
//  ProgressHUD
//
//  Created by Hardik Makwana on 19/10/19.
//  Copyright © 2019 Hardik Makwana. All rights reserved.
//

import UIKit
import Lottie

var objHPProgressHUD = HPProgressHUD.sharedInstance

class HPProgressHUD: UIViewController {

    @IBOutlet weak var animationView: LottieAnimationView!
   
 //   @IBOutlet weak var hudImgView: UIImageView!
    
    static let sharedInstance = HPProgressHUD()
    
     func initialize() {
        objHPProgressHUD =  HPProgressHUD(nibName: "HPProgressHUD", bundle: nil)
        objHPProgressHUD.modalPresentationStyle = .fullScreen
      
       // objHPProgressHUD.view
    }
       
    
    static func show() {
        DispatchQueue.main.async {
            objHPProgressHUD.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            let window = UIApplication.shared.keyWindow!
            window.addSubview(objHPProgressHUD.view)
            objHPProgressHUD.rotate1()
        }
    }
    static func hide() {
      //  objHPProgressHUD.dismiss(animated: false, completion: nil)
        DispatchQueue.main.async {
            objHPProgressHUD.view.removeFromSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isOpaque = false
        self.view.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        
        animationView.loopMode = .loop
      
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
      // self.hudImgView.rotate360Degrees(duration: 1.0)
        
    }
    func rotate1() { //CABasicAnimation
        self.animationView.play()
//
//            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
//            rotationAnimation.fromValue = 0.0
//            rotationAnimation.toValue = Double.pi * 2 //Minus can be Direction
//        rotationAnimation.duration = 1.0
//            rotationAnimation.repeatCount = .infinity
//        self.hudImgView.layer.add(rotationAnimation, forKey: nil)
    }
    
//    func rotateView(targetView: UIView, duration: Double = 1.0) {
//        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
//            targetView.transform = targetView.transform.rotated(by: CGFloat(Double.pi))
//        }) { finished in
//            self.rotateView(targetView: self.hudImgView, duration: 0.8)
//        }
//    }
//    
}

