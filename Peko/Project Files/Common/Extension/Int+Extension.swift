//
//  Int+Extension.swift
//  Peko
//
//  Created by Hardik Makwana on 06/12/23.
//

import UIKit

extension Int {
    func timeString() -> String {
        let hour = self / 3600
        let minute = self / 60 % 60
        let second = self % 60
        
        if hour == 0 {
            return String(format: "%02i:%02i", minute, second)
        }else{
            return String(format: "%02i:%02i:%02i", hour, minute, second)
        }
    }
}
extension Int {
    var boolValue: Bool { return self != 0 }
}
