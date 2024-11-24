//
//  ConnectionLostAlertUIView.swift
//  SmartCalc
//
//  Copyright © 2018 ClassCalc. All rights reserved.
//

import UIKit

class ConnectionLostAlertUIView: UIView {
    
    @IBOutlet var view: UIView!
   // @IBOutlet weak var alertLabel: EdgeInsetLabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var successLabel: UILabel!
   
    var heightConstraint: NSLayoutConstraint!
    var alertLabelAnimationTimer: Timer!
    var alertLabelAnimationRepeatTimes: Int = 0
    
    private var constraintsToActivateWhenShowing:[NSLayoutConstraint] = []
    private var constraintsToActivateWhenHiding:[(layoutConstraint: NSLayoutConstraint, value: CGFloat)] = []
    
    private var manuallyClosedAlert = false
    private var suspendAert = false
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("ConnectionLostAlertView", owner: self, options: nil)
        self.addSubview(self.view)
        
        self.hide()
        
        addReachibilityObservers()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = self.heightAnchor.constraint(equalToConstant: calculateViewHeight())
        self.view.frame.size.height = calculateViewHeight()
        
        let viewConstraints: [NSLayoutConstraint]  = [heightConstraint]
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    override func didMoveToWindow() {
        if(self.window == nil) {
            // When parent view is not in focus anymore, remove reachability observers
            removeReachibilityObservers()
            self.hide()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("ConnectionLostAlertView", owner: self, options: nil)
        self.addSubview(self.view)
        
        self.hide()
        
        addReachibilityObservers()
    }
    
    /**
     Set all the constraints as soon as superview is initialized
     */
    override func didMoveToSuperview() {
        if self.superview != nil {
            
            let topConstraint =     self.topAnchor.constraint(equalTo: self.superview!.safeAreaLayoutGuide.topAnchor)
            
           // let bottomConstraint =     self.bottomAnchor.constraint(equalTo: self.superview!.safeAreaLayoutGuide.bottomAnchor)
            let leftConstraint = self.leadingAnchor.constraint(equalTo: self.superview!.leadingAnchor)
            let rightConstraint = self.rightAnchor.constraint(equalTo: self.superview!.rightAnchor)
            
            let viewConstraints: [NSLayoutConstraint]  = [topConstraint, leftConstraint, rightConstraint]
            NSLayoutConstraint.activate(viewConstraints)
            
            self.view.frame.size.width = self.superview!.bounds.size.width
            
            
         //   alertLabel.layer.backgroundColor = alertLabelColor.cgColor
        }
    }
    
    
    func setAlertLabel(label: String){
        // self.errorLabel.text = label 
        self.layoutIfNeeded()
        self.view.frame.size.height = calculateViewHeight()
        heightConstraint.constant = calculateViewHeight()
    }
    
    private func calculateViewHeight() -> CGFloat {
        return 27 //alertLabel.getHeight() + 15
    }
    
    private func addReachibilityObservers() {
        /*
        if !UtilityFunctions.sharedInstance.checkNetworkConnection() {
            self.show(isCalledExternally: false)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(lostSocketConnection), name: Notification.Name(SocketIOManager.LOST_SOCKET_CONNECTION), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(establishedSocketConnection), name: Notification.Name(SocketIOManager.ESTABLISHED_SOCKET_CONNECTION), object: nil)
        */
    }
    
    private func removeReachibilityObservers() {
        /*
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(SocketIOManager.LOST_SOCKET_CONNECTION), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(SocketIOManager.ESTABLISHED_SOCKET_CONNECTION), object: nil)
        */
    }
    
    @objc func lostSocketConnection() {
        self.show(isCalledExternally: false)
    }
    
    @objc func establishedConnection() {
        self.successLabel.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.hide()
        }
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        manuallyClosedAlert = true
        self.hide()
    }
    
    /**
     Sets an array of NSLayoutConstraint that is used to change the constraints of provided elements when showing or hiding the alert message.
     
     - parameter constraints: eNSLayoutConstraint to be modified.
     */
    func setViewsConstraintsToModify(constraints: [NSLayoutConstraint]) {
        for constraint in constraints {
            constraintsToActivateWhenShowing.append(constraint)
            constraintsToActivateWhenHiding.append((layoutConstraint: constraint, value: constraint.constant))
        }
        updateViewConstraints()
    }
    
    func updateViewConstraints() {
        if self.isHidden {
            for constraint in constraintsToActivateWhenHiding{
                constraint.layoutConstraint.constant = constraint.value
            }
        } else {
            for constraint in constraintsToActivateWhenShowing {
                constraint.constant = calculateViewHeight()
            }
        }
    }
    
    func hide() {
        if !self.isHidden {
            self.isHidden = true
            updateViewConstraints()
        }
    }
    
    func show(isCalledExternally: Bool = true) {
        self.successLabel.isHidden = true
        var shouldAnimate = false
        if isCalledExternally {
            manuallyClosedAlert = false
            shouldAnimate = true
        }
        
        if !manuallyClosedAlert {
            if self.isHidden {
                self.isHidden = false
                updateViewConstraints()
            }
            
            if shouldAnimate {
                alertLabelAnimationRepeatTimes = 0
                alertLabelAnimationTimer?.invalidate()
                alertLabelAnimationTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.animateLabel), userInfo: nil, repeats: true)
            }
        }
    }
    @objc func animateLabel() {
        if alertLabelAnimationRepeatTimes < 6 {
            alertLabelAnimationRepeatTimes += 1
            
            UIView.animate(withDuration: 0.0, delay: 0.12, options:
                [UIView.AnimationOptions.allowUserInteraction],
                           animations: {
//                            if self.alertLabel.layer.backgroundColor == self.alertLabelColor.cgColor {
//                                self.alertLabel.layer.backgroundColor = Constants.themeColor.cgColor
//                            } else {
//                                self.alertLabel.layer.backgroundColor = self.alertLabelColor.cgColor
//                            }
            }, completion:nil )
        } else {
            alertLabelAnimationTimer.invalidate()
           // self.alertLabel.layer.backgroundColor = self.alertLabelColor.cgColor
        }
        
    }
    
}
