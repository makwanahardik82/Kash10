//
//  BeneficiaryActionViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 27/02/24.
//

import UIKit

enum BeneficiaryAction: Int {
    case Edit = 0
    case Delete
}

class BeneficiaryActionViewController: UIViewController {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
   
    var completionBlock:((_ action:BeneficiaryAction) -> Void)?
  
    
    static func storyboardInstance() -> BeneficiaryActionViewController? {
        return AppStoryboards.Beneficiary.instantiateViewController(identifier: "BeneficiaryActionViewController") as? BeneficiaryActionViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.view.backgroundColor = AppColors.blackThemeColor?.withAlphaComponent(0.8)
     
        // Do any additional setup after loading the view.
    }
    // MARK: - 
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.layoutIfNeeded()
        self.animation()
    }
    
    // MARK: - ANIMATION
    func animation(){
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .curveEaseIn, // curveEaseIn
                       animations: { () -> Void in
            
          //  self.superview?.layoutIfNeeded()
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: { (finished) -> Void in
            
        })
    }
    
// MARK: - Cancel Button Click
    @IBAction func cancelButtonClick(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func editButtonClick(_ sender: Any) {
        self.dismiss(animated: false) {
            if self.completionBlock != nil {
                self.completionBlock!(.Edit)
            }
        }
    }
    @IBAction func deleteButtonClick(_ sender: Any) {
        
        self.dismiss(animated: false) {
            if self.completionBlock != nil {
                self.completionBlock!(.Delete)
            }
        }
       
        
        /*
        let action = UIAlertController(title: "Delete Beneficiary", message: "Are you sure to want to delete this beneficiary?", preferredStyle: .actionSheet)
        action.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            
            self.dismiss(animated: false)
        }))
        action.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(action, animated: true)
        */
    }
    
}
