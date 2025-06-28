//
//  tabView.swift
//  Matramony
//
//  Created by Vivek on 6/7/25.
//

import SwiftUI

struct MainView: View {
    
    @State var selectedTab: Int = 0
    @Bindable var profileVM: ProfileViewModel
    @Bindable var authVM: AuthViewModel
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Discover", systemImage: "heart.fill", value: 0) {
                DiscoverView()
            }
            
            Tab("Likes", systemImage: "star.fill", value: 1) {
                LikesView()
            }
            
            Tab("Chat", systemImage: "message.fill", value: 2) {
                ChatView()
            }
            
            Tab("Profile", systemImage: "person.crop.circle.fill", value: 3) {
                ProfileView(profilevm: profileVM, authVM: authVM)
            }
        }
    }
}
