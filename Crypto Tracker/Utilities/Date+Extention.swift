//
//  Date+Extention.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 25/04/25.
//

import Foundation

extension Date {
    
    // "MMM d" -> "Jan 5"
    func asShortDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }
    
    // "yyyy-MM-dd" -> "2021-09-30"
    func asYearMonthDayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    // Convert ISO8601 date string to Date
    static func fromISO8601(_ dateString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: dateString)
    }
}
