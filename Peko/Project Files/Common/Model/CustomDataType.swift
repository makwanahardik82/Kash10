//
//  CustomDataType.swift
//  Peko
//
//  Created by Hardik Makwana on 18/03/23.
//

import UIKit

struct CustomBool: Codable {
    var value:Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self.value = x == 1 ? true : false  // "\(x)" //.double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self.value = x == "1" ? true : false
            return
        }
        if let x = try? container.decode(Bool.self) {
            self.value = x // == "1" ? true : false
            return
        }
        throw DecodingError.typeMismatch(CustomBool.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for TransactionID"))
    }
}
struct CustomInt: Codable {
    var value:Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self.value = x // == 1 ? true : false  // "\(x)" //.double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self.value = Int(x) ?? 0 //== "1" ? true : false
            return
        }
        if let x = try? container.decode(Double.self) {
            self.value = Int(x) // == "1" ? true : false
            return
        }
//        if let x = try? container.decode(Bool.self) {
//            self.value = x // == "1" ? true : false
//            return
//        }
        throw DecodingError.typeMismatch(CustomInt.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for TransactionID"))
    }
}
struct CustomDouble: Codable {
    var value:Double
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self.value = Double(x) // == 1 ? true : false  // "\(x)" //.double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            if x == "NaN" {
                self.value = 0.0
                return
            }
            self.value = Double(x) ?? 0.0 //== "1" ? true : false
            return
        }
        if let x = try? container.decode(Double.self) {
            self.value = x // == "1" ? true : false
            return
        }
        throw DecodingError.typeMismatch(CustomInt.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for TransactionID"))
    }
}

struct CustomString: Codable {
    var value:String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self.value = String(format: "%d", x) // "\(x)" //.double(x)
            return
        }
        if let x = try? container.decode(Double.self) {
            self.value = "\(x)" // "\(x)" //.double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self.value = x //Int(x) ?? 0//.string(x)
            return
        }
        if let x = try? container.decode([Int].self) {
            if x.count != 0 {
                self.value = "\(x[0])"
                return
            }
             //Int(x) ?? 0//.string(x)
            
        }
        
        throw DecodingError.typeMismatch(CustomString.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for TransactionID"))
    }
}
