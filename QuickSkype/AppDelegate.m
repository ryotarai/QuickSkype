//
//  AppDelegate.m
//  QuickSkype
//
//  Created by Ryota Arai on 5/19/13.
//  Copyright (c) 2013 Ryota Arai. All rights reserved.
//

#import "DDHotKeyCenter.h"
#import "AppDelegate.h"
#import "Chat.h"
#import "PreferencesWindowController.h"

@interface AppDelegate ()
- (Chat *)_selectedChat;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    _chats = [[NSMutableArray alloc] init];
    
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    NSLog(@"applicationWillTerminate");
}

- (void)awakeFromNib {
    _skypeClient = [[SkypeClient alloc] init];
    [_skypeClient setDelegate:self];
    
    DDHotKeyCenter *hotKeyCenter = [[DDHotKeyCenter alloc] init];
    if (![hotKeyCenter registerHotKeyWithKeyCode:0x31 modifierFlags:(NSShiftKeyMask|NSCommandKeyMask) target:self action:@selector(switchForeground) object:nil]) {
        NSLog(@"Failed to register hotkey");
    }
}

- (void)switchForeground {
    [_window makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
}


- (Chat *)_selectedChat {
    return [_chats objectAtIndex:_chatsPopUpButton.selectedTag];
}

// PopUpButton
- (void)reloadPopUpButton {
    [_chats removeAllObjects];
    NSMenu *menu = [[NSMenu alloc] init];
    NSEnumerator *chats = [[_skypeClient.chatManager chats] reverseObjectEnumerator];
    for (Chat *chat in chats) {
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
    if (_chatsPopUpButton.selectedTag < 0) {
        NSLog(@"No chat is selected");
        return;
    }
    Chat *chat = [self _selectedChat];
    [_skypeClient sendMessage:_textView.string toChat:chat];
    [_textView setString:@""];
}

- (IBAction)nextChat:(id)sender {
    NSInteger selectedTag = _chatsPopUpButton.selectedTag;
    if (selectedTag < 0) return;
    NSInteger tag = _chatsPopUpButton.selectedTag + 1;
    if (tag >= _chats.count) tag = 0;
    [_chatsPopUpButton selectItemWithTag:tag];
}

- (IBAction)previousChat:(id)sender {
    NSInteger selectedTag = _chatsPopUpButton.selectedTag;
    if (selectedTag < 0) return;
    NSInteger tag = _chatsPopUpButton.selectedTag - 1;
    if (tag < 0) tag = _chats.count - 1;
    [_chatsPopUpButton selectItemWithTag:tag];
}

- (IBAction)editFilteringRules:(id)sender {
    NSString *rulesFilePath = [_skypeClient.notifier rulesFilePath];
    [[NSWorkspace sharedWorkspace] openFile:rulesFilePath];
}

- (IBAction)quoteLastMessage:(id)sender {
    Message *latestMessage = [[[self _selectedChat] latestMessages] objectAtIndex:0];
    NSString *body = [[@"> " stringByAppendingString:[latestMessage.body stringByReplacingOccurrencesOfString:@"\n" withString:@"\n> "]] stringByAppendingString:@"\n"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd', at 'HH:mm";
    NSString *quote = [NSString stringWithFormat:@"On %@, %@ wrote:\n%@",
                       [dateFormatter stringFromDate:latestMessage.timestamp],
                       latestMessage.fromDisplayName,
                       body];
    [_textView insertText:quote];
}

- (IBAction)showPreferences:(id)sender {
    PreferencesWindowController *controller = [[PreferencesWindowController alloc] init];
    [controller showWindow:self];
}



@end
