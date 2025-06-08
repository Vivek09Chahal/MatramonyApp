//
//  customViewBuilder.swift
//  Matramony
//
//  Created by Vivek on 6/7/25.
//

import SwiftUI

@ViewBuilder
func ProfileDetailRow(title: String, value: String, icon: String) -> some View {
    HStack(spacing: 12) {
        Image(systemName: icon)
            .foregroundStyle(.pink)
            .frame(width: 20)
        
        Text(title)
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundStyle(.primary)
        
        Spacer()
        
        Text(value)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.trailing)
    }
    .padding()
    .background(.quinary)
    .cornerRadius(10)
    .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
}

struct ProfileSection<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.pink)
                    .frame(width: 20)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            
            content
        }
        .padding()
        .background(.quinary)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}


