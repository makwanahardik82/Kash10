//
//  UIControl+Extension.swift
//  Peko
//
//  Created by Hardik Makwana on 19/01/24.
//

import UIKit


extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        addAction(UIAction { (action: UIAction) in closure() }, for: controlEvents)
    }
}
