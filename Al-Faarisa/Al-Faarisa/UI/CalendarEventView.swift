//
//  CalendarEventView.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 11.06.2025.
//

import SwiftUI


struct CalendarEventView: View {
    @StateObject private var dbManager = DatabaseManager.shared
    @StateObject var manager = CalendarManager()
    @State private var selectedDate: Date = Date()
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        VStack {
            // Month & Year header
            HStack {
                Button("", systemImage: "arrowshape.left.fill") {
                    withAnimation {
                        changeMonth(by: -1)
                    }
                }
                Spacer()
                Text(manager.currentDate, style: .date)
                    .font(.title2)
                    .bold()
                Spacer()
                Button("", systemImage: "arrowshape.right.fill") {
                    withAnimation {
                        changeMonth(by: 1)
                    }
                }
            }
            .padding()

            // Weekday headers
            LazyVGrid(columns: columns) {
                ForEach(manager.calendar.shortWeekdaySymbols, id: \.self) { symbol in
                    Text(symbol).font(.caption).frame(maxWidth: .infinity)
                }
            }

            // Days of the month
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(manager.generateDaysInMonth(), id: \.self) { date in
                    if let date {
                        if Calendar.current.isDate(date, inSameDayAs: Date()) {
                            Button("\(Calendar.current.component(.day, from: date))") {
                                withAnimation { selectedDate = date }
                            }
                                .calendarDayStyle()
                                .background(Color.black)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else if dbManager.allEvents.contains(
                            where: {Calendar.current.isDate(date, inSameDayAs: $0.date)} ) {
                            Button("\(Calendar.current.component(.day, from: date))") {
                                withAnimation { selectedDate = date }
                            }
                                .calendarDayStyle()
                                .background(Color.gray.opacity(0.8))
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            Button("\(Calendar.current.component(.day, from: date))") {
                                withAnimation { selectedDate = date }
                            }
                                .calendarDayStyle()
                                .background(Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    } else {
                        Text(" ") .calendarDayStyle()
                    }
                }
            }
            Text("Events on \(selectedDate, format: .dateTime.day().month().year())")
                .font(.title2)
                .bold()
                .padding()
            ScrollView {
                let eventsForSelectedDate = dbManager.allEvents.filter {
                    Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
                }
                
                if eventsForSelectedDate.isEmpty {
                    VStack {
                        Text("No events on this day")
                            .foregroundColor(.gray)
                            .padding()
                    }
                } else {
                    ForEach(eventsForSelectedDate) { event in
                        EventSummaryView(event: event)
                            .padding(.horizontal)
                            .padding(.top)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            dbManager.fetchAllEvents()
        }
    }
    
    private func changeMonth(by value: Int) {
        guard let newDate = Calendar.current.date(byAdding: .month, value: value, to: manager.currentDate) else { return }
        manager.currentDate = newDate
    }
}

extension View {
    func calendarDayStyle() -> some View {
        self
            .frame(maxWidth: .infinity, minHeight: 40)
    }
}

#Preview {
    CalendarEventView()
}
