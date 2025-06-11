//
//  Al_FaarisaView.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 31.05.2025.
//

import SwiftUI

struct Al_FaarisaView: View {
    @StateObject private var session = UserSession.shared

    var body: some View {
        if session.user != nil {
            if session.userRole == "Member" {
                MemberMainView()
            } else {
                OrganizerMainView()
            }
        } else {
            SignInView()
        }
    }
}

#Preview {
    Al_FaarisaView()
}
