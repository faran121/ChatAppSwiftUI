//
//  ChatModel.swift
//  Chat
//
//  Created by Maliks.
//

import Foundation

struct Chat: Identifiable {
    var id: UUID { person.id }
    let person: Person
    var messages: [Message]
    var hasUnreadMessage = false
}

struct Person: Identifiable {
    let id = UUID()
    let name: String
    let imgName: String
}

struct Message: Identifiable {
    
    enum MessageType {
        case Sent, Received
    }
    
    let id = UUID()
    let date: Date
    let text: String
    let type: MessageType
    
    init(_ text: String, type: MessageType, date: Date) {
        self.date = date
        self.type = type
        self.text = text
    }
    
    init(_ text: String, type: MessageType) {
        self.init(text, type: type, date: Date())
    }
}

extension Chat {
    static let sampleChat = [
        Chat(person: Person(name: "Alice", imgName: "person"), messages: [Message("Hi!", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 3)),
                                                                          Message("How are you?", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 3)),
                                                                          Message("I am good", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 2))
                                                                         ], hasUnreadMessage: true),
        Chat(person: Person(name: "Andrew", imgName: "person"), messages: [Message("Hi!", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 3)),
                                                                          Message("How are you?", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 3)),
                                                                          Message("I am good", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 2))
                                                                         ]),
        Chat(person: Person(name: "Bob", imgName: "person"), messages: [Message("Hi!", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 2)),
                                                                          Message("How are you?", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 2)),
                                                                          Message("I am good", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 1))
                                                                         ]),
        Chat(person: Person(name: "Ash", imgName: "person"), messages: [Message("Hi!", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 10)),
                                                                          Message("How are you?", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 10)),
                                                                          Message("I am good", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 9))
                                                                         ])
    ]
}
