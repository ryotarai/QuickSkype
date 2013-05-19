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

@implementation ChatManager

- (id)init
{
    self = [super init];
    if (self) {
        _tempMessages = [[NSMutableDictionary alloc] init];
        _messageChatMap = [[NSMutableDictionary alloc] init];
        _latestChatNames = [[NSMutableArray alloc] init];
        _chats = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSArray *)latestChats {
    NSMutableArray *chats = [[NSMutableArray alloc] init];
    for (NSString *chatName in _latestChatNames) {
        [chats addObject:[_chats objectForKey:chatName]];
    }
    return [chats copy];
}

- (void)bodyReceived:(NSString *)body ForMessageId:(NSNumber *)messageId {
    NSLog(@"bodyReceived: %@, %@", body, messageId);
    
    Message *message = [_tempMessages objectForKey:messageId];
    if (!message) {
        NSString *chatName = [_messageChatMap objectForKey:messageId];
        if (chatName) {
            Chat *chat = [_chats objectForKey:chatName];
            message = [chat.messages objectForKey:messageId];
        } else {
            message = [[Message alloc] init];
            [_tempMessages setObject:message forKey:messageId];
        }
    }
    message.body = body;
}

- (void)chatNameReceived:(NSString *)chatName ForMessageId:(NSNumber *)messageId {
    NSLog(@"chatNameReceived: %@, %@", chatName, messageId);
    
    Chat *chat = [_chats objectForKey:chatName];
    if (!chat) {
        chat = [[Chat alloc] init];
        [_chats setObject:chat forKey:chatName];
    }

    Message *message = [_tempMessages objectForKey:messageId];
    if (message) {
        [chat.messages setObject:message forKey:messageId];
        [_messageChatMap setObject:chatName forKey:messageId];
        [_tempMessages removeObjectForKey:messageId];
    }
    
    [_latestChatNames removeObject:chatName];
    [_latestChatNames insertObject:chatName atIndex:0];
}

@end
