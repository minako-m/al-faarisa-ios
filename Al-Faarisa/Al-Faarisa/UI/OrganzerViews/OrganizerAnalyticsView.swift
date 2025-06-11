//
//  OrganizerAnalyticsView.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 31.05.2025.
//

import SwiftUI
import Charts

enum TimeRange: CaseIterable {
    case lastMonth, last3Months, lastYear
    
    var monthsBack: Int {
        switch self {
        case .lastMonth: return 1
        case .last3Months: return 3
        case .lastYear: return 12
        }
    }
    
    var label: String {
        switch self {
        case .lastMonth: return "1M"
        case .last3Months: return "3M"
        case .lastYear: return "1Y"
        }
    }
}

struct OrganizerAnalyticsView: View {
    @StateObject private var session = UserSession.shared
    @State private var events: [Event] = []
    @State private var selectedRange: TimeRange = .lastMonth
    
    var filteredEvents: [Event] {
        let cutoff = Calendar.current.date(byAdding: .month, value: -selectedRange.monthsBack, to: Date()) ?? Date()
        return events.filter { $0.date >= cutoff }
    }
    
    var weeklyData: [WeeklyAttendance] {
        groupEventsByWeek(events: filteredEvents)
    }
    
    var body: some View {
        VStack {
            Text("Club Attendance")
                .titleTextStyle()
            Picker("Range", selection: $selectedRange.animation(.default)) {
                ForEach(TimeRange.allCases, id: \.self) { range in
                    Text(range.label).tag(range)
                }
            }
            .pickerStyle(.segmented)

            Chart(weeklyData) { item in
                LineMark(
                    x: .value("Week", item.weekStart, unit: .weekOfYear),
                    y: .value("Attendees", item.totalAttendees)
                )
                .foregroundStyle(.black)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .month)) {
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.week().month(), centered: true)
                }
            }
            .aspectRatio(1, contentMode: .fit)
        }
        .padding()
    }
}
//
//#Preview {
//    OrganizerAnalyticsView()
//}
