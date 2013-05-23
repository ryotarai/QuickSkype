//
//  SkypeNotifier.m
//  QuickSkype
//
//  Created by Ryota Arai on 5/23/13.
//  Copyright (c) 2013 Ryota Arai. All rights reserved.
//

#import "SkypeNotifier.h"

@interface SkypeNotifier ()

- (NSString *)_scriptPath;
- (NSString *)_sampleRuleFilePath;
- (NSArray *)_argumentsForMessage:(Message *)message;

- (BOOL)_needNotifyMessage:(Message *)message;

@end

@implementation SkypeNotifier

- (id)init
{
    self = [super init];
    if (self) {
        [GrowlApplicationBridge setGrowlDelegate:self];
        [self rulesFilePath];
    }
    return self;
}

// GrowlApplicationBridgeDelegate
- (NSString *)applicationNameForGrowl {
    return @"QuickSkype";
}

- (NSDictionary *)registrationDictionaryForGrowl {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSArray arrayWithObjects:@"New Message", nil],
            GROWL_NOTIFICATIONS_ALL,
            [NSArray arrayWithObjects:@"", nil],
            GROWL_NOTIFICATIONS_DEFAULT,
            nil];
}

- (NSData *) applicationIconDataForGrowl {
    NSString *iconPath = [[NSBundle mainBundle] pathForResource:@"icon_256x256" ofType:@"png"];
    return [NSData dataWithContentsOfFile:iconPath];
}

/////////////////

- (NSString *)rulesFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:@"QuickSkype"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:NULL];
    }
    
    path = [path stringByAppendingPathComponent:@"filter_rules.rb"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] copyItemAtPath:[self _sampleRuleFilePath]
                                                toPath:path
                                                 error:NULL];
    }
    return path;
}

- (NSString *)_sampleRuleFilePath {
    return [[NSBundle mainBundle] pathForResource:@"sample_rule" ofType:@"rb" inDirectory:@""];
}

- (NSString *)_scriptPath {
    return [[NSBundle mainBundle] pathForResource:@"filter" ofType:@"rb" inDirectory:@""];
}

- (NSArray *)_argumentsForMessage:(Message *)message {
    return [NSArray arrayWithObjects:
            [self _scriptPath],
            [self rulesFilePath],
            message.body,
            message.fromHandle,
            message.fromDisplayName,
            message.chat.name,
            message.chat.friendlyName,
            nil];
}

- (BOOL)_needNotifyMessage:(Message *)message {
    NSTask *task = [[NSTask alloc] init];
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file = [pipe fileHandleForReading];
    
    [task setLaunchPath: @"/usr/bin/ruby"];
    [task setArguments: [self _argumentsForMessage:message]];
    [task setStandardOutput: pipe];
    [task launch];
    
    NSString *result = [[NSString alloc] initWithData: [file readDataToEndOfFile] encoding: NSUTF8StringEncoding];
    if ([result isEqualToString:@"accept"]) {
        return YES;
    }
    return NO;
}


- (NSString *)rules {
    return _rules;
}

- (void)setRules:(NSString *)rules {
    _rules = rules;
    
    NSString *path = [self rulesFilePath];
    NSError *error;
    [_rules writeToFile:path
             atomically:YES
               encoding:NSUnicodeStringEncoding
                  error:&error];
}

- (void)notifyMessage:(Message *)message {
    if ([self _needNotifyMessage:message]) {
        // notify
        [GrowlApplicationBridge notifyWithTitle:message.fromDisplayName
                                    description:message.body
                               notificationName:@"New Message"
                                       iconData:nil
                                       priority:0
                                       isSticky:NO
                                   clickContext:nil];
        NSLog(@"notification accepted");
    } else {
        NSLog(@"notification rejected");
    }
}

@end
