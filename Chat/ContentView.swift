//
//  ContentView.swift
//  Chat
//
//  Created by Maliks.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ChatsViewModel()
    @State private var query = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.getSortedFilterChats(query: self.query)) { chat in
                    ZStack {
                        ChatRow(chat: chat)
                        
                        NavigationLink(destination: {
                            ChatView(chat: chat)
                                .environmentObject(self.viewModel)
                        }) {
                            EmptyView()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: 0)
                        .opacity(0)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button(action: {
                            viewModel.markAsUnread(!chat.hasUnreadMessage, chat: chat)
                        }) {
                            if chat.hasUnreadMessage {
                                Label("Read", systemImage: "text.bubble")
                            }
                            else {
                                Label("Unread", systemImage: "circle.fill")
                            }
                        }
                        .tint(.blue)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Chats")
            .searchable(text: $query)
            .navigationBarItems(trailing: Button(action: {}) {
                Image(systemName: "square.and.pencil")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
