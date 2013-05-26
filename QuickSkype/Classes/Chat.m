//
//  Chat.m
//  QuickSkype
//
//  Created by Ryota Arai on 5/20/13.
//  Copyright (c) 2013 Ryota Arai. All rights reserved.
//

#import "Chat.h"

@implementation Chat

- (id)init
{
    self = [super init];
    if (self) {
        _messages = [[NSMutableDictionary alloc] init];
        _messageIds = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)isSatisfied {
    return _name && _friendlyName;
}

- (NSArray *)latestMessages {
    NSEnumerator *messageIds = [_messageIds reverseObjectEnumerator];
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    for (NSNumber *messageId in messageIds) {
        [messages addObject:[_messages objectForKey:messageId]];
    }
    return [messages copy];
}

- (void)addMessage:(Message *)message {
    message.chat = self;
    [_messages setObject:message forKey:message.identity];
    [_messageIds addObject:message.identity];
}

@end
