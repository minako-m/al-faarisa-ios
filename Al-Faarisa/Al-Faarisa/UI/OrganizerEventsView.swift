//
//  OrganizerEventsView.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 31.05.2025.
//

import SwiftUI
import MapKit

struct OrganizerEventsView: View {
    let bayterekCoordinate = CLLocationCoordinate2D(latitude: 51.1280, longitude: 71.4304)
    
    var body: some View {
        Map {
            Marker("Horse Riding", coordinate: bayterekCoordinate)
                .tint(.red)
        }
        .mapControlVisibility(.hidden)
    }
}

#Preview {
    OrganizerEventsView()
}
