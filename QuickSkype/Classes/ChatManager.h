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

@end

@interface ChatManager : NSObject {
    NSMutableDictionary *_tempMessages; // messageId -> Message
}

@property(assign) id<ChatManagerDelegate> delegate;
@property NSMutableDictionary* chats; // chatName -> Chat

- (void)newMessage:(NSNumber *)messageId;
- (void)bodyReceived:(NSString *)body forMessageId:(NSNumber *)messageId;
- (void)chatNameReceived:(NSString *)chatName forMessageId:(NSNumber *)messageId;

@end