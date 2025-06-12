//
//  SignUpView.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 04.06.2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

enum UserRole: String, CaseIterable {
    case organizer
    case member
    
    var title: String {
        switch self {
        case .organizer: return "Organizer"
        case .member: return "Member"
        }
    }
}

struct SignUpView: View {
    @StateObject private var session = UserSession.shared
    @State var email: String = ""
    @State var password: String = ""
    @State var errorMessage: String = ""
    @State var role: UserRole = .member
    @State var confirmationCode: String = ""
    
    var body: some View {
        VStack {
            Text("Create an Account")
                .subtitleTextStyle()
            
            Picker("Filter", selection: $role.animation(.default)) {
                ForEach(UserRole.allCases, id: \.self) { option in
                    Text(option.title)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
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
            
            if role == .organizer {
                Text("Please enter your confirmation code that you should have received from another organizer:")
                    .padding()
                TextField("Confirmation Code", text: $confirmationCode)
                    .autocapitalization(.allCharacters)
                    .padding()
                    .frame(maxWidth: .infinity)
                Divider()
            }
            
            Button(action: {
                signUp()
            }) {
                Text("Sign Up")
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
    
    func signUp() {
        if role == .organizer, confirmationCode != "ABCD" {
            withAnimation {
                errorMessage = "The organizer confirmation code is incorrect"
            }
            return
        }
        
        session.signUp(email: email, password: password, role: role.title) { result in
            switch result {
            case .success(()):
                session.loadUserRole()
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
//    SignUpView()
//}
