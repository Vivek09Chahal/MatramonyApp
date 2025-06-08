//
//  discoverView.swift
//  Matramony
//
//  Created by Vivek on 6/8/25.
//

import SwiftUI

struct discoverView: View {
    
    @State private var currentCardIndex = 0
    @State private var cardOffset = CGSize.zero
    @State private var cardRotation = 0.0
    @State private var likeManager = LikeDataManager.shared
    
    var availableProfiles: [UserProfile] {
        likeManager.unviewedProfiles
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [.pink.opacity(0.1), .purple.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Discover")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        
                        Text("Find your perfect match")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top)
                    
                    // Card Stack
                    ZStack {
                        ForEach(Array(availableProfiles.enumerated()), id: \.offset) { index, profile in
                            if index >= currentCardIndex && index < currentCardIndex + 3 {
                                ProfileCard(profile: profile)
                                    .scaleEffect(index == currentCardIndex ? 1.0 : 0.95 - Double(index - currentCardIndex) * 0.05)
                                    .offset(
                                        x: index == currentCardIndex ? cardOffset.width : 0,
                                        y: CGFloat(index - currentCardIndex) * 5
                                    )
                                    .rotationEffect(.degrees(index == currentCardIndex ? cardRotation : 0))
                                    .zIndex(Double(availableProfiles.count - index))
                                    .opacity(index == currentCardIndex ? 1.0 : 0.8 - Double(index - currentCardIndex) * 0.2)
                                    .gesture(
                                        index == currentCardIndex ?
                                        DragGesture()
                                            .onChanged { value in
                                                cardOffset = value.translation
                                                cardRotation = Double(value.translation.width / 10)
                                            }
                                            .onEnded { value in
                                                withAnimation(.spring()) {
                                                    if abs(value.translation.width) > 100 {
                                                        // Swipe detected
                                                        if value.translation.width > 0 {
                                                            // Right swipe (like)
                                                            likeProfile()
                                                        } else {
                                                            // Left swipe (pass)
                                                            passProfile()
                                                        }
                                                        nextCard()
                                                    } else {
                                                        // Return to center
                                                        cardOffset = .zero
                                                        cardRotation = 0
                                                    }
                                                }
                                            }
                                        : nil
                                    )
                            }
                        }
                    }
                    .frame(height: 500)
                    
                    if currentCardIndex < availableProfiles.count {
                        // Action Buttons
                        HStack(spacing: 40) {
                            Button {
                                withAnimation(.spring()) {
                                    passProfile()
                                    nextCard()
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .textMofidifier()
                            }
                            
                            Button {
                                withAnimation(.spring()) {
                                    likeProfile()
                                    nextCard()
                                }
                            } label: {
                                Image(systemName: "heart.fill")
                                    .textMofidifier()
                            }
                            
                            Button {
                                // Super like action
                                withAnimation(.spring()) {
                                    superLikeProfile()
                                    nextCard()
                                }
                            } label: {
                                Image(systemName: "star.fill")
                                    .textMofidifier()
                            }
                        }
                    } else {
                        // No more profiles
                        VStack(spacing: 20) {
                            Image(systemName: "heart.circle.fill")
                                .font(.system(size: 80))
                                .foregroundStyle(.pink)
                            
                            Text("No More Profiles")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Check back later for new matches!")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            Button("Restart") {
                                withAnimation(.spring()) {
                                    currentCardIndex = 0
                                    cardOffset = .zero
                                    cardRotation = 0
                                }
                            }
                            .foregroundStyle(.pink)
                            .fontWeight(.semibold)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            .navigationBarHidden(true)
        }
    }
    
    private func nextCard() {
        if currentCardIndex < availableProfiles.count - 1 {
            currentCardIndex += 1
        }
        cardOffset = .zero
        cardRotation = 0
    }
    
    private func likeProfile() {
        guard currentCardIndex < availableProfiles.count else { return }
        let profile = availableProfiles[currentCardIndex]
        likeManager.likeProfile(profile)
        
        // Show match animation if it's a match
        if likeManager.isMatch(for: profile.id) {
            showMatchAnimation(for: profile)
        }
    }
    
    private func passProfile() {
        guard currentCardIndex < availableProfiles.count else { return }
        let profile = availableProfiles[currentCardIndex]
        likeManager.dislikeProfile(profile)
    }
    
    private func superLikeProfile() {
        guard currentCardIndex < availableProfiles.count else { return }
        let profile = availableProfiles[currentCardIndex]
        likeManager.superLikeProfile(profile)
        
        // Show match animation if it's a match
        if likeManager.isMatch(for: profile.id) {
            showMatchAnimation(for: profile)
        }
    }
    
    private func showMatchAnimation(for profile: UserProfile) {
        // TODO: Add match animation
    }
}

// MARK: - Profile Card
struct ProfileCard: View {
    let profile: UserProfile
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.gray)
            
            VStack(spacing: 20) {
                // Profile Image
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.pink.opacity(0.6), .purple.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                    
                    Text(String(profile.name.prefix(1)).uppercased())
                        .font(.system(size: 50, weight: .bold))
                        .foregroundStyle(.white)
                }
                
                VStack(spacing: 12) {
                    // Name and Age
                    HStack {
                        Text(profile.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("\(profile.age)")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                    }
                    
                    // Location
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.pink)
                        Text(profile.location)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    
                    // Profession
                    HStack {
                        Image(systemName: "briefcase.fill")
                            .foregroundColor(.pink)
                        Text(profile.profession)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    
                    // Religion
                    HStack {
                        Image(systemName: "hands.sparkles.fill")
                            .foregroundColor(.pink)
                        Text(profile.religion)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }
                
                Spacer()
            }
            .padding(25)
        }
        .frame(width: 300, height: 450)
    }
}

#Preview {
    discoverView()
}
