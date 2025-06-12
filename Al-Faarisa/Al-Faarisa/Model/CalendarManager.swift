//
//  CalendarManager.swift
//  Al-Faarisa
//
//  Created by ChatGPT using prompt: "create a layout that looks like DatPicker but
//  one that I can customize". This code was the backend of a calendarUI that ChatGPT generated.
//  It is meant to automate the calculation of number of days in a month + when a month starts
//

import Foundation

class CalendarManager: ObservableObject {
    @Published var currentDate = Date()
    
    var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        return calendar
    }
    
    func generateDaysInMonth() -> [Date?] {
        // Get the first day of the month
        guard let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) else {
            return []
        }
        
        // Find the weekday of the first day (1 = Sunday, 2 = Monday, etc.)
        let firstWeekdayOfMonth = calendar.component(.weekday, from: firstOfMonth)
        
        // Calculate the offset (how many placeholders before the first)
        // Since calendar.firstWeekday might be Monday (2),
        // this adjusts how many empty cells we need.
        let offset = (firstWeekdayOfMonth - calendar.firstWeekday + 7) % 7
        
        // Get the number of days in the month
        guard let range = calendar.range(of: .day, in: .month, for: currentDate) else {
            return []
        }
        
        // Start with 'offset' nils, then add actual days
        var days: [Date?] = Array(repeating: nil, count: offset)
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
}
