//
//  SkypeClient.m
//  QuickSkype
//
//  Created by Ryota Arai on 5/20/13.
//  Copyright (c) 2013 Ryota Arai. All rights reserved.
//

#import "SkypeClient.h"
#import "Chat.h"

@interface SkypeClient ()

- (NSTextCheckingResult *)_regexMatch:(NSString *)target with:(NSString *)pattern;

@end

@implementation SkypeClient

- (id)init
{
    self = [super init];
    if (self) {
        [SkypeAPI setSkypeDelegate:self];
        [SkypeAPI connect];
        
        _chatManager = [[ChatManager alloc] init];
        _chatManager.delegate = self;
    }
    return self;
}

- (NSTextCheckingResult *)_regexMatch:(NSString *)target with:(NSString *)pattern {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    NSTextCheckingResult *result = [regex firstMatchInString:target options:0 range:NSMakeRange(0, [target length])];
    return result;
}

- (NSString *)sendSkypeCommand:(NSString *)command {
    NSLog(@"sendSkypeCommand: %@", command);
    return [SkypeAPI sendSkypeCommand:command];
}

- (void)sendMessage:(NSString *)message toChat:(Chat *)chat {
    NSString *command = [NSString stringWithFormat:@"CHATMESSAGE %@ %@", chat.name, message];
    [self sendSkypeCommand:command];
}

// ChatManagerDelegate
- (void)chatManagerMessageSatisfied:(Message *)message {
    NSLog(@"chatManagerMessageSatisfied: %@", message);
    if (!message.chat.friendlyName) {
        [self sendSkypeCommand:[NSString stringWithFormat:@"GET CHAT %@ FRIENDLYNAME", message.chatName]];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(skypeClientNewMessage:)]) {
        [_delegate skypeClientNewMessage:message];
    }
}

- (void)chatManagerChatSatisfied:(Chat *)chat {
    NSLog(@"chatManagerChatSatisfied: %@", chat);
    if (_delegate && [_delegate respondsToSelector:@selector(skypeClientNewChat:)]) {
        [_delegate skypeClientNewChat:chat];
    }
}

// SkypeAPIDelegate

- (NSString *)clientApplicationName {
    return @"QuickSkype";
}

- (void)skypeAttachResponse:(unsigned)aAttachResponseCode {
    NSLog(@"skypeAttachResponse: %d", aAttachResponseCode);
}


- (void)skypeNotificationReceived:(NSString*)aNotificationString {
    NSLog(@"skypeNotificationReceived: %@", aNotificationString);
    
    NSTextCheckingResult *result;
    
    result = [self _regexMatch:aNotificationString with:@"MESSAGE (\\d+) STATUS RECEIVED"];
    if (result) {
        NSString *messageIdStr = [aNotificationString substringWithRange:[result rangeAtIndex:1]];
        NSNumber *messageId = [NSNumber numberWithInteger:[messageIdStr integerValue]];
        
        [_chatManager newMessage:messageId];
        
        [self sendSkypeCommand:[NSString stringWithFormat:@"GET CHATMESSAGE %@ BODY", messageIdStr]];
        [self sendSkypeCommand:[NSString stringWithFormat:@"GET CHATMESSAGE %@ CHATNAME", messageIdStr]];
    }

    result = [self _regexMatch:aNotificationString with:@"MESSAGE (\\d+) BODY (.+)"];
    if (result) {
        NSNumber *messageId = [NSNumber numberWithInteger:[[aNotificationString substringWithRange:[result rangeAtIndex:1]] integerValue]];
        NSString *body = [aNotificationString substringWithRange:[result rangeAtIndex:2]];
        
        [_chatManager bodyReceived:body forMessageId:messageId];
    }

    result = [self _regexMatch:aNotificationString with:@"MESSAGE (\\d+) CHATNAME (.+)"];
    if (result) {
        NSNumber *messageId = [NSNumber numberWithInteger:[[aNotificationString substringWithRange:[result rangeAtIndex:1]] integerValue]];
        NSString *chatName = [aNotificationString substringWithRange:[result rangeAtIndex:2]];
        
        [_chatManager chatNameReceived:chatName forMessageId:messageId];
        
        
    }
    
    result = [self _regexMatch:aNotificationString with:@"CHAT (.+) FRIENDLYNAME (.+)"];
    if (result) {
        NSString *chatName = [aNotificationString substringWithRange:[result rangeAtIndex:1]];
        NSString *friendlyName = [aNotificationString substringWithRange:[result rangeAtIndex:2]];
        
        [_chatManager chatFriendlyNameReceived:friendlyName forChatName:chatName];
    }
}

- (void)skypeBecameAvailable:(NSNotification*)aNotification {
    NSLog(@"skypeBecameAvailable");
}

- (void)skypeBecameUnavailable:(NSNotification*)aNotification {
    NSLog(@"skypeBecameUnavailable");
}


@end
