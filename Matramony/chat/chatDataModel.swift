//
//  chatDataModel.swift
//  Matramony
//
//  Created by Vivek on 6/8/25.
//

import SwiftUI
import Foundation

// MARK: - Message Model
struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let timestamp: Date
    let isFromCurrentUser: Bool
    let messageType: MessageType
    
    enum MessageType {
        case text
        case image
        case emoji
    }
}

// MARK: - Chat Conversation Model
struct ChatConversation: Identifiable {
    let id = UUID()
    let user: UserProfile
    let messages: [ChatMessage]
    let lastMessage: ChatMessage?
    let unreadCount: Int
    let isOnline: Bool
    
    var lastActiveText: String {
        if isOnline {
            return "Online now"
        } else {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .abbreviated
            return "Active \(formatter.localizedString(for: lastMessage?.timestamp ?? Date().addingTimeInterval(-3600), relativeTo: Date()))"
        }
    }
}

// MARK: - Chat Data Manager
@Observable
class ChatDataManager {
    static let shared = ChatDataManager()
    
    var conversations: [ChatConversation] = []
    
    private init() {
        generateDummyChats()
    }
    
    // dummy char generation
    private func generateDummyChats() {
        // Get matched profiles from LikeDataManager
        let matchedProfiles = LikeDataManager.shared.matchedProfiles
        
        // Create dummy conversations for matched profiles
        for profile in matchedProfiles.prefix(5) {
            let messages = generateDummyMessages(for: profile)
            let conversation = ChatConversation(
                user: profile,
                messages: messages,
                lastMessage: messages.last,
                unreadCount: Int.random(in: 0...3),
                isOnline: Bool.random()
            )
            conversations.append(conversation)
        }
        
        // Add some additional dummy conversations
        let additionalProfiles = [
            UserProfile(name: "Sakshi", age: 24, location: "Indore", profession: "Photographer", religion: "Hindu"),
            UserProfile(name: "Karan", age: 27, location: "Lucknow", profession: "Chef", religion: "Hindu"),
            UserProfile(name: "Neha", age: 26, location: "Nagpur", profession: "Journalist", religion: "Hindu")
        ]
        
        for profile in additionalProfiles {
            let messages = generateDummyMessages(for: profile)
            let conversation = ChatConversation(
                user: profile,
                messages: messages,
                lastMessage: messages.last,
                unreadCount: Int.random(in: 0...5),
                isOnline: Bool.random()
            )
            conversations.append(conversation)
        }
        
        // Sort by last message timestamp
        conversations.sort { ($0.lastMessage?.timestamp ?? Date.distantPast) > ($1.lastMessage?.timestamp ?? Date.distantPast) }
    }
    
    // message for dummy chat
    private func generateDummyMessages(for profile: UserProfile) -> [ChatMessage] {
        let dummyMessages = [
            "Hi! Nice to meet you! 😊",
            "How was your day?",
            "I love your profile! You seem like a really interesting person.",
            "What do you like to do in your free time?",
            "Would you like to meet for coffee sometime?",
            "I'm really enjoying our conversation! 💕",
            "Hope you're having a great weekend!",
            "What's your favorite place to visit in \(profile.location)?",
            "I'd love to know more about your work as a \(profile.profession.lowercased()).",
            "Thank you for the lovely chat! 🌟"
        ]
        
        var messages: [ChatMessage] = []
        let messageCount = Int.random(in: 3...8)
        let shuffledMessages = dummyMessages.shuffled().prefix(messageCount)
        
        var currentTime = Date().addingTimeInterval(-TimeInterval.random(in: 3600...86400))
        
        for (_, messageText) in shuffledMessages.enumerated() {
            let isFromCurrentUser = Bool.random()
            let message = ChatMessage(
                content: messageText,
                timestamp: currentTime,
                isFromCurrentUser: isFromCurrentUser,
                messageType: .text
            )
            messages.append(message)
            currentTime = currentTime.addingTimeInterval(TimeInterval.random(in: 300...3600))
        }
        
        return messages.sorted { $0.timestamp < $1.timestamp }
    }
    
    // function to add message to the chat
    func addMessage(to conversationId: UUID, content: String) {
        if let index = conversations.firstIndex(where: { $0.id == conversationId }) {
            let newMessage = ChatMessage(
                content: content,
                timestamp: Date(),
                isFromCurrentUser: true,
                messageType: .text
            )
            
            let updatedMessages = conversations[index].messages + [newMessage]
            let updatedConversation = ChatConversation(
                user: conversations[index].user,
                messages: updatedMessages,
                lastMessage: newMessage,
                unreadCount: 0,
                isOnline: conversations[index].isOnline
            )
            
            conversations[index] = updatedConversation
            
            // Move to top
            let conversation = conversations.remove(at: index)
            conversations.insert(conversation, at: 0)
        }
    }
    
    // message read
    func markAsRead(conversationId: UUID) {
        if let index = conversations.firstIndex(where: { $0.id == conversationId }) {
            let updatedConversation = ChatConversation(
                user: conversations[index].user,
                messages: conversations[index].messages,
                lastMessage: conversations[index].lastMessage,
                unreadCount: 0,
                isOnline: conversations[index].isOnline
            )
            conversations[index] = updatedConversation
        }
    }
}
