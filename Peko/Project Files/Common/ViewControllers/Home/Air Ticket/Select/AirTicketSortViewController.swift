//
//  AirTicketSortViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 07/03/24.
//

import UIKit

class AirTicketSortViewController: UIViewController {

    @IBOutlet weak var sortCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
   
    var selectedSortOption = ""
    
    var sortOptionsArray = [
    "High Price",
    "Low Price",
    "Popularity"
    ]
    static func storyboardInstance() -> AirTicketSortViewController? {
        return AppStoryboards.Air_Ticket.instantiateViewController(identifier: "AirTicketSortViewController") as? AirTicketSortViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColors.blackThemeColor?.withAlphaComponent(0.8)
        
        self.sortCollectionView.backgroundColor = .clear
        self.sortCollectionView.delegate = self
        self.sortCollectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.layoutIfNeeded()
        self.containerView.roundCorners([.topLeft, .topRight], radius: 30)
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

    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated:true)
    }
}
extension AirTicketSortViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sortOptionsArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenWidth - 88) / 3
        return CGSize(width: width, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SortOptionCollectionViewCell", for: indexPath) as! SortOptionCollectionViewCell
        cell.backgroundColor = .clear
        
        let title = self.sortOptionsArray[indexPath.row]
        cell.titleLabel.text = title
        
        if title == self.selectedSortOption {
            cell.titleLabel.textColor = .redButtonColor
            cell.containerView.borderColor = .redButtonColor
        }else{
            cell.titleLabel.textColor = .darkGray
            cell.containerView.borderColor = .darkGray
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedSortOption = self.sortOptionsArray[indexPath.row]
        collectionView.reloadData()
    }
}

class SortOptionCollectionViewCell:UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
}
