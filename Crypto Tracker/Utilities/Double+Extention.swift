//
//  Double+Extention.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 22/04/25.
//

import Foundation

extension Double {
    
    /// Converts a Double into a Currency with 2 decimal places
    /// ```
    /// Convert 1234.56 to $1,234.56
    /// ```
    func asCurrencyWith2Decimals() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return "$" + (formatter.string(from: NSNumber(value: self)) ?? "0.00")
    }
    
    /// Converts a Double into a Currency with 2-6 decimal places
    /// ```
    /// Convert 1234.56 to $1,234.56
    /// Convert 1.23456 to $1.23456
    /// ```
    func asCurrencyWith6Decimals() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        
        return "$" + (formatter.string(from: NSNumber(value: self)) ?? "0.00")
    }
    
    /// Converts a Double into a String representation
    /// ```
    /// Convert 1.23456 to "1.23"
    /// ```
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    /// Converts a Double into a String representation with percent symbol
    /// ```
    /// Convert 1.23456 to "1.23%"
    /// ```
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
    
    /// Converts a Double into a Currency with 2 decimal places
    /// ```
    /// Convert 1234.56 to $1,234.56
    /// ```
    func formatAsCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        let number = NSNumber(value: self)
        return formatter.string(from: number) ?? "0.00"
    }
    
    /// Converts a Double to a String with K, M, Bn, Tr abbreviations.
    /// ```
    /// Convert 1234.56 to "1.23K"
    /// ```
    func formattedWithAbbreviations() -> String {
        let num = abs(self)
        let sign = (self < 0) ? "-" : ""
        
        switch num {
            case 1_000_000_000_000...:
                let formatted = num / 1_000_000_000_000
                return "\(sign)\(formatted.formatAsCurrency())T"
            case 1_000_000_000...:
                let formatted = num / 1_000_000_000
                return "\(sign)\(formatted.formatAsCurrency())B"
            case 1_000_000...:
                let formatted = num / 1_000_000
                return "\(sign)\(formatted.formatAsCurrency())M"
            case 1_000...:
                let formatted = num / 1_000
                return "\(sign)\(formatted.formatAsCurrency())K"
            case 0...:
                return self.formatAsCurrency()
            default:
                return "\(sign)\(self)"
        }
    }
}
