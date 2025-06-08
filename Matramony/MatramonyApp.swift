//
//  MatramonyApp.swift
//  Matramony
//
//  Created by Vivek on 6/7/25.
//

import SwiftUI
import SwiftData

@main
struct MatramonyApp: App {
    
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @State var profileVM = profileViewModel()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Background gradient for the entire app
                LinearGradient(
                    colors: [.pink.opacity(0.1), .purple.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if isFirstLaunch {
                    signInView()
                        .onAppear {
                            // Mark as launched so this screen doesn't show again
                            isFirstLaunch = false
                        }
                } else {
                    tabView(profileVM: profileVM)
                }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
