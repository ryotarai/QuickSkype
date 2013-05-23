//
//  SkypeNotifier.h
//  QuickSkype
//
//  Created by Ryota Arai on 5/23/13.
//  Copyright (c) 2013 Ryota Arai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Growl/Growl.h>
#import "Message.h"
#import "Chat.h"

@interface SkypeNotifier : NSObject
<GrowlApplicationBridgeDelegate>{
    NSString *_rules;
    NSString *_ruleFilePath;
}

- (NSString *)rules;
- (NSString *)rulesFilePath;
- (void)setRules:(NSString *)rules;
- (void)notifyMessage:(Message *)message;

@end
