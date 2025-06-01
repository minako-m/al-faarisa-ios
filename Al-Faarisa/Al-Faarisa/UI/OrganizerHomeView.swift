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
                        VStack {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Al-Faarisa")
                                    .titleTextStyle()
                                Text("Description")
                                    .font(.subheadline)
                                Text("Женский клуб верховой езды❤️‍🔥| Астана Сообщество свободных, смелых и сильных девушек с нами жизнь меняется и чувствуется ярче💥")
                                    .font(.body)
                                    .foregroundColor(.gray)
                                Text("Address")
                                    .font(.subheadline)
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
                            .padding()
                            .padding(.top)
                            .background(Color.white)
                            .cornerRadius(20)
                            
//                            VStack {
//                                Map {
//                                    Marker("Horse Riding", coordinate: bayterekCoordinate)
//                                        .tint(.red)
//                                }
//                                .mapControlVisibility(.hidden)
//                                .aspectRatio(5, contentMode: .fit)
//                            }
//                            .aspectRatio(5, contentMode: .fit)
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


#Preview {
    OrganizerHomeView()
}
