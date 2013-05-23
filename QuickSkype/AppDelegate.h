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
SkypeClientDelegate,
NSTextFieldDelegate> {
    SkypeClient *_skypeClient;
    NSMutableArray *_chats;
    id _hotKeyEventMonitor;
}


@property (weak) IBOutlet NSTextField *textField;
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSPopUpButton *chatsPopUpButton;



- (IBAction)replyClicked:(id)sender;
- (IBAction)nextChat:(id)sender;
- (IBAction)previousChat:(id)sender;


@end
