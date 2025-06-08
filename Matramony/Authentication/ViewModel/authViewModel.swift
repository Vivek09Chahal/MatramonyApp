//
//  loginViewModel.swift
//  Matramony
//
//  Created by Vivek on 6/8/25.
//

import Foundation
import SwiftData

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
        // Basic validation
        return !email.isEmpty && !password.isEmpty && email.contains("@")
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
    
    func createUser(email: String, password: String) {
        isLoading = true
        errorMessage = ""
        
        // Simulate account creation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.validateEmailFormat(email: email) && self.validatePassword(password: password) {
                // In a real app, you would send this to your backend
                self.isLoggedIn = true
                self.email = email
                self.password = password
            } else {
                self.errorMessage = "Please check your email format and password requirements"
            }
            self.isLoading = false
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
}
