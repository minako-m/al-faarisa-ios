//
//  OrganizerEventsView.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 31.05.2025.
//
// citation: made a custom list row view with https://stackoverflow.com/questions/58333499/swiftui-navigationlink-hide-arrow

import SwiftUI
import MapKit

enum SortOption: CaseIterable {
    case upcoming
    case past
    case all
    
    var title: String {
        switch self {
        case .upcoming: return "Upcoming"
        case .past: return "Past"
        case .all: return "All Events"
        }
    }
}

struct OrganizerEventsView: View {
    @StateObject private var session = UserSession.shared
    @StateObject private var dbManager = DatabaseManager.shared
    
    @State private var filter: SortOption = .all
    @State private var selection: Event?
    @State private var allEvents: [Event] = []
    @State private var showEventEditor: Bool = false
    @State private var eventToEdit: Event = Event(name: "Empty Event", description: "", date: .now, levels: [], capacity: 0)
    
    let emptyEvent = Event(name: "Empty Event", description: "", date: .now, levels: [], capacity: 0)
    
    var events: [Event] {
        switch filter {
        case .all:
            return dbManager.allEvents
        case .upcoming:
            return dbManager.allEvents.filter { $0.date >= .now }
        case .past:
            return dbManager.allEvents.filter { $0.date < .now }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            Picker("Filter", selection: $filter.animation(.default)) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Text(option.title)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            List {
                ForEach(events.sorted(by: { $0.date > $1.date })) { event in
                    ZStack {
                        EventSummaryView(event: event)
                            .padding(.top)
                            .padding(.horizontal)
                        NavigationLink(destination: EventView(event: event)) {}
                            .opacity(0)
                    }
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                    .listRowBackground(EmptyView())
                }
                .onDelete(perform: delete)
            }
            .listStyle(.plain)
            .navigationTitle("Club Events")
            .toolbar {
                addEventButton()
                EditButton()
            }
        } detail: {
            Text("Choose an event!")
        }
        .onAppear {
            dbManager.startListeningToAllEvents()
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let eventToDelete = events.sorted(by: { $0.date > $1.date })[index]
            dbManager.deleteEvent(eventToDelete)
        }
    }
    
    func addEventButton() -> some View {
        Button("Add Game", systemImage: "plus") {
            eventToEdit = Event(name: "Event Name", description: "Description", date: .now, levels: [], capacity: 10)
            showEventEditor = true
        }
        .sheet(isPresented: $showEventEditor) {
            NavigationStack {
                EventEditor(event: $eventToEdit)
                    .toolbar {
                        Button("Cancel") {
                            showEventEditor = false
                            self.eventToEdit = emptyEvent
                        }
                        Button("Save") {
                            dbManager.saveEvent(eventToEdit)
                            self.eventToEdit = emptyEvent
                            showEventEditor = false
                        }
                    }
            }
        }
    }
}
//
//#Preview {
//    OrganizerEventsView()
//}
