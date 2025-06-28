//
//  customModifier.swift
//  Matramony
//
//  Created by Vivek on 6/8/25.
//

import Foundation
import SwiftUI

struct ForegroundGradient: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    colors: [.pink.opacity(0.6), .purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
}

extension View {
    public func foregroundGradientModifier() -> some View {
        self.modifier(ForegroundGradient())
    }
}

struct backgroundGradient: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(
                LinearGradient(
                    colors: [.pink.opacity(0.6), .purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
}

extension View {
    public func backgroundGradientMofidifier() -> some View {
        self.modifier(backgroundGradient())
    }
}

struct text: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .foregroundColor(.white)
            .frame(width: 60, height: 60)
            .backgroundGradientMofidifier()
            .clipShape(Circle())
    }
}

extension View {
    public func textMofidifier() -> some View {
        self.modifier(text())
    }
}
