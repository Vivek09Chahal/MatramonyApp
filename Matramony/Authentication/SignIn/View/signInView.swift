//
//  loginView.swift
//  Matramony
//
//  Created by Vivek on 6/7/25.
//

import SwiftUI

struct signInView: View {
    
    @Bindable var loginvm = authViewModel()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showSignUp: Bool = false
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                
                // Logo/Title Section
                VStack(spacing: 16) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 60))
                        .foregroundGradientMofidifier()
                    
                    Text("Matrimony")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundGradientMofidifier()
                    
                    Text("Find your perfect match")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
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
                        .background(.white.opacity(0.8))
                        .cornerRadius(15)
                        
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.pink)
                                .frame(width: 20)
                            SecureField("Password", text: $password)
                        }
                        .padding()
                        .background(.white.opacity(0.8))
                        .cornerRadius(15)
                    }
                    
                    // Login Button
                    Button {
                        loginvm.loging(email: email, password: password)
                        // For demo purposes, navigate to main app
                        isFirstLaunch = false
                    } label: {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .backgroundGradientMofidifier()
                            .cornerRadius(15)
                    }
                    
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
            .backgroundGradientMofidifier()
        }
        .sheet(isPresented: $showSignUp) {
            signUpView(profilevm: profileViewModel())
        }
    }
}

#Preview {
    signInView()
}
