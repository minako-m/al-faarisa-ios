//
//  ContentView.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 31.05.2025.
//

import SwiftUI


struct SignInView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Al-Faarisa")
                    .titleTextStyle()
                NavigationLink(destination: OrganizerSignIn()) {
                    Text("Organizer Sign In")
                        .buttonTextStyle()
                }
                NavigationLink(destination: OrganizerSignIn()) {
                    Text("Member Sign In")
                        .buttonTextStyle()
                }
                HStack(spacing: 0) {
                    Text("Don't have an account yet? Sign up ")
                        .foregroundColor(.gray)
                    NavigationLink(destination: SignUpView()) {
                        Text("here")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                    }
                }
                .padding(.vertical)
            }
            .padding()
        }
        .tint(.black)
    }
}

extension View {
    func buttonTextStyle() -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(30)
    }
    func titleTextStyle() -> some View {
        self
            .font(.custom("BodoniSvtyTwoITCTT-Bold", size: 50))
            .fontWeight(.bold)
            .font(.title)
    }
    func subtitleTextStyle() -> some View {
        self
            .font(.custom("BodoniSvtyTwoITCTT-Bold", size: 30))
            .font(.title)
    }
}

#Preview {
    SignInView()
}
