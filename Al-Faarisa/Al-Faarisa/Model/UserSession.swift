//
//  UserSession.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 31.05.2025.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

struct UserInfo: Codable, Identifiable, Equatable {
    var id: String   // user.uid
    var name: String // displayName or email
}

class UserSession: ObservableObject {
    static let shared = UserSession()
    
    @Published var user: User?
    @Published var userRole: String? = nil
    
    func loadUserRole() {
        fetchUserRole { role in
            DispatchQueue.main.async {
                self.userRole = role
            }
        }
    }
    
    func signUp(email: String, password: String, role: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            self.user = authResult?.user
            
            guard let uid = authResult?.user.uid else {
                completion(.failure(NSError(domain: "SignUpError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve user UID."])))
                return
            }

            let userData: [String: Any] = [
                "email": email,
                "role": role,
                "createdAt": Timestamp()
            ]

            Firestore.firestore().collection("users").document(uid).setData(userData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.user = authResult?.user
                completion(.success(()))
            }
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            user = nil
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    func fetchUserRole(completion: @escaping (String?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        Firestore.firestore().collection("users").document(uid).getDocument { doc, error in
            if let role = doc?.data()?["role"] as? String {
                completion(role)  // "organizer" or "member"
            } else {
                completion(nil)
            }
        }
    }
    
    func getUserInfo() -> UserInfo {
        var userInfo = UserInfo(id: "", name: "")
        if let user = self.user {
            userInfo = UserInfo(id: user.uid, name: user.displayName ?? "User has no name")
        }
        return userInfo
    }
}
