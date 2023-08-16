//
//  String+Extension.swift
//  finny
//
//  Created by Julia Hoang on 2023-08-16.
//

import Foundation

extension String {
    /// convert string to date in the format: e.g. Aug 14, 21
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yy"
        return dateFormatter.date(from: self)!
    }
}
