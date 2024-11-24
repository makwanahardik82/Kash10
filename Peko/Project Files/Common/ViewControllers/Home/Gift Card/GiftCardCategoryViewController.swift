//
//  GiftCardCategoryViewController.swift
//  Peko
//
//  Created by Hardik Makwana on 14/05/23.
//

import UIKit

class GiftCardCategoryViewController: UIViewController {

    static func storyboardInstance() -> GiftCardCategoryViewController? {
        return AppStoryboards.GiftCards.instantiateViewController(identifier: "GiftCardCategoryViewController") as? GiftCardCategoryViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
