//
//  Double+Extension.swift
//  finny
//
//  Created by Julia Hoang on 2023-08-16.
//

import Foundation

extension Double {
    /// Returns a string representation of the double formatted as a currency
    /// e.g. 1234.56 -> $1,234.56
    func formattedAsCurrency() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2

        guard let formattedAmount = numberFormatter.string(from: NSNumber(value: self)) else {
            return ""
        }

        return formattedAmount
    }
    
    func invert() -> Double {
        if self == 0 {
            return 0
        }
        
        return self * -1
    }
}
