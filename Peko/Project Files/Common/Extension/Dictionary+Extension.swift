//
//  Dictionary+Extension.swift
//  Peko
//
//  Created by Hardik Makwana on 21/02/23.
//

import UIKit

class Dictionary_Extension: NSObject {

}
extension Dictionary {
    func toJSON() -> String {
       // let dic = ["2": "B", "1": "A", "3": "C"]
        /*
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(self) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("\n\n\n JSON => ", jsonString)
                return jsonString
            }
        }
        return ""
        */
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
            return ""
        }
        let str = String(data: theJSONData, encoding: .ascii)
        return str ?? ""
    }
}
