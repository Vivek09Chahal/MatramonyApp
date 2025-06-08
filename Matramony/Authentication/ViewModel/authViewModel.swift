//
//  loginViewModel.swift
//  Matramony
//
//  Created by Vivek on 6/8/25.
//

import Foundation
import SwiftData
import CryptoKit

@Observable
class authViewModel {
    
    var currentUser: User?
    var email = ""
    var password = ""
    var isLoggedIn = false
    var errorMessage = ""
    var isLoading = false
    
    private var modelContext: ModelContext?
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func loging(email: String, password: String) {
        isLoading = true
        errorMessage = ""
        
        // Simulate login process
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.validateLogin(email: email, password: password) {
                self.isLoggedIn = true
                self.loadUserProfile(email: email)
            } else {
                self.errorMessage = "Invalid email or password"
            }
            self.isLoading = false
        }
    }
    
    private func validateLogin(email: String, password: String) -> Bool {
        guard let modelContext = modelContext else { return false }
        
        do {
            let descriptor = FetchDescriptor<User>(
                predicate: #Predicate { user in
                    user.email == email
                }
            )
            let users = try modelContext.fetch(descriptor)
            
            if let user = users.first {
                // Verify password
                return verifyPassword(password, hashedPassword: user.password)
            }
            return false
        } catch {
            print("Failed to validate login: \(error)")
            return false
        }
    }
    
    private func loadUserProfile(email: String) {
        guard let modelContext = modelContext else { return }
        
        do {
            let descriptor = FetchDescriptor<User>(
                predicate: #Predicate { user in
                    user.email == email
                }
            )
            let users = try modelContext.fetch(descriptor)
            currentUser = users.first
        } catch {
            print("Failed to load user profile: \(error)")
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = ""
        
        // Check if user already exists
        guard let modelContext = modelContext else {
            errorMessage = "Database error"
            isLoading = false
            completion(false)
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            do {
                let descriptor = FetchDescriptor<User>(
                    predicate: #Predicate { user in
                        user.email == email
                    }
                )
                let existingUsers = try modelContext.fetch(descriptor)
                
                if !existingUsers.isEmpty {
                    self.errorMessage = "An account with this email already exists"
                    self.isLoading = false
                    completion(false)
                    return
                }
                
                if self.validateEmailFormat(email: email) && self.validatePassword(password: password) {
                    // Create user with hashed password
                    let hashedPassword = self.hashPassword(password)
                    let newUser = User(
                        profileImage: nil,
                        name: "",
                        age: 0,
                        gender: .male,
                        caste: "",
                        religion: "",
                        about: "",
                        email: email,
                        phoneNumber: 0,
                        password: hashedPassword
                    )
                    
                    modelContext.insert(newUser)
                    
                    do {
                        try modelContext.save()
                        self.currentUser = newUser
                        self.isLoggedIn = true
                        self.email = email
                        self.isLoading = false
                        completion(true)
                    } catch {
                        self.errorMessage = "Failed to create account"
                        self.isLoading = false
                        completion(false)
                    }
                } else {
                    self.errorMessage = "Please check your email format and password requirements"
                    self.isLoading = false
                    completion(false)
                }
            } catch {
                self.errorMessage = "Failed to check existing accounts"
                self.isLoading = false
                completion(false)
            }
        }
    }
    
    private func validateEmailFormat(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func validatePassword(password: String) -> Bool {
        return password.count >= 6
    }
    
    func logOut() {
        isLoggedIn = false
        currentUser = nil
        email = ""
        password = ""
        errorMessage = ""
    }
    
    func resetPassword(email: String) {
        isLoading = true
        errorMessage = ""
        
        // Simulate password reset
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.validateEmailFormat(email: email) {
                // In a real app, send password reset email
                self.errorMessage = "Password reset email sent!"
            } else {
                self.errorMessage = "Please enter a valid email address"
            }
            self.isLoading = false
        }
    }
    
    // MARK: - Password Security Methods
    private func hashPassword(_ password: String) -> String {
        let inputData = Data(password.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    private func verifyPassword(_ password: String, hashedPassword: String) -> Bool {
        let hashedInputPassword = hashPassword(password)
        return hashedInputPassword == hashedPassword
    }
}
