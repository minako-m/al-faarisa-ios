//
//  EventEditor.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 01.06.2025.
//

import SwiftUI

struct EventEditor: View {
    @Binding var event: Event
    @State private var capacityText: String = ""
    
    var body: some View {
        VStack {
            Form {
                Section("Event Details") {
                    TextField("Add name", text: $event.name)
                    TextField("Add description", text: $event.description)
                    TextField("Add icon (emoji)", text: $event.icon)
                }
                Section("Capacity") {
                    Stepper(value: $event.capacity, in: 0...1000) {
                        Text("Capacity: \(event.capacity)")
                    }
                }
                Section("Select Date & Time") {
                    DatePicker(
                        "Event Date",
                        selection: $event.date,
                        in: Date()...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
                Section(header: Text("Select Event Levels")) {
                    ForEach(Level.allCases) { level in
                        Toggle(isOn: Binding(
                            get: {
                                event.levels.contains(level)
                            },
                            set: { isSelected in
                                if isSelected {
                                    if !event.levels.contains(level) {
                                        event.levels.append(level)
                                    }
                                } else {
                                    event.levels.removeAll { $0 == level }
                                }
                            }
                        )) {
                            Text(level.displayName)
                        }
                    }
                }
            }
            .onAppear {
                capacityText = String(event.capacity)
            }
        }
    }
}

//#Preview {
//    EventEditor()
//}
