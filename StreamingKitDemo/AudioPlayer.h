//
//  AudioPlayer.h
//  StreamingKitDemo
//
//  Created by Nikolas Gelo on 10/15/14.
//  Copyright (c) 2014 Nikolas Gelo. All rights reserved.
//

#import "STKAudioPlayer.h"

@class Track;

#pragma mark - AudioPlayer

@interface AudioPlayer : STKAudioPlayer

#pragma mark Accessing Audio Player Properties

@property (nonatomic, strong, readonly) NSArray *tracks;
@property (nonatomic, strong, readonly) Track *currentTrack;

#pragma mark Creating and Initializing an Audio Player

- (instancetype)initWithTracks:(NSArray *)tracks;

#pragma mark Configuring the Audio Player

- (void)configureBackgroundAudio;

#pragma mark Playing the Tracks

- (void)playCurrentTrack;
- (void)playPreviousTrack;
- (void)playNextTrack;

@end
