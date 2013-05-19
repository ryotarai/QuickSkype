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

@required
@optional

@end

@interface SkypeClient : NSObject
<SkypeAPIDelegate>

@property ChatManager* chatManager;
@property(assign) id<SkypeClientDelegate> delegate;

@end
