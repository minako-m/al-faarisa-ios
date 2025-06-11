//
//  EventSummaryView.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 01.06.2025.
//

import SwiftUI

enum Level: String, CaseIterable, Identifiable, Equatable, Codable {
    case beginner
    case intermediate
    case advanced

    var id: String { self.rawValue }

    var displayName: String {
        switch self {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        }
    }
}

struct EventSummaryView: View {
    var event: Event
    
    var body: some View {
        HStack(spacing: 20) {
            Text(event.icon)
                .font(.largeTitle)
                .foregroundColor(.white)
                .aspectRatio(1, contentMode: .fit)
            
            VStack (alignment: .leading) {
                Text(event.name)
                    .font(.headline)
                Text(event.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
                Text("Levels: \(event.levels.map { $0.rawValue }.joined(separator: ", "))")
                    .font(.subheadline)
                Text("\(event.attendees.count) / \(event.capacity) seats taken")  // capacity
                    .font(.subheadline)
            }
        }
        .padding()
        .padding(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.white)
                .shadow(radius: 1)
        )
    }
}

//#Preview {
//    EventSummaryView()
//}
