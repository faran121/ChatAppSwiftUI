//
//  ChatsViewModel.swift
//  Chat
//
//  Created by Maliks.
//

import Foundation

class ChatsViewModel: ObservableObject {
    @Published var chats = Chat.sampleChat
    
    func getSortedFilterChats(query: String) -> [Chat] {
        let sortedResults = chats.sorted {
            guard let date1 = $0.messages.last?.date else { return false }
            guard let date2 = $1.messages.last?.date else { return false }
            
            return date1 > date2
        }
        
        if query == "" {
            return sortedResults
        }
        
        return sortedResults.filter { $0.person.name.lowercased().contains(query.lowercased()) }
    }
    
    func markAsUnread(_ newValue: Bool, chat: Chat) {
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            chats[index].hasUnreadMessage = newValue
        }
    }
    
    func sendMessage(_ text: String, in chat: Chat) -> Message? {
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            let message = Message(text, type: .Sent)
            chats[index].messages.append(message)
            return message
        }
        return nil
    }
    
    func getSectionMessages(for chat: Chat) -> [[Message]] {
        var result = [[Message]]()
        var temp = [Message]()
        
        for message in chat.messages {
            if let firstMessage = temp.first {
                let daysBetween = firstMessage.date.daysBetween(date: message.date)
                
                if daysBetween >= 1 {
                    result.append(temp)
                    temp.removeAll()
                    temp.append(message)
                }
                else {
                    temp.append(message)
                }
            }
            else {
                temp.append(message)
            }
        }
        
        result.append(temp)
        return result
    }
}
