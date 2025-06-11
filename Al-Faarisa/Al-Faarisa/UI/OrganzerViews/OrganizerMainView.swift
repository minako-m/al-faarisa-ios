//
//  MainAppView.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 31.05.2025.
//

import SwiftUI

struct OrganizerMainView: View {
    @StateObject private var session = UserSession.shared
    
    var body: some View {
        TabView {
            OrganizerHomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            OrganizerEventsView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Events")
                }
            OrganizerAnalyticsView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Engagement")
                }
        }
        .tint(.black)
    }
}

#Preview {
    OrganizerMainView()
}
