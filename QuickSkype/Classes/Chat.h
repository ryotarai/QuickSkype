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
}

@property NSString *name;

- (void)addMessage:(Message *)message;

@end
