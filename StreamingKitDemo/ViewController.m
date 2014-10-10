//
//  ViewController.m
//  StreamingKitDemo
//
//  Created by Nikolas Gelo on 10/9/14.
//  Copyright (c) 2014 Nikolas Gelo. All rights reserved.
//

#import "ViewController.h"
#import <StreamingKit/STKAudioPlayer.h>


@interface ViewController () <STKAudioPlayerDelegate>

@property (nonatomic, strong) STKAudioPlayer *audioplayer;

- (IBAction)play:(UIButton *)playButton;

@end

@implementation ViewController

- (IBAction)play:(UIButton *)playButton
{
    [self.audioplayer play:@"http://slseduction.parseapp.com/music/SimpleThings-Single.mp3"];
    
    playButton.titleLabel.text = @"Stop";
}

#pragma mark - UIViewController
#pragma mark Managing the View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.audioplayer = [[STKAudioPlayer alloc] init];
    self.audioplayer.delegate = self;
    
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
