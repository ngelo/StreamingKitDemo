//
//  ViewController.m
//  StreamingKitDemo
//
//  Created by Nikolas Gelo on 10/9/14.
//  Copyright (c) 2014 Nikolas Gelo. All rights reserved.
//

#import "ViewController.h"

#import <StreamingKit/STKAudioPlayer.h>

#import "Track.h"


@interface ViewController () <STKAudioPlayerDelegate>

@property (nonatomic, strong) STKAudioPlayer *audioplayer;

- (IBAction)toggleAudioPlayer:(UIButton *)toggleAudioPlayerButton;

@end

@implementation ViewController

- (IBAction)toggleAudioPlayer:(UIButton *)toggleAudioPlayerButton
{
    // Stop
    if (self.audioplayer.state == STKAudioPlayerStatePlaying) {
        [self.audioplayer stop];
        
        [toggleAudioPlayerButton setTitle:@"Play" forState:UIControlStateNormal];
    }
    
    // Play
    else if (self.audioplayer.state == STKAudioPlayerStatePaused ||
             self.audioplayer.state == STKAudioPlayerStateStopped ||
             self.audioplayer.state == STKAudioPlayerStateReady) {
        // Play the song.
        [self.audioplayer play:@"http://slseduction.parseapp.com/music/SimpleThings-Single.mp3"];
        
        [toggleAudioPlayerButton setTitle:@"Stop" forState:UIControlStateNormal];
    }
    
    else {
        NSLog(@"IDK WHAT HAPPENED");
        NSLog(@"State: %d", self.audioplayer.state);
    }
}

// Observer pattern implementation.
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    
//}

#pragma mark - UIViewController
#pragma mark Managing the View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.audioplayer = [[STKAudioPlayer alloc] init];
    self.audioplayer.delegate = self;
    
    self.tracks = [Track allSongs];

    // Observer pattern implementation.
//    [self.audioplayer addObserver:self
//                       forKeyPath:@"state"
//                          options:NSKeyValueObservingOptionNew
//                          context:nil];
    
}

#pragma mark - STKAudioPlayerDelegate Protocol

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didStartPlayingQueueItemId:(NSObject *)queueItemId
{
    NSLog(@"did Start Playing song");
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject *)queueItemId
{
    NSLog(@"Did finish buffering");
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState
{
    NSLog(@"State changed");
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishPlayingQueueItemId:(NSObject *)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
    NSLog(@"Finished playing");
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode
{
    (NSLog(@"Error"));
}

@end
