//
//  ContentView.swift
//  Matramony
//
//  Created by Vivek on 6/7/25.
//


import SwiftUI
import SwiftData

struct profileView: View {
    
    @Bindable var profilevm: profileViewModel
    @State private var showEditProfileView: Bool = false
    @Query private var items: [User]
    @Environment(\.modelContext) private var modelContext
    
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
                
                if let item = items.first {
                    ScrollView {
                        VStack(spacing: 25) {
                            // Profile Header
                            VStack(spacing: 16) {
                                // Profile Image
                                imageView(item: item)
                                
                                VStack(spacing: 8) {
                                    Text(item.name)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.primary)
                                    
                                    Text("\(item.age) years • \(item.gender.rawValue)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.top)
                            
                            // Profile Details
                            VStack(spacing: 16) {
                                profileInfo(item: item)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 30)
                    }
                    .navigationTitle("Profile")
                    .navigationBarTitleDisplayMode(.inline)
                    .sheet(isPresented: $showEditProfileView) {
                        profileEditView(profilevm: profilevm)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                showEditProfileView.toggle()
                            } label: {
                                Text("Edit")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.pink)
                            }
                        }
                    }
                    .onAppear {
                        profilevm.setModelContext(modelContext)
                        profilevm.currentUser = item
                    }
                } else {
                    // No profile exists, show create profile view
                    VStack(spacing: 30) {
                        Spacer()
                        
                        VStack(spacing: 20) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 100))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.pink.opacity(0.6), .purple.opacity(0.6)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            VStack(spacing: 8) {
                                Text("Welcome to Matrimony!")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                                
                                Text("Create your profile to start finding your perfect match")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            
                            Button {
                                showEditProfileView.toggle()
                            } label: {
                                Text("Create Profile")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        LinearGradient(
                                            colors: [.pink, .purple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(15)
                                    .shadow(color: .pink.opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                            .padding(.horizontal, 40)
                            .padding(.top, 10)
                        }
                        
                        Spacer()
                    }
                    .navigationTitle("Profile")
                    .navigationBarTitleDisplayMode(.inline)
                    .sheet(isPresented: $showEditProfileView) {
                        profileEditView(profilevm: profilevm)
                    }
                    .onAppear {
                        profilevm.setModelContext(modelContext)
                    }
                }
            }
        }
    }
}

extension profileView{
    
    func profileInfo(item: User) -> some View {
        VStack(spacing: 16) {
            // Basic Info Section
            ProfileSection(title: "Basic Information", icon: "person.fill") {
                VStack(spacing: 12) {
                    ProfileDetailRow(title: "Name", value: item.name, icon: "person.fill")
                    ProfileDetailRow(title: "Age", value: item.age == 0 ? "Not specified" : "\(item.age) years", icon: "calendar")
                    ProfileDetailRow(title: "Gender", value: item.gender.rawValue, icon: "person.2.fill")
                }
            }
            
            // Contact Information
            ProfileSection(title: "Contact Information", icon: "phone.fill") {
                VStack(spacing: 12) {
                    ProfileDetailRow(title: "Email", value: item.email, icon: "envelope.fill")
                    ProfileDetailRow(title: "Phone", value: item.phoneNumber == 0 ? "Not specified" : "\(item.phoneNumber)", icon: "phone.fill")
                }
            }
            
            // Cultural Information
            ProfileSection(title: "Cultural Background", icon: "hands.sparkles.fill") {
                VStack(spacing: 12) {
                    ProfileDetailRow(title: "Religion", value: item.religion, icon: "hands.sparkles.fill")
                    ProfileDetailRow(title: "Caste", value: item.caste, icon: "house.fill")
                }
            }
            
            // About Section
            if !item.about.isEmpty {
                ProfileSection(title: "About Me", icon: "doc.text.fill") {
                    Text(item.about)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .cornerRadius(12)
                }
            }
        }
    }
    
    func imageView(item: User) -> some View {
        ZStack {
            if let imageData = item.profileImage,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(LinearGradient(
                        colors: [.pink.opacity(0.6), .purple.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 120, height: 120)
                    .overlay {
                        if !item.name.isEmpty {
                            Text(String(item.name.prefix(1)).uppercased())
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(.white)
                        } else {
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.white)
                        }
                    }
            }
        }
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    NavigationStack{
        profileView(profilevm: .init())
    }
}
