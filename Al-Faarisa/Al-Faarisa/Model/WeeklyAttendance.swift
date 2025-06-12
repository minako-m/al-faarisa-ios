//
//  WeeklyAttendance.swift
//  Al-Faarisa
//
//  Created by chatGPT with the prompt: "make a struct that will group events by week
//  and calculate total per week. This struct will be used in a line chart from SwiftCharts
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
            totalAttendees: events.reduce(0) { $0 + $1.capacity }
        )
    }.sorted { $0.weekStart < $1.weekStart }
}
