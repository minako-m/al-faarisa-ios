//
//  MemberEventsView.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 03.06.2025.
//

import SwiftUI

enum MemberSortOption: CaseIterable {
    case mine
    case all
    
    var title: String {
        switch self {
        case .all: return "All Events"
        case .mine: return "My Events"
        }
    }
}

struct MemberEventsView: View {
    @State private var filter: MemberSortOption = .all
    @State private var allEvents: [Event] = []
    
    @StateObject private var session = UserSession.shared
    @StateObject private var dbManager = DatabaseManager.shared
    
    var events: [Event] {
        switch filter {
        case .all:
            return dbManager.allEvents
        case .mine:
            if session.user != nil {
                return dbManager.allEvents.filter { $0.attendees.contains(session.getUserInfo()) }
            }
            return dbManager.allEvents
        }
    }
    
    var body: some View {
        NavigationSplitView {
            Picker("Filter", selection: $filter.animation(.default)) {
                ForEach(MemberSortOption.allCases, id: \.self) { option in
                    Text(option.title)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            List {
                ForEach(events.sorted(by: { $0.date > $1.date }), id: \.id) { event in
                    ZStack {
                        EventSummaryView(event: event)
                            .padding(.top)
                            .padding(.horizontal)
                            .onAppear {
                                dbManager.fetchAllEvents()
                            }
                        NavigationLink(destination: MemberEventView(eventID: event.id)) {}
                            .opacity(0)
                    }
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                    .listRowBackground(EmptyView())
                }
            }
            .onAppear {
                dbManager.startListeningToAllEvents()
            }
            .listStyle(.plain)
            .navigationTitle("Club Events")
        } detail: {
            Text("Choose an event!")
        }
    }
}

//#Preview {
//    MemberEventsView()
//}
