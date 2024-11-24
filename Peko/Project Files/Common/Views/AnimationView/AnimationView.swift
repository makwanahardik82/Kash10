//
//  AnimationView.swift
//  Peko
//
//  Created by Hardik Makwana on 07/12/23.
//

import UIKit
import SwiftyGif

protocol AnimationViewDelegate {
    func finishAnimation()
}

class PekoAnimationView: UIView {
   // @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    
    var view: UIView!
    var delegate:AnimationViewDelegate?
   
//    @IBInspectable var loopCount: Int = -1 {
//        didSet {
//            self.setGIF()
//        }
//    }
        //
//    @IBInspectable var gifName: String? {
//        didSet {
//            self.setGIF()
//        }
//    }
    
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
        view = self.addNib(nibName: "AnimationView")
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
        
       
        imgView.delegate = self
        imgView.backgroundColor = .clear
        view.backgroundColor = .clear
    }
    
    // MARK: -
    func setGIF(gifName:String, loopCount:Int = -1){
        do {
            let gif = try UIImage(gifName: gifName)
            self.imgView.setGifImage(gif, loopCount: loopCount)
        } catch {
            print(error)
        }
    }
    func startAnimation(){
        self.imgView.startAnimatingGif()
    }
    func stopAnimation(){
        self.imgView.stopAnimatingGif()
    }
}
extension PekoAnimationView:SwiftyGifDelegate {
    func gifURLDidFinish(sender: UIImageView) {
        print("Loop")
    }
    func gifDidLoop(sender: UIImageView) {
        print("Loop")
    }
    func gifDidStop(sender: UIImageView) {
        if (self.delegate != nil) {
            self.delegate?.finishAnimation()
        }
    }
}
