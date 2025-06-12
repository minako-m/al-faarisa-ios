//
//  EventView.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 01.06.2025.
//

import SwiftUI
import Firebase

struct MemberEventView: View {
    @StateObject private var session = UserSession.shared
    @StateObject private var db = DatabaseManager.shared
    
    let eventID: String
    @State private var event: Event?
    
    var body: some View {
        GeometryReader { geometry in
            if let event = event {
                let screenHeight = geometry.size.height
                let imageHeight = screenHeight / 3
                
                ZStack(alignment: .top) {
                    Image("Event_View")
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(3.5, contentMode: .fit)
                        .clipped()
                        .edgesIgnoringSafeArea(.top)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            // Spacer to start content after the image
                            Color.clear.frame(height: imageHeight)
                            
                            // Main Info
                            VStack (spacing: 20) {
                                Text(event.name)
                                    .titleTextStyle()
                                    .padding()
                                    .background(.white)
                                    .cornerRadius(20)
                                    .padding(.top)
                                    .frame(maxWidth: .infinity)
                                
                                VStack {
                                    Text("Description")
                                        .font(.headline)
                                    Text(event.description)
                                        .font(.body)
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal)
                                .background(.white)
                                .cornerRadius(20)
                                .frame(maxWidth: .infinity)
                                
                                VStack {
                                    Text("Date & Time")
                                        .font(.headline)
                                    Text(event.date.formatted(date: .abbreviated, time: .shortened))
                                        .font(.body)
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal)
                                .background(.white)
                                .cornerRadius(20)
                                .frame(maxWidth: .infinity)
                                
                                VStack {
                                    Text("Levels")
                                        .font(.headline)
                                    Text("\(event.levels.map { $0.rawValue }.joined(separator: ", "))")
                                        .font(.body)
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal)
                                .background(.white)
                                .cornerRadius(20)
                                .frame(maxWidth: .infinity)
                                
                                VStack {
                                    Text("Attendees:")
                                        .font(.headline)
                                    ForEach(event.attendees) { attendee in
                                        Text(attendee.name)
                                            .font(.callout)
                                    }
                                }
                                .padding(.horizontal)
                                .background(.white)
                                .cornerRadius(20)
                                .frame(maxWidth: .infinity)
                                
                                
                                if session.user != nil {
                                    if event.isSignedUp(session.getUserInfo()) {
                                        Text("You are signed up")
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.black)
                                            .foregroundColor(.white)
                                            .cornerRadius(30)
                                            .opacity(0.5)
                                        
                                        Button("Drop My Spot") {
                                            withAnimation {
                                                db.removeAttendee(from: eventID, user: session.getUserInfo())
                                            }
                                        }
                                        .buttonTextStyle()
                                    } else if event.isAtCapacity() {
                                        Text("This event is full")
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.black)
                                            .foregroundColor(.white)
                                            .cornerRadius(30)
                                            .opacity(0.5)
                                    } else {
                                        Button("Sign Up") {
                                            withAnimation {
                                                db.addAttendee(to: eventID, user: session.getUserInfo())
                                            }
                                        }
                                        .buttonTextStyle()
                                    }
                                }
                            }
                            .padding()
                            .background(.white)
                            .opacity(1)
                            .cornerRadius(30)
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            db.listenToSingleEvent(id: eventID) { updated in
                self.event = updated
            }
        }
        .onDisappear {
            db.stopListeningToSingleEvent()
        }
    }
}

//#Preview {
//    EventView()
//}
