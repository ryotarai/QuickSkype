//
//  AppDelegate.m
//  QuickSkype
//
//  Created by Ryota Arai on 5/19/13.
//  Copyright (c) 2013 Ryota Arai. All rights reserved.
//

#import "AppDelegate.h"
#import "Chat.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void)awakeFromNib {
    _skypeClient = [[SkypeClient alloc] init];
    [_skypeClient setDelegate:self];
}

// PopUpButton
- (void)reloadPopUpButton {
    NSMenu *menu = [[NSMenu alloc] init];
    for (Chat *chat in [_skypeClient.chatManager chats]) {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:chat.name action:NULL keyEquivalent:@""];
        [menu insertItem:item atIndex:0];
    }
    _chatsPopUpButton.menu = menu;
}

// SkypeClientDelegate
- (void)skypeClientNewMessage:(Message *)message {
    NSLog(@"skypeClientNewMessage: %@", message);
    
}

- (IBAction)replyClicked:(id)sender {
    NSLog(@"%@", self.textView.textStorage.string);
}
@end
