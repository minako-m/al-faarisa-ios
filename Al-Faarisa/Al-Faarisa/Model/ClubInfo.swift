//
//  ClubInfo.swift
//  Al-Faarisa
//
//  Created by Amira Mahmedjan on 11.06.2025.
//

import Foundation
import Firebase
import FirebaseFirestore

struct ClubInfo: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var description: String
    var addressName: String
    var instagramURL: String
}
