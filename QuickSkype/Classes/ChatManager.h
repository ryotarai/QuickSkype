//
//  ChatList.h
//  QuickSkype
//
//  Created by Ryota Arai on 5/20/13.
//  Copyright (c) 2013 Ryota Arai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@protocol ChatManagerDelegate <NSObject>

@optional
- (void)chatManagerMessageSatisfied:(Message *)message;
- (void)chatManagerChatSatisfied:(Chat *)chat;

@end

@interface ChatManager : NSObject {
    NSMutableDictionary *_tempMessages; // messageId -> Message
    NSMutableDictionary* _chats; // chatName -> Chat
}

@property(assign) id<ChatManagerDelegate> delegate;

- (NSArray *)chats;
- (void)newMessage:(NSNumber *)messageId;
- (void)bodyReceived:(NSString *)body forMessageId:(NSNumber *)messageId;
- (void)chatNameReceived:(NSString *)chatName forMessageId:(NSNumber *)messageId;
- (void)fromHandleReceived:(NSString *)handle forMessageId:(NSNumber *)messageId;
- (void)fromDisplayNameReceived:(NSString *)displayName forMessageId:(NSNumber *)messageId;
- (void)timestampReceived:(NSNumber *)timestamp forMessageId:(NSNumber *)messageId;
- (void)chatFriendlyNameReceived:(NSString *)friendlyName forChatName:(NSString *)chatName;
@end
