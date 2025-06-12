//
//  OrganizerHomeView.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 31.05.2025.
//

import SwiftUI
import MapKit


struct OrganizerHomeView: View {
    let clubCoordinate = CLLocationCoordinate2D(latitude: 52.93592, longitude: 70.18895)
    @StateObject private var session = UserSession.shared
    @StateObject private var db = DatabaseManager.shared
    @State private var showEditor: Bool = false
    @State private var newClubInfo = ClubInfo(
        name: "Al-Faarisa",
        description: "Women's horse riding club in Astana. A community of strong, empowered women. With us, your life changes and feels brighter🌟",
        addressName: "Recreational Area Ayaulym, Qoyandi, Astana, Kazakhstan",
        instagramURL: "https://www.instagram.com/al_faarisa/"
    )
    
    var body: some View {
        GeometryReader { geometry in
            let screenHeight = geometry.size.height
            let imageHeight = screenHeight / 3

            ZStack(alignment: .top) {
                Image("Al_Faarisa_Home_View")
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(3.5, contentMode: .fit)
                    .clipped()
                    .edgesIgnoringSafeArea(.top)

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Spacer to start content after the image
                        Color.clear.frame(height: imageHeight - 30)

                        // Main Info
                        VStack (alignment: .leading, spacing: 20) {
                            HStack {
                                Text(db.clubInfo.name)
                                    .titleTextStyle()
                                    .padding()
                                    .background(.white)
                                    .cornerRadius(20)
                                    .padding(.top)
                                Spacer()
                                Button(action: openInstagram) {
                                    Image("instagram-logo")
                                        .resizable()
                                        .aspectRatio(1, contentMode: .fit)
                                        .shadow(radius: 4)
                                        .frame(maxHeight: 70)
                                        .padding()
                                }
                            }
                            VStack(alignment: .leading) {
                                Text("Description")
                                    .font(.headline)
                                Text(db.clubInfo.description)
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                            .background(.white)
                            .cornerRadius(20)
                            
                            VStack(alignment: .leading) {
                                Text("Address")
                                    .font(.headline)
                                Text(db.clubInfo.addressName)
                                    .font(.body)
                                    .foregroundColor(.gray)
                                Map {
                                    Marker("Horse Riding", coordinate: clubCoordinate)
                                        .tint(.red)
                                }
                                .mapControlVisibility(.hidden)
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(30)
                            }
                            .padding(.horizontal)
                            .background(.white)
                            .cornerRadius(20)
                            
                            Button("Open in Apple Maps") {
                                openAppleMaps()
                            }
                            .buttonTextStyle()
                            .padding()
                            
                            if session.userRole == "Organizer" {
                                editButton()
                            }
                            signOutButton()
                        }
                        .background(.white)
                        .opacity(1)
                        .cornerRadius(30)
                    }
                }
            }
        }
    }
    
    func editButton() -> some View {
        Button(action: {
            showEditor = true
            newClubInfo = db.clubInfo
        }) {
            Label("Edit", systemImage: "square.and.pencil")
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.top)
        }
        .sheet(isPresented: $showEditor) {
            NavigationStack {
                ClubInfoEditor(clubInfo: $newClubInfo)
                    .toolbar {
                        Button("Cancel") {
                            showEditor = false
                        }
                        Button("Save") {
                            db.saveClubInfo(newClubInfo)
                            db.fetchClubInfo()
                            showEditor = false
                        }
                    }
            }
        }
    }
    
    func openAppleMaps() {
        let placemark = MKPlacemark(coordinate: clubCoordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Zhety Qazyna Recreational Area"
        mapItem.openInMaps(launchOptions: nil)
    }
        
    func signOutButton() -> some View {
        Button(action: {
            session.signOut()
        }) {
            Label("Sign Out", systemImage: "iphone.and.arrow.forward.outward")
                .font(.subheadline)
                .foregroundColor(.red)
                .padding()
        }
    }
    
    func openInstagram() {
        if let url = URL(string: db.clubInfo.instagramURL) {
            UIApplication.shared.open(url)
        }
    }
}


#Preview {
    OrganizerHomeView()
}
