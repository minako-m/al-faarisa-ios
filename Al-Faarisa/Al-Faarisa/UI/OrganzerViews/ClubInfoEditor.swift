//
//  ClubInfoEditor.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 11.06.2025.
//

import SwiftUI

struct ClubInfoEditor: View {
    @Binding var clubInfo: ClubInfo
    @State private var instagramHandle: String = ""
    
    var body: some View {
        VStack {
            Form {
                Section("Club name") {
                    TextField("Add name", text: $clubInfo.name)
                }
                Section("Club description") {
                    TextField("Add description", text: $clubInfo.description)
                }
                Section("Club address") {
                    TextField("Add address", text: $clubInfo.addressName)
                }
                Section("Instagram") {
                    TextField("Add instagram handle", text: $instagramHandle)
                        .onSubmit {
                            clubInfo.instagramURL = "https://www.instagram.com/\(instagramHandle)/"
                        }
                }
            }
        }
    }
}
//
//#Preview {
//    ClubInfoEditor()
//}
