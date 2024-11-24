//
//  Date+Extension.swift
//  Peko
//
//  Created by Hardik Makwana on 31/03/23.
//

import UIKit

extension Date {
    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = formatter.string(from: self)
        let modifiedDate = formatter.date(from: strDate)
        return  formatter.string(from: modifiedDate!)
    }
  
    var mediumDate: String {
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.timeStyle = .none
        relativeDateFormatter.dateStyle = .medium
        relativeDateFormatter.locale = Locale(identifier: "en_GB")
        relativeDateFormatter.doesRelativeDateFormatting = true
        let modifiedDate = relativeDateFormatter.string(from: self)
        return  modifiedDate
    }
  
    func formate(format:String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func year() -> Int {
        return Calendar.current.dateComponents([.year], from: self, to: self).year ?? 0
    }

    
   
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    func last30Day() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -30, to: self)
    }
    func addDays(day:Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: day, to: self)
    }
    func addHours(hours:Int) -> Date? {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self)
    }
    
    func diffInDays(toDate:Date) -> Int {
        let diffInDays = Calendar.current.dateComponents([.day], from: self, to: toDate).day ?? 0
        return diffInDays
    }
    
    func diffInYears() -> Int {
        
        let ageComponents = Calendar.current.dateComponents([.year], from: self, to: Date())
        return ageComponents.year!
    }
}


extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
    func numberOfYearsBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.year], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.year!
    }
}
