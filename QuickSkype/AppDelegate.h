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
<NSApplicationDelegate, SkypeClientDelegate> {
    SkypeClient *_skypeClient;
    NSMutableArray *_chats;
    id _hotKeyEventMonitor;
}


@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSPopUpButton *chatsPopUpButton;



- (IBAction)replyClicked:(id)sender;


@end
