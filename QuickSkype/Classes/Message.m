//
//  Message.m
//  QuickSkype
//
//  Created by Ryota Arai on 5/19/13.
//  Copyright (c) 2013 Ryota Arai. All rights reserved.
//

#import "Message.h"

@implementation Message

- (BOOL)isSatisfied {
    return _identity && _chatName && _body;
}

@end
