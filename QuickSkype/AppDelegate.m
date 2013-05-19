//
//  AppDelegate.m
//  QuickSkype
//
//  Created by Ryota Arai on 5/19/13.
//  Copyright (c) 2013 Ryota Arai. All rights reserved.
//

#import "AppDelegate.h"

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
    NSArray *chats = [_skypeClient.chatManager latestChats];
    
}



- (IBAction)replyClicked:(id)sender {
    NSLog(@"%@", self.textView.textStorage.string);
}
@end
