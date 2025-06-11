//
//  DatabaseManager.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 10.06.2025.
//

import Foundation
import Firebase
import FirebaseFirestore


class DatabaseManager: ObservableObject {
    static let shared = DatabaseManager()
    private let db = Firestore.firestore()
    private var allEventsListener: ListenerRegistration?
    private var singleEventListener: ListenerRegistration?
    
    @Published var allEvents: [Event] = []

    private init() {}

    func saveEvent(_ event: Event, completion: ((Error?) -> Void)? = nil) {
        let db = Firestore.firestore()
        
        do {
            try db.collection("events").document(event.id).setData(from: event) { error in
                if let error = error {
                    print("Error saving event: \(error.localizedDescription)")
                    completion?(error)
                } else {
                    print("Event saved successfully with id: \(event.id)")
                    completion?(nil)
                }
            }
        } catch {
            print("Error encoding event: \(error.localizedDescription)")
            completion?(error)
        }
    }

    func startListeningToAllEvents() {
        guard allEventsListener == nil else { return } // prevent duplicates

        allEventsListener = db.collection("events").addSnapshotListener { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            let events = docs.compactMap { try? $0.data(as: Event.self) }
            DispatchQueue.main.async {
                self.allEvents = events
            }
        }
    }

    func stopListeningToAllEvents() {
        allEventsListener?.remove()
        allEventsListener = nil
    }
    
    func listenToSingleEvent(id: String, completion: @escaping (Event) -> Void) {
        db.collection("events").document(id).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot,
                  let event = try? snapshot.data(as: Event.self) else {
                return
            }
            completion(event)
        }
    }

    // Call this to stop listening to the single event (e.g., when view disappears).
    func stopListeningToSingleEvent() {
        singleEventListener?.remove()
        singleEventListener = nil
    }
    
    func addAttendee(to eventID: String, user: UserInfo, completion: ((Error?) -> Void)? = nil) {
        let eventRef = db.collection("events").document(eventID)
        
        // Add user to attendees array using arrayUnion to avoid duplicates on Firestore side
        do {
            let userData = try Firestore.Encoder().encode(user)
            
            eventRef.updateData([
                "attendees": FieldValue.arrayUnion([userData])
            ]) { error in
                if let error = error {
                    print("Failed to add attendee: \(error)")
                }
                completion?(error)
            }
        } catch {
            print("Encoding error adding attendee: \(error)")
            completion?(error)
        }
    }
    
    func removeAttendee(from eventID: String, user: UserInfo, completion: ((Error?) -> Void)? = nil) {
        let eventRef = db.collection("events").document(eventID)
        
        eventRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching event to remove attendee: \(error)")
                completion?(error)
                return
            }
            guard let snapshot = snapshot,
                  var event = try? snapshot.data(as: Event.self) else {
                print("Event not found or failed to decode")
                completion?(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Event not found or decode failed"]))
                return
            }
            
            // Remove the user from attendees array
            event.attendees.removeAll { $0 == user }
            
            // Save the updated attendees array back to Firestore
            do {
                let updatedAttendeesData = try event.attendees.map {
                    try Firestore.Encoder().encode($0)
                }
                eventRef.updateData([
                    "attendees": updatedAttendeesData
                ]) { error in
                    if let error = error {
                        print("Failed to remove attendee: \(error)")
                    }
                    completion?(error)
                }
            } catch {
                print("Encoding error removing attendee: \(error)")
                completion?(error)
            }
        }
    }

    func fetchAllEvents() {
        db.collection("events").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching events: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No event documents found")
                return
            }
            
            let events = documents.compactMap { doc -> Event? in
                try? doc.data(as: Event.self)
            }
            
            DispatchQueue.main.async {
                self.allEvents = events
            }
        }
    }
}
