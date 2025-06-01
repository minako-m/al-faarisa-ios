//
//  OrganizerSignIn.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 31.05.2025.
//

import SwiftUI


struct OrganizerSignIn: View {
    @StateObject private var session = UserSession.shared
    @State var email: String = ""
    @State var password: String = ""
    @State var errorMessage: String = ""
    
    var body: some View {
        VStack {
            Text("Organizer Sign In")
                .subtitleTextStyle()
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .frame(maxWidth: .infinity)
            
            Divider()

            SecureField("Password", text: $password)
                .padding()
                .frame(maxWidth: .infinity)
            
            Divider()
            
            Button(action: {
                signIn()
            }) {
                Text("Sign In")
                    .buttonTextStyle()
            }
            .padding(.vertical)
            
            Text(errorMessage)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
        }
        .ignoresSafeArea(.keyboard)
        .padding(.horizontal)
    }
    
    func signIn() {
        session.signIn(email: email, password: password) { result in
            switch result {
            case .success(()):
                break
            case .failure(let error):
                withAnimation {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

//#Preview {
//    OrganizerSignIn()
//}
