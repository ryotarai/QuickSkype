//
//  Message.h
//  QuickSkype
//
//  Created by Ryota Arai on 5/19/13.
//  Copyright (c) 2013 Ryota Arai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property NSInteger identity;
@property NSString* chatName;
@property NSString* body;

@end
