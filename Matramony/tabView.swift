//
//  tabView.swift
//  Matramony
//
//  Created by Vivek on 6/7/25.
//

import SwiftUI

struct tabView: View {
    
    @State var selectedTab: Int = 0
    @Bindable var profileVM: profileViewModel
    @Bindable var authVM: authViewModel
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Discover", systemImage: "heart.fill", value: 0) {
                discoverView()
            }

            Tab("Likes", systemImage: "star.fill", value: 1) {
                likesView()
            }
            
            Tab("Chat", systemImage: "message.fill", value: 2) {
                chatView()
            }

            Tab("Profile", systemImage: "person.crop.circle.fill", value: 3) {
                profileView(profilevm: profileVM, authVM: authVM)
            }
        }
    }
}
