//
//  Date+Helpers.swift
//  Chat
//
//  Created by Maliks.
//

import Foundation

extension Date {
    func descriptiveString(dateStyle: DateFormatter.Style = .short) -> String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        
        let daysBetween = self.daysBetween(date: Date())
        
        if daysBetween == 0 {
            return "Today"
        }
        else if daysBetween == 1 {
            return "Yesterday"
        }
        else if daysBetween < 5 {
            let weekdayIndex = Calendar.current.component(.weekday, from: self) - 1
            return formatter.weekdaySymbols[weekdayIndex]
        }
        
        return formatter.string(from: self)
    }
    
    func daysBetween(date: Date) -> Int {
        let calender = Calendar.current
        let fromDate = calender.startOfDay(for: self)
        let toDate = calender.startOfDay(for: fromDate)
        
        if let daysBetween = calender.dateComponents([.day], from: fromDate, to: toDate).day {
            return daysBetween
        }
        
        return 0
    }
}
