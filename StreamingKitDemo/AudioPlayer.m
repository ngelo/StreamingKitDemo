//
//  AudioPlayer.m
//  StreamingKitDemo
//
//  Created by Nikolas Gelo on 10/15/14.
//  Copyright (c) 2014 Nikolas Gelo. All rights reserved.
//

#import "AudioPlayer.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

#import "Track.h"

@interface AudioPlayer ()

@property (nonatomic, strong, readwrite) NSArray *tracks;

@property (nonatomic, strong, readwrite) Track *currentTrack;

@property (nonatomic, strong) MPMoviePlayerController *audioPlayer;

@end

@implementation AudioPlayer

#pragma mark - AudioPlayer
#pragma mark Accessing Audio Player Properties

- (Track *)currentTrack
{
    if (!_currentTrack && [self.tracks count] > 0) {
        _currentTrack = [self.tracks objectAtIndex:0];
    }
    return _currentTrack;
}

#pragma mark Creating and Initializing an Audio Player

- (instancetype)initWithTracks:(NSArray *)tracks
{
    self = [super init];
    if (self) {
        self.tracks = tracks;
        
        self.audioPlayer = [[MPMoviePlayerController alloc] initWithContentURL:self.currentTrack.streamingURL];
        self.audioPlayer.controlStyle = MPMovieControlStyleEmbedded;
        self.audioPlayer.shouldAutoplay = NO;
        self.audioPlayer.view.hidden = YES;
        [self.audioPlayer prepareToPlay];
    }
    return self;
}

#pragma mark Configuring the Audio Player

- (void)configureBackgroundAudio
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError;
    BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    if (!success) {
        NSLog(@"Error setting audio session background audio");
    }
    
    NSError *activationError;
    success = [audioSession setActive:YES error:&activationError];
    if (!success) {
        NSLog(@"Activation error");
    }
}

#pragma mark Playing the Tracks

- (void)playCurrentTrack
{
    // If the audio player is currently playing, stop it.
    if (self.state == STKAudioPlayerStatePlaying) {
        [self stop];
    }
    
    // Start streaming and playing the current track.
    [self playURL:self.currentTrack.streamingURL];
    
    // Configure the device's media player info center.
    MPNowPlayingInfoCenter *infoCenter = [MPNowPlayingInfoCenter defaultCenter];
    infoCenter.nowPlayingInfo = @{MPMediaItemPropertyTitle: @"Simple Things"};
}

- (void)playPreviousTrack
{
    // If the current track is the first track, do not play the previous track.
    NSUInteger currentTrackIndex = [self.tracks indexOfObject:self.currentTrack];
    if (currentTrackIndex == 0) {
        NSLog(@"Current track is the first track");
        return;
    }
    
    // Decrement the current track index and set the new current track.
    currentTrackIndex--;
    self.currentTrack = [self.tracks objectAtIndex:currentTrackIndex];
    
    // Play the new current track.
    [self playCurrentTrack];
}

- (void)playNextTrack
{
    // If the current track is the last track, do not play the previous track.
    NSUInteger currentTrackIndex = [self.tracks indexOfObject:self.currentTrack];
    if (currentTrackIndex >= [self.tracks count]) {
        NSLog(@"Current track is the first track");
        return;
    }
    
    NSLog(@"play next track");
    
    // Increment the current track index and set the new current track.
    currentTrackIndex++;
    self.currentTrack = [self.tracks objectAtIndex:currentTrackIndex];
    
    // Play the new current track.
    [self playCurrentTrack];
}

@end
