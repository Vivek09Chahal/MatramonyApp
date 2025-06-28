//
//  profileEditView.swift
//  Matramony
//
//  Created by Vivek on 6/7/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct ProfileEditView: View {
    
    @Bindable var profilevm: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var profileImage: Data?
    @State private var selectedItem: PhotosPickerItem?
    @State private var name: String
    @State private var age: Int
    @State private var gender: Gender
    @State private var caste: String
    @State private var religion: String
    @State private var about: String
    @State private var email: String
    @State private var phoneNumber: Int
    
    init(profilevm: ProfileViewModel){
        self.profilevm = profilevm
        let user = profilevm.currentUser
        
        _profileImage = State(initialValue: user?.profileImage)
        _name = State(initialValue: user?.name ?? "")
        _age = State(initialValue: user?.age ?? 0)
        _gender = State(initialValue: user?.gender ?? .male)
        _caste = State(initialValue: user?.caste ?? "")
        _religion = State(initialValue: user?.religion ?? "")
        _about = State(initialValue: user?.about ?? "")
        _email = State(initialValue: user?.email ?? "")
        _phoneNumber = State(initialValue: user?.phoneNumber ?? 0)
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
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Profile Image Picker Section
                        profileImagePicker
                        
                        // Form Fields
                        VStack(spacing: 20) {
                            CustomTextField(
                                icon: "person.fill",
                                placeholder: "Full Name",
                                text: $name
                            )
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.pink)
                                        .frame(width: 20)
                                    Text("Age")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                }
                                
                                Picker("Age", selection: $age) {
                                    ForEach(18...100, id: \.self) { number in
                                        Text("\(number) years").tag(number)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 80)
                                .cornerRadius(12)
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "person.2.fill")
                                        .foregroundColor(.pink)
                                        .frame(width: 20)
                                    Text("Gender")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                }
                                
                                Picker("Gender", selection: $gender) {
                                    ForEach(Gender.allCases, id: \.self) { gender in
                                        Text(gender.rawValue).tag(gender)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                            
                            CustomTextField(
                                icon: "house.fill",
                                placeholder: "Caste",
                                text: $caste
                            )
                            
                            CustomTextField(
                                icon: "hands.sparkles.fill",
                                placeholder: "Religion",
                                text: $religion
                            )
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "doc.text.fill")
                                        .foregroundColor(.pink)
                                        .frame(width: 20)
                                    Text("About Yourself")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                }
                                
                                TextField("Tell us about yourself...", text: $about, axis: .vertical)
                                    .padding()
                                    .cornerRadius(12)
                                    .lineLimit(3...6)
                                    .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
                            }
                            
                            CustomTextField(
                                icon: "envelope.fill",
                                placeholder: "Email",
                                text: $email,
                                keyboardType: .emailAddress
                            )
                            
                            CustomTextField(
                                icon: "phone.fill",
                                placeholder: "Phone Number",
                                text: Binding(
                                    get: { phoneNumber == 0 ? "" : "\(phoneNumber)" },
                                    set: { phoneNumber = Int($0) ?? 0 }
                                ),
                                keyboardType: .numberPad
                            )
                            
                            Button {
                                profilevm.updateProfile(
                                    profileImage: profileImage,
                                    name: name,
                                    age: age,
                                    gender: gender,
                                    caste: caste,
                                    religion: religion,
                                    about: about,
                                    email: email,
                                    phoneNumber: phoneNumber
                                )
                                dismiss()
                            } label: {
                                Text("Update Profile")
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
                            .padding(.top, 10)
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.pink)
                }
            }
            .onAppear {
                profilevm.setModelContext(modelContext)
            }
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    if let newItem = newItem {
                        if let data = try? await newItem.loadTransferable(type: Data.self) {
                            profileImage = data
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Photo Picker Extension
extension ProfileEditView {
    
    var profileImagePicker: some View {
        VStack(spacing: 12) {
            ZStack {
                if let imageData = profileImage,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [.pink, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 3
                                )
                        )
                } else {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.pink.opacity(0.3), .purple.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .overlay {
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.gray)
                        }
                }
            }
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Text("Choose Photo")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.pink)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(.pink.opacity(0.1))
                    .cornerRadius(20)
            }
        }
    }
}

#Preview {
    ProfileEditView(profilevm: ProfileViewModel())
        .modelContainer(for: User.self, inMemory: true)
}
