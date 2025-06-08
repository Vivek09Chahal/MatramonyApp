//
//  loginView.swift
//  Matramony
//
//  Created by Vivek on 6/7/25.
//

import SwiftUI

struct signInView: View {
    
    @Bindable var authVM: authViewModel
    @Bindable var profileVM: profileViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showSignUp: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                
                // Logo/Title Section
                VStack(spacing: 16) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 60))
                    
                    Text("Matrimony")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Find your perfect match")
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }
                .backgroundGradientMofidifier()
                
                Spacer()
                
                // Login Form
                VStack(spacing: 20) {
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.pink)
                                .frame(width: 20)
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        .padding()
                        .cornerRadius(15)
                        
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.pink)
                                .frame(width: 20)
                            SecureField("Password", text: $password)
                        }
                        .padding()
                        .cornerRadius(15)
                    }
                    
                    // Error message
                    if !authVM.errorMessage.isEmpty {
                        Text(authVM.errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    // Login Button
                    Button {
                        authVM.loging(email: email, password: password)
                    } label: {
                        HStack {
                            if authVM.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .foregroundColor(.white)
                            }
                            Text(authVM.isLoading ? "Signing In..." : "Sign In")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
//                        .backgroundGradientMofidifier()
                        .cornerRadius(15)
                    }
                    .disabled(authVM.isLoading || email.isEmpty || password.isEmpty)
                    
                    // Sign Up Link
                    HStack {
                        Text("Don't have an account?")
                            .foregroundStyle(.secondary)
                        Button("Sign Up") {
                            showSignUp = true
                        }
                        .foregroundStyle(.pink)
                        .fontWeight(.semibold)
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
        .sheet(isPresented: $showSignUp) {
            signUpView(authVM: authVM, profileVM: profileVM)
        }
    }
}

#Preview {
    signInView(authVM: authViewModel(), profileVM: profileViewModel())
}
