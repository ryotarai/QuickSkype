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
    }
    return self;
}

@end
