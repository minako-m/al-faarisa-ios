//
//  DatabaseManager.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan using ChatGPT on 10.06.2025.
//  Most methods except SignIn, SignOut, and SignUp were generated with help of chatGPT.
//  The other three were taken from Firebase documentation
//  The prompts are as follows:
//  init(), fetchClubInfo(), saveClubInfo(): "Fetch club info struct from Firebase or save the default value if not present"

//  saveEvent(): make a function that saves an Event struct {pasted Event} into a new collection in Firestore

//  startListeningToAllEvents, stopListeningToAllEvents,listenToSingleEvent, stopListeningToSingleEvent:
//  "make funcitons that listen to updates in the database within events collection (or a single event),
//  and update the published var allEvents respectively. These functions will be called at each view that uses allEvents


//  addAttendee, removeAttendee: make funcitons that remove and add an attendee to a single event specified by its UID in firestore.
//  The attendees information are saved with {uid, name} type of struct.

//  deleteEvent: make a function that deletes an entry in events collection with a given eventID.

//  fetchAllEvents: make a function that fetches all entries in the events collection in Firestore and updates the allEvents
//  published var respectively.

import Foundation
import Firebase
import FirebaseFirestore


class DatabaseManager: ObservableObject {
    static let shared = DatabaseManager()
    private let db = Firestore.firestore()
    private var allEventsListener: ListenerRegistration?
    private var singleEventListener: ListenerRegistration?
    
    @Published var allEvents: [Event] = []
    @Published var clubInfo: ClubInfo

    private init() {
        self.clubInfo = ClubInfo(
            name: "Al-Faarisa",
            description: "Women's horse riding club in Astana. A community of strong, empowered women. With us, your life changes and feels brighter🌟",
            addressName: "Recreational Area Ayaulym, Qoyandi, Astana, Kazakhstan",
            instagramURL: "https://www.instagram.com/al_faarisa/"
        )
        
        // Fetch or save to Firebase
        let docRef = db.collection("clubInfo").document("main")
        docRef.getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            if let document = snapshot, document.exists {
                do {
                    if let data = document.data() {
                        self.clubInfo = try Firestore.Decoder().decode(ClubInfo.self, from: data)
                    }
                } catch {
                    print("Failed to decode club info: \(error)")
                }
            } else {
                // Doesn't exist — save default
                do {
                    let encoded = try Firestore.Encoder().encode(self.clubInfo)
                    docRef.setData(encoded) { error in
                        if let error = error {
                            print("Failed to save default clubInfo: \(error)")
                        }
                    }
                } catch {
                    print("Failed to encode default clubInfo: \(error)")
                }
            }
        }
    }
    
    func fetchClubInfo() {
        let docRef = db.collection("clubInfo").document("main")
        docRef.getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            if let document = snapshot, document.exists {
                do {
                    if let data = document.data() {
                        self.clubInfo = try Firestore.Decoder().decode(ClubInfo.self, from: data)
                    }
                } catch {
                    print("Failed to decode club info: \(error)")
                }
            } else {
                print(error ?? "No document")
            }
        }
    }
    
    func saveClubInfo(_ newInfo: ClubInfo, completion: ((Error?) -> Void)? = nil) {
        let docRef = db.collection("clubInfo").document("main")

        do {
            let encoded = try Firestore.Encoder().encode(newInfo)
            docRef.setData(encoded) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Failed to save club info: \(error)")
                    } else {
                        self.clubInfo = newInfo
                        print("Club info successfully saved.")
                    }
                    completion?(error)
                }
            }
        } catch {
            print("Encoding error while saving club info: \(error)")
            completion?(error)
        }
    }

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
        
        do {
            let userData = try Firestore.Encoder().encode(user)
            
            eventRef.updateData([
                "attendees": FieldValue.arrayUnion([userData])
            ]) { [weak self] error in
                if let error = error {
                    print("Failed to add attendee: \(error)")
                    completion?(error)
                    return
                }
                
                // Update local allEvents array to keep UI in sync
                DispatchQueue.main.async {
                    if let index = self?.allEvents.firstIndex(where: { $0.id == eventID }) {
                        var updatedEvent = self!.allEvents[index]
                        // Avoid duplicate in case UI already updated somehow
                        if !updatedEvent.attendees.contains(user) {
                            updatedEvent.attendees.append(user)
                            self?.allEvents[index] = updatedEvent
                        }
                    }
                }
                
                completion?(nil)
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
    
    func deleteEvent(_ event: Event, completion: ((Error?) -> Void)? = nil) {
        db.collection("events").document(event.id).delete { error in
            if let error = error {
                print("Failed to delete event: \(error)")
            } else {
                // Update local state
                self.allEvents.removeAll { $0.id == event.id }
            }
            completion?(error)
        }
    }
}
