//
//  ChatListView.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 16/09/2026.
//

import SwiftUI
import PhotosUI

struct ChatConversation: Identifiable, Hashable {
    var id: String { storeName }
    let storeName: String
    let storeAvatar: String
    let lastMessage: String
    let timeString: String
    var unreadCount: Int = 0
    var isReadByRecipient: Bool = false
    var messages: [ChatMessage] = []
}

struct ChatMessage: Identifiable, Hashable {
    let id = UUID()
    let senderName: String
    let text: String
    let isFromUser: Bool
    let timestamp: String
    var attachmentName: String? = nil
    var attachmentSize: String? = nil
}

struct ChatListView: View {
    @State private var searchText = ""
    @State private var conversations: [ChatConversation] = [
        ChatConversation(
            storeName: "Terra Pro",
            storeAvatar: "bag.fill",
            lastMessage: "Excepteur sint occaecat cupidatat...",
            timeString: "10:49 AM",
            unreadCount: 2,
            messages: []
        ),
        ChatConversation(
            storeName: "Joybox",
            storeAvatar: "gift.fill",
            lastMessage: "Ut enim ad minima veniam, quis no...",
            timeString: "10:49 AM",
            isReadByRecipient: true
        ),
        ChatConversation(
            storeName: "Media Market",
            storeAvatar: "laptopcomputer",
            lastMessage: "Neque porro quisquam est, qui dolo...",
            timeString: "10:49 AM",
            isReadByRecipient: true
        ),
        ChatConversation(
            storeName: "Ali Express",
            storeAvatar: "a.circle.fill",
            lastMessage: "Alright, looking forward to it!",
            timeString: "10:49 AM",
            isReadByRecipient: true,
            messages: [
                ChatMessage(senderName: "Ali Express", text: "", isFromUser: false, timestamp: "Friday 2:20pm", attachmentName: "Latest screenshot.jpg", attachmentSize: "1.2 MB"),
                ChatMessage(senderName: "Me", text: "Confirmed!", isFromUser: true, timestamp: "Friday 2:20pm"),
                ChatMessage(senderName: "Me", text: "When can you resolve the issue?", isFromUser: true, timestamp: "Friday 2:20pm"),
                ChatMessage(senderName: "Ali Express", text: "I'm sorry man, I'll let you know today", isFromUser: false, timestamp: "Friday 2:20pm"),
                ChatMessage(senderName: "Me", text: "Alright, looking forward to it!", isFromUser: true, timestamp: "Friday 2:20pm")
            ]
        ),
        ChatConversation(
            storeName: "Allegro",
            storeAvatar: "cart.fill",
            lastMessage: "Lorem ipsum dolor sit amet, consec...",
            timeString: "10:49 AM",
            isReadByRecipient: true
        )
    ]
    
    
    var filteredConversations: [ChatConversation] {
        if searchText.isEmpty {
            return conversations
        } else {
            return conversations.filter {
                $0.storeName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        List(filteredConversations) { conversation in
            NavigationLink {
                ChatDetailView(conversation: conversation)
            } label: {
                ConversationRow(conversation: conversation)
            }
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    conversations.removeAll { $0.id == conversation.id }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                
                Button {
                    // Mute Action
                } label: {
                    Label("Mute", systemImage: "bell.slash")
                }
                .tint(.orange)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search chats")
    }
}



struct ConversationRow: View {
    let conversation: ChatConversation
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: conversation.storeAvatar)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(10)
                .background(Color.accentColor.opacity(0.1))
                .foregroundColor(.accentColor)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(conversation.storeName)
                        .font(.headline)
                        .lineLimit(1)
                    Spacer()
                    
                    Text(conversation.timeString)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                HStack(spacing: 4) {
                    Text(conversation.lastMessage)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if conversation.unreadCount > 0 {
                        Text("\(conversation.unreadCount)")
                            .font(.caption2.weight(.bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(Color.red)
                            .clipShape(Capsule())
                    } else if conversation.isReadByRecipient {
                        Image(systemName: "checkmark.checkmark")
                            .font(.caption)
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
        .padding(4)
    }
}


struct ChatDetailView: View {
    let conversation: ChatConversation
    
    @State private var messages: [ChatMessage] = []
    @State private var newMessageText: String = ""
    @FocusState private var isInputFocused: Bool
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var attachedImage: UIImage?
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if let firstMessage = messages.first {
                            Text(firstMessage.timestamp)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .padding(.vertical, 8)
                        } else {
                            ContentUnavailableView(
                                "No messages yet",
                                systemImage: "bubble.left.and.bubble.right",
                                description: Text("Start a message with \(conversation.storeName).")
                            )
                            .padding(.top, 210)
                        }
                        
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .scrollDismissesKeyboard(.interactively)
                .onAppear {
                    messages = conversation.messages
                    if let lastID = messages.last?.id {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            proxy.scrollTo(lastID, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: messages.count) { _, _ in
                    if let lastID = messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastID, anchor: .bottom)
                        }
                    }
                }
            }
            
            chatInputBar
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(conversation.storeName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: conversation.storeAvatar)
                    .foregroundStyle(Color.accentColor)
            }
        }
    }
    
    
    private var chatInputBar: some View {
        HStack(spacing: 10) {
            Menu {
                Button (action: {} ) {
                    Label("Photo & Video Library", systemImage: "photo.on.rectangle")
                }
                Button(action: {} ) {
                    Label("Camera", systemImage: "camera")
                }
            } label: {
                Image(systemName: "paperclip")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .padding(8)
            }
            
            TextField("Write a message...", text: $newMessageText, axis: .vertical)
                .focused($isInputFocused)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color(.systemGray4), lineWidth: 0.5)
                )
            
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(newMessageText.trimmingCharacters(in: .whitespaces).isEmpty ? Color(.systemGray4) : Color.accentColor)
            }
            .disabled(newMessageText.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.bar)
    }
    
    
    private func sendMessage() {
        let text = newMessageText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }
        
        let newMsg = ChatMessage(senderName: "Me", text: text, isFromUser: true, timestamp: "Just now")
        withAnimation {
            messages.append(newMsg)
            newMessageText = ""
        }
    }
}


struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromUser { Spacer(minLength: 40) }
            
            VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 4) {
                if let fileName = message.attachmentName {
                    HStack(spacing: 10) {
                        Image(systemName: "doc.fill")
                            .font(.title2)
                            .foregroundColor(Color.accentColor)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(fileName)
                                .font(.subheadline.weight(.medium))
                                .lineLimit(1)
                            
                            if let size = message.attachmentSize {
                                Text(size)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(12)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                }
                
                if !message.text.isEmpty {
                    Text(message.text)
                        .font(.body)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .foregroundStyle(message.isFromUser ? .white : .primary)
                        .background(message.isFromUser ? Color.accentColor : Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: message.isFromUser ? .clear : .black.opacity(0.06), radius: 2, x: 0, y: 1)
                }
            }
            if !message.isFromUser { Spacer(minLength: 40) }
        }
    }
}


#Preview("Chat list") {
    NavigationStack {
        ChatListView()
    }
}


#Preview("Chat Detail") {
    NavigationStack {
        ChatDetailView(conversation: ChatConversation(
            storeName: "Alifshop",
            storeAvatar: "a.circle.fill",
            lastMessage: "Alright, looking forward to it!",
            timeString: "10:49 AM",
            messages: [
                ChatMessage(senderName: "Alifshop", text: "", isFromUser: false, timestamp: "Friday 2:20pm", attachmentName: "Latest screenshot.jpg", attachmentSize: "1.2 MB"),
                ChatMessage(senderName: "Me", text: "Confirmed!", isFromUser: true, timestamp: "Friday 2:20pm"),
                ChatMessage(senderName: "Me", text: "When can you resolve the issue?", isFromUser: true, timestamp: "Friday 2:20pm"),
                ChatMessage(senderName: "Alifshop", text: "I'm sorry man, I'll let you know today", isFromUser: false, timestamp: "Friday 2:20pm"),
                ChatMessage(senderName: "Me", text: "Alright, looking forward to it!", isFromUser: true, timestamp: "Friday 2:20pm")
            ]
        ))
    }
}
