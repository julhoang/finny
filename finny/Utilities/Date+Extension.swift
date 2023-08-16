//
//  Date+Extension.swift
//  finny
//
//  Created by Julia Hoang on 2023-08-14.
//

import Foundation

extension Date {
    /// convert date to string in the format: e.g. Aug 14, 21
    func toShortMDYString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yy"
        return dateFormatter.string(from: self)
    }
    
    /// convert date to string in the format: e.g. August
    func getMonthString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
    func isCurrentMonthAndYear() -> Bool {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        let currentMonthAndYear = calendar.date(from: components)!
        
        return calendar.isDate(self, equalTo: currentMonthAndYear, toGranularity: .month)
    }
}
