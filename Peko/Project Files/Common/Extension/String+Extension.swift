//
//  String+Extension.swift
//  Peko
//
//  Created by Hardik Makwana on 04/01/23.
//

import UIKit

extension String {
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
    
    var isValidUAEMobileNumber: Bool {
        NSPredicate(format: "SELF MATCHES %@", "^(?:0)(?:50|52|54|55|56)[0-9]{7}$").evaluate(with: self)
    }
    
    func trim() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func separate(every: Int, with separator: String) -> String {
        return String(stride(from: 0, to: Array(self).count, by: every).map {
            Array(Array(self)[$0..<min($0 + every, Array(self).count)])
        }.joined(separator: separator))
    }
    func dateFromISO8601()->Date? {
        let strDate = self.replacingOccurrences(of: ".000Z", with: "Z")
        let localISOFormatter = ISO8601DateFormatter()
        localISOFormatter.timeZone = TimeZone.current

        return localISOFormatter.date(from: strDate)
        /*
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .iso8601)
        df.timeZone = TimeZone.current
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        if self.count == 0 {
            return nil
        }
        */
      //  return df.date(from:self)!
    }
    // MARK: - String to Double
    func toDouble() -> Double {
        let str = self.replacingOccurrences(of: ",", with: "")
        return Double(str) ?? 0.0
    }
    
    var html2AttributedString: String? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil).string
            
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
    
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    func toDate(format:String = "yyyy-MM-dd'T'HH:mm:ss")->Date {
        if self.count == 0 {
            return Date()
        }
        let df = DateFormatter()
//        df.calendar = Calendar(identifier: .iso8601)
//        df.timeZone = TimeZone.current
//        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = format
        return df.date(from:self)!
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func convertToDictionary() -> [String:Any]? {
        if let data = self.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }

    // MARK: -
    func localizeString() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
}

