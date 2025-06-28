//
//  signUpView.swift
//  Matramony
//
//  Created by Vivek on 6/8/25.
//

import SwiftUI
import PhotosUI

struct SignUpView: View {
    
    @Bindable var authVM: AuthViewModel
    @Bindable var profileVM: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var profileImage: Data?
    @State private var selectedItem: PhotosPickerItem?
    @State private var name: String = ""
    @State private var age: Int = 18
    @State private var gender: Gender = .male
    @State private var caste: String = ""
    @State private var religion: String = ""
    @State private var about: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var phoneNumber: Int = 0
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Create Your Profile")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                    }
                    .padding(.top)
                    
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
                        }
                        
                        CustomTextField(
                            icon: "envelope.fill",
                            placeholder: "Email",
                            text: $email,
                            keyboardType: .emailAddress
                        )
                        
                        CustomSecureField(
                            icon: "lock.fill",
                            placeholder: "Password (min 6 characters)",
                            text: $password
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
                        
                        // Error message
                        if !authVM.errorMessage.isEmpty {
                            Text(authVM.errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }
                        
                        // Create Profile Button
                        Button {
                            createAccount()
                        } label: {
                            HStack {
                                if authVM.isLoading {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .foregroundColor(.white)
                                }
                                Text(authVM.isLoading ? "Creating Account..." : "Create Profile")
                                    .font(.headline)
                            }
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
                        }
                        .disabled(authVM.isLoading || !isFormValid)
                        .padding(.top, 10)
                    }
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 30)
            }
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
                profileVM.setModelContext(modelContext)
                authVM.setModelContext(modelContext)
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
            .alert("Account Created", isPresented: $showingAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text(alertMessage)
            }
            .backgroundGradientMofidifier()
        }
    }
    
    // MARK: - Helper Properties and Functions
    private var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && !password.isEmpty && password.count >= 6
    }
    
    private func createAccount() {
        authVM.signUp(email: email, password: password) { success in
            if success {
                // Create the user profile
                profileVM.updateProfile(
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
                
                alertMessage = "Your account has been created successfully! Welcome to Matrimony!"
                showingAlert = true
            }
        }
    }
}

// MARK: - Photo Picker Extension
extension SignUpView {
    
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
                        .backgroundGradientMofidifier()
                        .frame(width: 100, height: 100)
                        .overlay {
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.gray)
                        }
                }
            }
            
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

// MARK: - Custom TextField
struct CustomTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.pink)
                .frame(width: 20)
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .autocapitalization(keyboardType == .emailAddress ? .none : .words)
        }
        .padding()
        .background(.quinary)
        .cornerRadius(12)
    }
}

// MARK: - Custom Secure Field
struct CustomSecureField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.pink)
                .frame(width: 20)
            
            SecureField(placeholder, text: $text)
        }
        .padding()
        .background(.quinary)
        .cornerRadius(12)
    }
}

#Preview {
    SignUpView(authVM: AuthViewModel(), profileVM: ProfileViewModel())
        .modelContainer(for: User.self, inMemory: true)
}
