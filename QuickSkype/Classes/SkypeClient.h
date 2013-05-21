//
//  SkypeClient.h
//  QuickSkype
//
//  Created by Ryota Arai on 5/20/13.
//  Copyright (c) 2013 Ryota Arai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Skype/Skype.h>

#import "ChatManager.h"

@protocol SkypeClientDelegate <NSObject>

@optional
- (void)skypeClientNewMessage:(Message *)message;

@end

@interface SkypeClient : NSObject
<SkypeAPIDelegate, ChatManagerDelegate>

@property ChatManager* chatManager;
@property(assign) id<SkypeClientDelegate> delegate;

@end
