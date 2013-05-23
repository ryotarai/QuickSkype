//
//  ChatList.m
//  QuickSkype
//
//  Created by Ryota Arai on 5/20/13.
//  Copyright (c) 2013 Ryota Arai. All rights reserved.
//

#import "ChatManager.h"
#import "Message.h"
#import "Chat.h"

@interface ChatManager ()

- (void)_checkSatisfiedMessage:(Message *)message;
- (void)_checkSatisfiedChat:(Chat *)chat;
- (void)_addMessageToChat:(Message *)message;

@end

@implementation ChatManager

- (id)init
{
    self = [super init];
    if (self) {
        _tempMessages = [[NSMutableDictionary alloc] init];
        _chats = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSArray *)chats {
    return [_chats allValues];
}

- (void)_checkSatisfiedMessage:(Message *)message {
    if ([message isSatisfied]) {
        [self _addMessageToChat:message];
        if (_delegate && [_delegate respondsToSelector:@selector(chatManagerMessageSatisfied:)]) {
            [_delegate chatManagerMessageSatisfied:message];
        }
    }
}

- (void)_checkSatisfiedChat:(Chat *)chat {
    if ([chat isSatisfied]) {
        if (_delegate && [_delegate respondsToSelector:@selector(chatManagerChatSatisfied:)]) {
            [_delegate chatManagerChatSatisfied:chat];
        }
    }
}

- (void)_addMessageToChat:(Message *)message {
    Chat *chat = [_chats objectForKey:message.chatName];
    if (!chat) {
        chat = [[Chat alloc] init];
        chat.name = message.chatName;
        [_chats setObject:chat forKey:message.chatName];
    }
    [chat addMessage:message];
}

- (void)newMessage:(NSNumber *)messageId {
    Message *message = [[Message alloc] init];
    message.identity = messageId;
    [_tempMessages setObject:message forKey:messageId];
}

- (void)bodyReceived:(NSString *)body forMessageId:(NSNumber *)messageId {
    NSLog(@"bodyReceived: %@, %@", body, messageId);
    
    Message *message = [_tempMessages objectForKey:messageId];
    message.body = body;
    
    [self _checkSatisfiedMessage:message];
}

- (void)chatNameReceived:(NSString *)chatName forMessageId:(NSNumber *)messageId {
    NSLog(@"chatNameReceived: %@, %@", chatName, messageId);

    Message *message = [_tempMessages objectForKey:messageId];
    message.chatName = chatName;
    
    [self _checkSatisfiedMessage:message];
}

- (void)fromHandleReceived:(NSString *)handle forMessageId:(NSNumber *)messageId {
    NSLog(@"fromHandleReceived: %@, %@", handle, messageId);
    
    Message *message = [_tempMessages objectForKey:messageId];
    message.fromHandle = handle;
    
    [self _checkSatisfiedMessage:message];
}

- (void)fromDisplayNameReceived:(NSString *)displayName forMessageId:(NSNumber *)messageId {
    NSLog(@"fromDisplayNameReceived: %@, %@", displayName, messageId);
    
    Message *message = [_tempMessages objectForKey:messageId];
    message.fromDisplayName = displayName;
    
    [self _checkSatisfiedMessage:message];
}

- (void)chatFriendlyNameReceived:(NSString *)friendlyName forChatName:(NSString *)chatName {
    Chat *chat = [_chats objectForKey:chatName];
    chat.friendlyName = friendlyName;
    
    [self _checkSatisfiedChat:chat];
}


@end
