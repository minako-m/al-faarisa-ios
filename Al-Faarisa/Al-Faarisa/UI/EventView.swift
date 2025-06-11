//
//  EventView.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 01.06.2025.
//

import SwiftUI


struct EventView: View {
    @StateObject private var session = UserSession.shared
    var event: Event
    
    var body: some View {
        GeometryReader { geometry in
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
                            
                        }
                        .background(.white)
                        .opacity(1)
                        .cornerRadius(30)
                    }
                }
            }
        }
    }
}

//#Preview {
//    EventView()
//}
