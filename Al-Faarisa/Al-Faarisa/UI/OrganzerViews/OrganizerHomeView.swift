//
//  OrganizerHomeView.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 31.05.2025.
//

import SwiftUI
import MapKit


struct OrganizerHomeView: View {
    let bayterekCoordinate = CLLocationCoordinate2D(latitude: 51.1280, longitude: 71.4304)
    @StateObject private var session = UserSession.shared
    
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
                        Color.clear.frame(height: imageHeight - 50)

                        // Main Info
                        VStack (alignment: .leading, spacing: 20) {
                            HStack {
                                Text("Al-Faarisa")
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
                                Text("Women's horse riding club in Astana. A community of strong, empowered women. With us, your life changes and feels brighter🌟")
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                            .background(.white)
                            .cornerRadius(20)
                            
                            VStack(alignment: .leading) {
                                Text("Address")
                                    .font(.headline)
                                Text("Recreational Area Ayaulym, Qoyandi, Astana, Kazakhstan")
                                    .font(.body)
                                    .foregroundColor(.gray)
                                Map {
                                    Marker("Horse Riding", coordinate: bayterekCoordinate)
                                        .tint(.red)
                                }
                                .mapControlVisibility(.hidden)
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(30)
                            }
                            .padding(.horizontal)
                            .background(.white)
                            .cornerRadius(20)
                            
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
        if let url = URL(string: "https://www.instagram.com/al_faarisa/") {
            UIApplication.shared.open(url)
        }
    }
}


#Preview {
    OrganizerHomeView()
}
