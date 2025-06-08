//
//  likesView.swift
//  Matramony
//
//  Created by Vivek on 6/8/25.
//

import SwiftUI

struct likesView: View {
    
    @State private var selectedTab = 0
    @State private var likeManager = LikeDataManager.shared
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("Likes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text("See who likes you and your matches")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                
                // Segmented Control
                Picker("Likes Tabs", selection: $selectedTab) {
                    Text("Your Likes").tag(0)
                    Text("Who Liked You").tag(1)
                    Text("Matches").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                // Content based on selected tab
                TabView(selection: $selectedTab) {
                    // Your Likes Tab
                    yourLikesView
                        .tag(0)
                    
                    // Who Liked You Tab
                    whoLikedYouView
                        .tag(1)
                    
                    // Matches Tab
                    matchesView
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .navigationBarHidden(true)
            }
        }
    }
    
    var yourLikesView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(likeManager.likedProfiles, id: \.id) { profile in
                    LikeCard(
                        profile: profile,
                        showMatchBadge: false,
                        isMatch: likeManager.isMatch(for: profile.id)
                    )
                }
                
                if likeManager.likedProfiles.isEmpty {
                    EmptyStateView(
                        icon: "heart.circle",
                        title: "No Likes Yet",
                        subtitle: "Start swiping to like profiles!"
                    )
                }
            }
            .padding(.horizontal)
        }
    }
    
    var whoLikedYouView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(likeManager.profilesWhoLikedMeList, id: \.id) { profile in
                    WhoLikedYouCard(profile: profile, likeManager: likeManager)
                }
                
                if likeManager.profilesWhoLikedMeList.isEmpty {
                    EmptyStateView(
                        icon: "star.circle",
                        title: "No New Likes",
                        subtitle: "Keep an amazing profile to get more likes!"
                    )
                }
            }
            .padding(.horizontal)
        }
    }
    
    var matchesView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(likeManager.matchedProfiles, id: \.id) { profile in
                    MatchCard(profile: profile)
                }
                
                if likeManager.matchedProfiles.isEmpty {
                    EmptyStateView(
                        icon: "heart.circle",
                        title: "No Matches Yet",
                        subtitle: "Keep swiping to find your perfect match!"
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 80))
                .foregroundStyle(.pink.opacity(0.5))
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 50)
    }
}

// MARK: - Like Card
struct LikeCard: View {
    let profile: UserProfile
    let showMatchBadge: Bool
    let isMatch: Bool
    
    var body: some View {
        HStack(spacing: 16) {
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
                    .frame(width: 70, height: 70)
                
                Text(String(profile.name.prefix(1)).uppercased())
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.white)
                
                if showMatchBadge && isMatch {
                    Circle()
                        .fill(.green)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .offset(x: 25, y: -25)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(profile.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("\(profile.age)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    if isMatch {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.pink)
                            .font(.caption)
                    }
                }
                
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.pink)
                        .font(.caption)
                    Text(profile.location)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Text("Active recently")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                // Message action
            } label: {
                Image(systemName: "message.fill")
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(.pink)
                    .clipShape(Circle())
            }
        }
        .padding()
        .cornerRadius(16)
    }
}

// MARK: - Who Liked You Card
struct WhoLikedYouCard: View {
    let profile: UserProfile
    let likeManager: LikeDataManager
    @State private var showProfile = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Blurred Profile Image
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.pink.opacity(0.6), .purple.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 70, height: 70)
                    .blur(radius: showProfile ? 0 : 8)
                
                Text(showProfile ? String(profile.name.prefix(1)).uppercased() : "?")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(showProfile ? profile.name : "Someone")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                if showProfile {
                    HStack {
                        Text("\(profile.age)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Image(systemName: "location.fill")
                            .foregroundColor(.pink)
                            .font(.caption)
                        Text(profile.location)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Text("Likes you!")
                        .font(.subheadline)
                        .foregroundStyle(.pink)
                        .fontWeight(.medium)
                }
                
                Text("Active recently")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button {
                    likeManager.dislikeProfile(profile)
                } label: {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(.red)
                        .clipShape(Circle())
                }
                
                Button {
                    withAnimation(.spring()) {
                        showProfile = true
                    }
                    likeManager.likeBack(profile.id)
                } label: {
                    Image(systemName: "heart.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(.pink)
                        .clipShape(Circle())
                }
            }
        }
        .padding()
        .background(.quinary)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Match Card
struct MatchCard: View {
    let profile: UserProfile
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile Image with match indicator
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.pink.opacity(0.6), .purple.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 70, height: 70)
                
                Text(String(profile.name.prefix(1)).uppercased())
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.white)
                
                // Match indicator
                Circle()
                    .fill(.green)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: "heart.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    )
                    .offset(x: 25, y: -25)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(profile.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("\(profile.age)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text("✨ MATCH")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(.green.opacity(0.1))
                        .cornerRadius(8)
                }
                
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.pink)
                        .font(.caption)
                    Text(profile.location)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Text("Matched recently")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                // Start conversation
            } label: {
                Text("Chat")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .backgroundGradientMofidifier()
                    .cornerRadius(20)
            }
        }
        .padding()
        .background(.quinary)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [.green.opacity(0.3), .pink.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
    }
}

#Preview {
    likesView()
}
