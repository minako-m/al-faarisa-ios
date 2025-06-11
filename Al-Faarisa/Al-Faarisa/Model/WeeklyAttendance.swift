//
//  WeeklyAttendance.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 04.06.2025.
//

import Foundation

struct WeeklyAttendance: Identifiable {
    let id = UUID()
    let weekStart: Date
    let totalAttendees: Int
}

func groupEventsByWeek(events: [Event]) -> [WeeklyAttendance] {
    let calendar = Calendar.current

    let grouped = Dictionary(grouping: events) { event -> Date in
        calendar.dateInterval(of: .weekOfYear, for: event.date)?.start ?? event.date
    }

    return grouped.map { (weekStart, events) in
        WeeklyAttendance(
            weekStart: weekStart,
            totalAttendees: events.reduce(0) { $0 + $1.attendees.count }
        )
    }.sorted { $0.weekStart < $1.weekStart }
}
