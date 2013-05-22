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
    _chats = [[NSMutableArray alloc] init];
    
}

- (void)applicationWillTerminate:(NSNotification *)notification {
}

- (void)awakeFromNib {
    _skypeClient = [[SkypeClient alloc] init];
    [_skypeClient setDelegate:self];
}


// PopUpButton
- (void)reloadPopUpButton {
    [_chats removeAllObjects];
    NSMenu *menu = [[NSMenu alloc] init];
    for (Chat *chat in [_skypeClient.chatManager chats]) {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:chat.friendlyName action:NULL keyEquivalent:@""];
        item.tag = [_chats count];
        [_chats addObject:chat];
        [menu insertItem:item atIndex:0];
    }
    _chatsPopUpButton.menu = menu;
}

// SkypeClientDelegate
- (void)skypeClientNewMessage:(Message *)message {
    NSLog(@"skypeClientNewMessage: %@", message);
}

- (void)skypeClientNewChat:(Chat *)chat {
    NSLog(@"skypeClientNewChat: %@", chat);
    [self reloadPopUpButton];
}

- (IBAction)replyClicked:(id)sender {
    Chat *chat = [_chats objectAtIndex:_chatsPopUpButton.selectedTag];
    [_skypeClient sendMessage:self.textView.textStorage.string toChat:chat];
}



@end
