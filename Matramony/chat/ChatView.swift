//
//  chatView.swift
//  Matramony
//
//  Created by Vivek on 6/8/25.
//

import SwiftUI

struct ChatView: View {
    @State private var chatManager = ChatDataManager.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [.pink.opacity(0.1), .purple.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Messages")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        
                        Text("Connect with your matches")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top)
                    .padding(.bottom, 20)
                    
                    // Chat List
                    if chatManager.conversations.isEmpty {
                        emptyStateView
                    } else {
                        chatListView
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "message.circle")
                .font(.system(size: 80))
                .foregroundStyle(.pink.opacity(0.5))
            
            Text("No Messages Yet")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
            
            Text("Start matching to begin conversations!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
    }
    
    var chatListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(chatManager.conversations) { conversation in
                    NavigationLink(destination: ChatDetailView(conversation: conversation)) {
                        ChatRowView(conversation: conversation)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 100)
        }
    }
}

// MARK: - Chat Row View
struct ChatRowView: View {
    let conversation: ChatConversation
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile Image with Online Indicator
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.pink.opacity(0.6), .purple.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                
                Text(String(conversation.user.name.prefix(1)).uppercased())
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                
                if conversation.isOnline {
                    Circle()
                        .fill(.green)
                        .frame(width: 16, height: 16)
                        .overlay(
                            Circle()
                                .stroke(.white, lineWidth: 2)
                        )
                        .offset(x: 20, y: 20)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(conversation.user.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    if let lastMessage = conversation.lastMessage {
                        Text(timeString(from: lastMessage.timestamp))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                HStack {
                    if let lastMessage = conversation.lastMessage {
                        Text(lastMessage.content)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    if conversation.unreadCount > 0 {
                        Text("\(conversation.unreadCount)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(minWidth: 20, minHeight: 20)
                            .background(.pink)
                            .clipShape(Circle())
                    }
                }
                
                Text(conversation.lastActiveText)
                    .font(.caption)
                    .foregroundStyle(conversation.isOnline ? .green : .secondary)
            }
        }
        .padding()
        .background(.quinary)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
        } else if Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear) {
            formatter.dateFormat = "E"
        } else {
            formatter.dateFormat = "dd/MM"
        }
        return formatter.string(from: date)
    }
}

// MARK: - Chat Detail View
struct ChatDetailView: View {
    let conversation: ChatConversation
    @State private var newMessage = ""
    @State private var messages: [ChatMessage]
    @Environment(\.dismiss) private var dismiss
    
    init(conversation: ChatConversation) {
        self.conversation = conversation
        self._messages = State(initialValue: conversation.messages)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundStyle(.pink)
                }
                
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .backgroundGradientMofidifier()
                            .frame(width: 40, height: 40)
                        
                        Text(String(conversation.user.name.prefix(1)).uppercased())
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                        
                        if conversation.isOnline {
                            Circle()
                                .fill(.green)
                                .frame(width: 12, height: 12)
                                .overlay(
                                    Circle()
                                        .stroke(.white, lineWidth: 1)
                                )
                                .offset(x: 14, y: 14)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(conversation.user.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(conversation.lastActiveText)
                            .font(.caption)
                            .foregroundStyle(conversation.isOnline ? .green : .secondary)
                    }
                }
                
                Spacer()
                
                Button {
                    // Video call action
                } label: {
                    Image(systemName: "video.fill")
                        .font(.title3)
                        .foregroundStyle(.pink)
                }
            }
            .padding()
            .background(.quinary)
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
            
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .background(
                    LinearGradient(
                        colors: [.pink.opacity(0.05), .purple.opacity(0.02)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .onAppear {
                    if let lastMessage = messages.last {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
            
            // Message Input
            HStack(spacing: 12) {
                TextField("Type a message...", text: $newMessage)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        sendMessage()
                    }
                
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(.pink)
                        .clipShape(Circle())
                }
                .disabled(newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
            .background(.quinary)
        }
        .navigationBarHidden(true)
    }
    
    private func sendMessage() {
        let trimmedMessage = newMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else { return }
        
        let message = ChatMessage(
            content: trimmedMessage,
            timestamp: Date(),
            isFromCurrentUser: true,
            messageType: .text
        )
        
        messages.append(message)
        ChatDataManager.shared.addMessage(to: conversation.id, content: trimmedMessage)
        newMessage = ""
        
        // Simulate response after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            simulateResponse()
        }
    }
    
    private func simulateResponse() {
        let responses = [
            "That sounds great! 😊",
            "I'd love that!",
            "Absolutely! When works for you?",
            "Thanks for sharing that with me!",
            "I completely agree!",
            "That's so interesting!",
            "I'm looking forward to it! 💕",
            "You always know what to say! 🌟"
        ]
        
        if Bool.random() {
            let response = ChatMessage(
                content: responses.randomElement()!,
                timestamp: Date(),
                isFromCurrentUser: false,
                messageType: .text
            )
            messages.append(response)
        }
    }
}

// MARK: - Message Bubble
struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.content)
                        .padding()
                        .backgroundGradientMofidifier()
                        .foregroundStyle(.primary)
                        .cornerRadius(20, corners: [.topLeft, .topRight, .bottomLeft])
                    
                    Text(timeString(from: message.timestamp))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: 250, alignment: .trailing)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    Text(message.content)
                        .padding()
                        .background(.quinary)
                        .foregroundColor(.primary)
                        .cornerRadius(20, corners: [.topLeft, .topRight, .bottomRight])
                        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
                    
                    Text(timeString(from: message.timestamp))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: 250, alignment: .leading)
                
                Spacer()
            }
        }
    }
    
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

// MARK: - Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    ChatView()
}
