//
//  MemberMainView.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 03.06.2025.
//

import SwiftUI

struct MemberMainView: View {
    @StateObject private var session = UserSession.shared
    
    var body: some View {
        TabView {
            OrganizerHomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            MemberEventsView()
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text("Events")
                }
            CalendarEventView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
        }
        .tint(.black)
    }
}

#Preview {
    MemberMainView()
}
