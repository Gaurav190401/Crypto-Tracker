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
//        formatter.numberStyle = .currency
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
}
