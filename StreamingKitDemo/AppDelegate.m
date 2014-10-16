//
//  AppDelegate.m
//  StreamingKitDemo
//
//  Created by Nikolas Gelo on 10/9/14.
//  Copyright (c) 2014 Nikolas Gelo. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - UIResponder
#pragma mark Responding to Remote-Control Events

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                NSLog(@"Play");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TogglePlayPause" object:nil];
                break;
            case UIEventSubtypeRemoteControlPause:
                NSLog(@"Pause");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TogglePlayPause" object:nil];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"PreviousTrack");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayPreviousTrack" object:nil];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"Next Track");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayNextTrack" object:nil];
                break;
            default:
                break;
        }
    }
}

#pragma mark - UIApplicationDelegate
#pragma mark Monitoring App State Changes

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

@end
