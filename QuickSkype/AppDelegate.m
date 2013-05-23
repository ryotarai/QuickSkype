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
    _textField.delegate = self;
    
    

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



- (BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector
{
    BOOL result = NO;
    
    if (commandSelector == @selector(insertNewline:)) {
        // new line action:
        // always insert a line-break character and don’t cause the receiver to end editing
        [textView insertNewlineIgnoringFieldEditor:self];
        result = YES;
    }
//    } else if (commandSelector == @selector(noop:)) {
//        NSEvent *event = [NSApp currentEvent];
//        NSLog(@"%@", event);
//        NSUInteger flags = (event.modifierFlags & NSDeviceIndependentModifierFlagsMask);
//        BOOL isCommand = (flags & NSCommandKeyMask) == NSCommandKeyMask;
//        BOOL isEnter = (event.keyCode == 0x24); // VK_RETURN
//        if (isCommand && isEnter) {
//            [self replyClicked:nil];
//        }
//    }

    
    return result;
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
    Chat *chat = [_chats objectAtIndex:_chatsPopUpButton.selectedTag];
//    [_skypeClient sendMessage:_textField.stringValue toChat:chat];
    [_textField setStringValue:@""];
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



@end
