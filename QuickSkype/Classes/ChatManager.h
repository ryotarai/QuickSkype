//
//  ChatList.h
//  QuickSkype
//
//  Created by Ryota Arai on 5/20/13.
//  Copyright (c) 2013 Ryota Arai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatManager : NSObject {
    NSMutableDictionary *_tempMessages; // messageId -> Message
    NSMutableDictionary *_messageChatMap; // messageId -> chatName
    NSMutableArray *_latestChatNames; // chatName
}

@property NSMutableDictionary* chats; // chatName -> Chat

- (NSArray *)latestChats;
- (void)bodyReceived:(NSString *)body ForMessageId:(NSNumber *)messageId;
- (void)chatNameReceived:(NSString *)chatName ForMessageId:(NSNumber *)messageId;

@end
