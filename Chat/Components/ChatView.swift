//
//  ChatView.swift
//  Chat
//
//  Created by Maliks.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var viewModel: ChatsViewModel
    @State private var text = ""
    @State private var messageIDToScroll: UUID?
    @FocusState private var isFocused
    
    let chat: Chat
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { reader in
                ScrollView {
                    ScrollViewReader { scrollReader in
                        getMessagesView(viewWidth: reader.size.width)
                            .padding(.horizontal)
                            .onChange(of: messageIDToScroll) { _ in
                                if let messageID = messageIDToScroll {
                                    scrollTo(messageID: messageID, shouldAnimate: true ,scrollReader: scrollReader)
                                }
                            }
                            .onAppear {
                                if let messageID = chat.messages.last?.id {
                                    scrollTo(messageID: messageID, anchor: .bottom ,shouldAnimate: false, scrollReader: scrollReader)
                                }
                            }
                    }
                }
            }
            .padding(.bottom, 5)
            
            toolbarView()
        }
        .padding(.top, 1)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: navbarLeadingBtn, trailing: navbarTrailingBtn)
        .onAppear() {
            viewModel.markAsUnread(false, chat: chat)
        }
    }
    
    var navbarLeadingBtn: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: chat.person.imgName)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                Text(chat.person.name).bold()
            }
            .foregroundColor(.black)
        }
    }
    
    var navbarTrailingBtn: some View {
        Button(action: {}) {
            HStack {
                Button(action: {}) {
                    Image(systemName: "video")
                }
                Button(action: {}) {
                    Image(systemName: "phone")
                }
            }
        }
    }
    
    func scrollTo(messageID: UUID, anchor: UnitPoint? = nil, shouldAnimate: Bool, scrollReader: ScrollViewProxy) {
        DispatchQueue.main.async {
            withAnimation(shouldAnimate ? .easeIn : nil) {
                scrollReader.scrollTo(messageID, anchor: anchor)
            }
        }
    }
    
    let columns = [GridItem(.flexible(minimum: 0))]
    
    func getMessagesView(viewWidth: CGFloat) -> some View {
        LazyVGrid(columns: columns, spacing: 0, pinnedViews: [.sectionHeaders]) {
            let sectionMessages = viewModel.getSectionMessages(for: chat)
            ForEach(sectionMessages.indices, id: \.self) { sectionIndex in
                let messages = sectionMessages[sectionIndex]
                Section(header: sectionHeader(firstMessage: messages.first!)) {
                    ForEach(messages) { message in
                        let isReceived = message.type == .Received
                        HStack {
                            ZStack {
                                Text(message.text)
                                    .padding(.horizontal)
                                    .padding(.vertical)
                                    .background(isReceived ? Color.black.opacity(0.2) : .green.opacity(0.9))
                                    .cornerRadius(13)
                            }
                            .frame(width: viewWidth * 0.7, alignment: isReceived ? .leading : .trailing)
                            .padding(.vertical)
                        }
                        .frame(maxWidth: .infinity, alignment: isReceived ? .leading : .trailing)
                        .id(message.id)
                    }
                }
            }
        }
    }
    
    func sectionHeader(firstMessage message: Message) -> some View {
        ZStack {
            Text(message.date.descriptiveString(dateStyle: .medium))
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .regular))
                .frame(width: 120)
                .padding(.vertical, 5)
                .background(Capsule().foregroundColor(.blue))
        }
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity)
    }
    
    func toolbarView() -> some View {
        VStack {
            let height: CGFloat = 37
            
            HStack {
                TextField("Message ...", text: $text)
                    .padding(.horizontal, 10)
                    .frame(height: height)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 13))
                    .focused($isFocused)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .frame(width: height, height: height)
                        .background (
                            Circle()
                                .foregroundColor(self.text.isEmpty ? .gray : .blue)
                            )
                }
                .disabled(self.text.isEmpty)
            }
            .frame(height: height)
        }
        .padding(.vertical)
        .padding(.horizontal)
        .background(.thickMaterial)
    }
    
    func sendMessage() {
        if let message = viewModel.sendMessage(self.text, in: chat) {
            self.text = ""
            messageIDToScroll = message.id
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView(chat: Chat.sampleChat[0])
                .environmentObject(ChatsViewModel())
        }
    }
}
