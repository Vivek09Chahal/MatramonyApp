//
//  likeDataModel.swift
//  Matramony
//
//  Created by Vivek on 6/8/25.
//

import SwiftUI
import Combine

// MARK: - User Profile Model
struct UserProfile: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let age: Int
    let location: String
    let profession: String
    let religion: String
    let profileImageName: String
    
    init(name: String, age: Int, location: String, profession: String, religion: String, profileImageName: String = "person.circle.fill") {
        self.name = name
        self.age = age
        self.location = location
        self.profession = profession
        self.religion = religion
        self.profileImageName = profileImageName
    }
}

// MARK: - Like Status
enum LikeStatus {
    case none
    case liked
    case disliked
    case superLiked
    case matched
}

// MARK: - User Interaction Model
struct UserInteraction {
    let profileId: UUID
    let status: LikeStatus
    let timestamp: Date
    let isMatch: Bool
}

// MARK: - Like Data Manager
@Observable
class LikeDataManager {
    static let shared = LikeDataManager()
    
    // All available profiles
    var allProfiles: [UserProfile] = [
        UserProfile(name: "Priya", age: 25, location: "Mumbai", profession: "Software Engineer", religion: "Hindu"),
        UserProfile(name: "Ravi", age: 28, location: "Delhi", profession: "Doctor", religion: "Hindu"),
        UserProfile(name: "Ananya", age: 24, location: "Bangalore", profession: "Designer", religion: "Hindu"),
        UserProfile(name: "Vikram", age: 30, location: "Chennai", profession: "Business Analyst", religion: "Hindu"),
        UserProfile(name: "Meera", age: 26, location: "Pune", profession: "Teacher", religion: "Hindu"),
        UserProfile(name: "Kavya", age: 27, location: "Hyderabad", profession: "Marketing Manager", religion: "Hindu"),
        UserProfile(name: "Arjun", age: 29, location: "Kolkata", profession: "Architect", religion: "Hindu"),
        UserProfile(name: "Shreya", age: 23, location: "Jaipur", profession: "Lawyer", religion: "Hindu"),
        UserProfile(name: "Rohit", age: 31, location: "Gurgaon", profession: "Data Scientist", religion: "Hindu"),
        UserProfile(name: "Divya", age: 25, location: "Kochi", profession: "Nurse", religion: "Hindu")
    ]
    
    // User interactions
    var userInteractions: [UUID: UserInteraction] = [:]
    
    // Profiles that liked the current user (simulated)
    var profilesWhoLikedMe: Set<UUID> = []
    
    private init() {
        // Simulate some profiles liking the current user
        let randomProfiles = allProfiles.shuffled().prefix(4)
        profilesWhoLikedMe = Set(randomProfiles.map { $0.id })
    }
    
    // MARK: - Like Actions
    func likeProfile(_ profile: UserProfile) {
        let isMatch = profilesWhoLikedMe.contains(profile.id)
        let interaction = UserInteraction(
            profileId: profile.id,
            status: isMatch ? .matched : .liked,
            timestamp: Date(),
            isMatch: isMatch
        )
        userInteractions[profile.id] = interaction
        
        // If it's a match, remove from profiles who liked me
        if isMatch {
            profilesWhoLikedMe.remove(profile.id)
        }
    }
    
    func dislikeProfile(_ profile: UserProfile) {
        let interaction = UserInteraction(
            profileId: profile.id,
            status: .disliked,
            timestamp: Date(),
            isMatch: false
        )
        userInteractions[profile.id] = interaction
        profilesWhoLikedMe.remove(profile.id)
    }
    
    func superLikeProfile(_ profile: UserProfile) {
        let isMatch = profilesWhoLikedMe.contains(profile.id)
        var interaction = UserInteraction(
            profileId: profile.id,
            status: isMatch ? .matched : .superLiked,
            timestamp: Date(),
            isMatch: isMatch
        )
        userInteractions[profile.id] = interaction
        
        // Super like increases match probability
        if !isMatch && Bool.random() {
            interaction = UserInteraction(
                profileId: profile.id,
                status: .matched,
                timestamp: Date(),
                isMatch: true
            )
            userInteractions[profile.id] = interaction
        }
        
        if interaction.isMatch {
            profilesWhoLikedMe.remove(profile.id)
        }
    }
    
    func likeBack(_ profileId: UUID) {
        if allProfiles.first(where: { $0.id == profileId }) != nil {
            let interaction = UserInteraction(
                profileId: profileId,
                status: .matched,
                timestamp: Date(),
                isMatch: true
            )
            userInteractions[profileId] = interaction
            profilesWhoLikedMe.remove(profileId)
        }
    }
    
    // MARK: - Data Getters
    var likedProfiles: [UserProfile] {
        allProfiles.filter { profile in
            if let interaction = userInteractions[profile.id] {
                return interaction.status == .liked || interaction.status == .superLiked || interaction.status == .matched
            }
            return false
        }
    }
    
    var matchedProfiles: [UserProfile] {
        allProfiles.filter { profile in
            if let interaction = userInteractions[profile.id] {
                return interaction.status == .matched
            }
            return false
        }
    }
    
    var profilesWhoLikedMeList: [UserProfile] {
        allProfiles.filter { profilesWhoLikedMe.contains($0.id) }
    }
    
    var unviewedProfiles: [UserProfile] {
        allProfiles.filter { userInteractions[$0.id] == nil }
    }
    
    func getLikeStatus(for profileId: UUID) -> LikeStatus {
        return userInteractions[profileId]?.status ?? .none
    }
    
    func isMatch(for profileId: UUID) -> Bool {
        return userInteractions[profileId]?.isMatch ?? false
    }
    
    func getTimestamp(for profileId: UUID) -> Date? {
        return userInteractions[profileId]?.timestamp
    }
}
