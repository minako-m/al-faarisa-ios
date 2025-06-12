//
//  Event.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 01.06.2025.
//

import Foundation
import FirebaseAuth
import EventKit
import FirebaseFirestore

struct Event: Identifiable, Equatable, Codable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.icon == rhs.icon &&
               lhs.name == rhs.name &&
               lhs.description == rhs.description &&
               lhs.date == rhs.date &&
               lhs.levels == rhs.levels &&
               lhs.capacity == rhs.capacity &&
               lhs.attendees == rhs.attendees
    }
    
    //@DocumentID var id: String?
    var id: String = UUID().uuidString
    var icon: String
    var name: String
    var description: String
    var date: Date
    var levels: [Level]
    var capacity: Int
    var attendees: [UserInfo] = []
    
    init(
        icon: String = "🐎",
        name: String,
        description: String,
        date: Date,
        levels: [Level],
        capacity: Int,
        attendees: [UserInfo] = []
    ) {
        self.icon = icon
        self.name = name
        self.date = date
        self.description = description
        self.levels = levels
        self.capacity = capacity
        self.attendees = attendees
    }
    
    // Firestore encoding
    func toFirestoreData() throws -> [String: Any] {
        try Firestore.Encoder().encode(self)
    }

    // Firestore decoding
    static func from(_ document: DocumentSnapshot) throws -> Event {
        var event = try document.data(as: Event.self)
        event.id = document.documentID
        return event
    }
    
    func isSignedUp(_ user: UserInfo) -> Bool {
        attendees.contains(user)
    }

    func isAtCapacity() -> Bool {
        attendees.count >= capacity
    }
}
