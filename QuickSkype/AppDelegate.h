//
//  AppDelegate.h
//  QuickSkype
//
//  Created by Ryota Arai on 5/19/13.
//  Copyright (c) 2013 Ryota Arai. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SkypeClient.h"

@interface AppDelegate : NSObject
<NSApplicationDelegate,
SkypeClientDelegate> {
    SkypeClient *_skypeClient;
    NSMutableArray *_chats;
    id _hotKeyEventMonitor;
}


@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSPopUpButton *chatsPopUpButton;
@property (unsafe_unretained) IBOutlet NSTextView *textView;



- (IBAction)replyClicked:(id)sender;
- (IBAction)nextChat:(id)sender;
- (IBAction)previousChat:(id)sender;
- (IBAction)editFilteringRules:(id)sender;
- (IBAction)quoteLastMessage:(id)sender;
- (IBAction)showPreferences:(id)sender;


@end
