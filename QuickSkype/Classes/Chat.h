//
//  Chat.h
//  QuickSkype
//
//  Created by Ryota Arai on 5/20/13.
//  Copyright (c) 2013 Ryota Arai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface Chat : NSObject {
    NSMutableDictionary *_messages;
    NSMutableArray *_messageIds;
}

@property NSString *name;
@property NSString *friendlyName;

- (BOOL)isSatisfied;
- (void)addMessage:(Message *)message;
- (NSArray *)latestMessages;

@end
