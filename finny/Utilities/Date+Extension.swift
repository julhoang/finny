//
//  Date+Extension.swift
//  finny
//
//  Created by Julia Hoang on 2023-08-14.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yy"
        return dateFormatter.string(from: self)
    }
}
