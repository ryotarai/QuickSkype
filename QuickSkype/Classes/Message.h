//
//  Message.h
//  QuickSkype
//
//  Created by Ryota Arai on 5/19/13.
//  Copyright (c) 2013 Ryota Arai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Chat;

@interface Message : NSObject

@property NSNumber* identity;
@property NSString* chatName;
@property NSString* body;
@property NSString* fromHandle;
@property NSString* fromDisplayName;
@property Chat* chat;

- (BOOL)isSatisfied;

@end
