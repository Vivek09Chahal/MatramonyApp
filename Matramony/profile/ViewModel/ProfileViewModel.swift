//
//  profileViewModel.swift
//  Matramony
//
//  Created by Vivek on 6/7/25.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class ProfileViewModel{
    
    var currentUser: User?
    
    private var modelContext: ModelContext?
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        loadProfile()
    }
    
    func loadProfile() {
        guard let modelContext = modelContext else { return }
        do {
            let users = try modelContext.fetch(FetchDescriptor<User>())
            currentUser = users.first
        } catch {
            print("Failed to load profile: \(error)")
        }
    }
    
    func createProfile(
        profileImage: Data?,
        name: String,
        age: Int,
        gender: Gender,
        caste: String,
        religion: String,
        about: String,
        email: String,
        phoneNumber: Int,
        password: String = ""
    ) {
        guard let modelContext = modelContext else { return }
        
        let newUser = User(
            profileImage: profileImage,
            name: name,
            age: age,
            gender: gender,
            caste: caste,
            religion: religion,
            about: about,
            email: email,
            phoneNumber: phoneNumber,
            password: password
        )
        
        modelContext.insert(newUser)
        currentUser = newUser
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save profile: \(error)")
        }
    }
    
    func updateProfile(
        profileImage: Data?,
        name: String,
        age: Int,
        gender: Gender,
        caste: String,
        religion: String,
        about: String,
        email: String,
        phoneNumber: Int
        
    ) {
        guard let modelContext = modelContext else { return }
        
        if let currentUser = currentUser {
            // Update existing user
            currentUser.profileImage = profileImage
            currentUser.name = name
            currentUser.age = age
            currentUser.gender = gender
            currentUser.caste = caste
            currentUser.religion = religion
            currentUser.about = about
            currentUser.email = email
            currentUser.phoneNumber = phoneNumber
        } else {
            // Create new user if none exists
            createProfile(
                profileImage: profileImage,
                name: name,
                age: age,
                gender: gender,
                caste: caste,
                religion: religion,
                about: about,
                email: email,
                phoneNumber: phoneNumber,
                password: "" // Empty password since this is for profile updates
            )
            return
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to update profile: \(error)")
        }
    }
    
}
