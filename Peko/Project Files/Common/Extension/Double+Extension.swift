//
//  Double+Extension.swift
//  Peko
//
//  Created by Hardik Makwana on 24/02/23.
//

import UIKit

extension Double {
    func withCommas(decimalPoint:Int = 2) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = decimalPoint
        numberFormatter.minimumFractionDigits = decimalPoint
        return numberFormatter.string(from: NSNumber(value:self))!
    }
    func decimalPoints(point:Int = 2) -> String {
        return String(format: "%.\(point)f", self)
    }
    
    func toUSD(decimalPoint:Int = 2) -> String {
        let usd = self / 3.67
        return String(format: "%.\(decimalPoint)f", usd)
    }
}
