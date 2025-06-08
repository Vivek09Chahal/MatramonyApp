//
//  Item.swift
//  Matramony
//
//  Created by Vivek on 6/7/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class User {
    var id = UUID().uuidString
    var profileImage: Data? // Store as image name or URL
    var name: String
    var age: Int
    var gender: Gender
    var caste: String
    var religion: String
    var about: String
    var email: String
    var phoneNumber: Int
    var password: String // Store hashed password
    
    init(profileImage: Data?, name: String = "", age: Int = 0, gender: Gender = .male, caste: String = "", religion: String = "", about: String = "", email: String = "", phoneNumber: Int = 0, password: String = "") {
        self.profileImage = profileImage
        self.name = name
        self.age = age
        self.gender = gender
        self.caste = caste
        self.religion = religion
        self.about = about
        self.email = email
        self.phoneNumber = phoneNumber
        self.password = password
    }
}

enum Gender: String, CaseIterable, Codable{
    case male = "Male"
    case female = "Female"
    case other = "Other"
}
