//
//  SkypeClient.m
//  QuickSkype
//
//  Created by Ryota Arai on 5/20/13.
//  Copyright (c) 2013 Ryota Arai. All rights reserved.
//

#import "SkypeClient.h"

@implementation SkypeClient

- (id)init
{
    self = [super init];
    if (self) {
        [SkypeAPI setSkypeDelegate:self];
        [SkypeAPI connect];
        
        _chatManager = [[ChatManager alloc] init];
    }
    return self;
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
    
    
    
    NSRegularExpression *regex;
    NSTextCheckingResult *result;
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"MESSAGE (\\d+) STATUS RECEIVED" options:0 error:NULL];
    result = [regex firstMatchInString:aNotificationString options:0 range:NSMakeRange(0, [aNotificationString length])];
    if (result) {
        NSString *messageIdStr = [aNotificationString substringWithRange:[result rangeAtIndex:1]];
        
        [SkypeAPI sendSkypeCommand:[NSString stringWithFormat:@"GET CHATMESSAGE %@ BODY", messageIdStr]];
        [SkypeAPI sendSkypeCommand:[NSString stringWithFormat:@"GET CHATMESSAGE %@ CHATNAME", messageIdStr]];
    }

    regex = [NSRegularExpression regularExpressionWithPattern:@"MESSAGE (\\d+) BODY (.+)" options:0 error:NULL];
    result = [regex firstMatchInString:aNotificationString options:0 range:NSMakeRange(0, [aNotificationString length])];
    if (result) {
        NSNumber *messageId = [NSNumber numberWithInteger:[[aNotificationString substringWithRange:[result rangeAtIndex:1]] integerValue]];
        NSString *body = [aNotificationString substringWithRange:[result rangeAtIndex:2]];
        
        [_chatManager bodyReceived:body ForMessageId:messageId];
    }

    regex = [NSRegularExpression regularExpressionWithPattern:@"MESSAGE (\\d+) CHATNAME (.+)" options:0 error:NULL];
    result = [regex firstMatchInString:aNotificationString options:0 range:NSMakeRange(0, [aNotificationString length])];
    if (result) {
        NSNumber *messageId = [NSNumber numberWithInteger:[[aNotificationString substringWithRange:[result rangeAtIndex:1]] integerValue]];
        NSString *chatName = [aNotificationString substringWithRange:[result rangeAtIndex:2]];
        
        [_chatManager chatNameReceived:chatName ForMessageId:messageId];
    }
}

- (void)skypeBecameAvailable:(NSNotification*)aNotification {
    NSLog(@"skypeBecameAvailable");
}

- (void)skypeBecameUnavailable:(NSNotification*)aNotification {
    NSLog(@"skypeBecameUnavailable");
}


@end
