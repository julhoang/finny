//
//  Date+Extension.swift
//  finny
//
//  Created by Julia Hoang on 2023-08-14.
//

import Foundation

extension Date {
    func toShortMDYString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yy"
        return dateFormatter.string(from: self)
    }
    
    func getMonthString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
}
