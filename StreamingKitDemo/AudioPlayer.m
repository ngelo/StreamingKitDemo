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

@interface AudioPlayer () <AVAudioSessionDelegate>

@property (nonatomic, strong, readwrite) NSArray *tracks;

@property (nonatomic, strong, readwrite) Track *currentTrack;

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

- (NSUInteger)currentTrackIndex
{
    return [self.tracks indexOfObject:self.currentTrack];
}

#pragma mark Creating and Initializing an Audio Player

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(togglePlayPause) name:@"TogglePlayPause" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playPreviousTrack) name:@"PlayPreviousTrack" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playNextTrack) name:@"PlayNextTrack" object:nil];
    }
    return self;
}

- (instancetype)initWithTracks:(NSArray *)tracks
{
    self = [self init];
    if (self) {
        self.tracks = tracks;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Configuring the Audio Player

- (void)configureBackgroundAudio
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
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
    // Start streaming and playing the current track.
    [self playURL:self.currentTrack.streamingURL];
    
    // Configure the device's media player info center.
    MPNowPlayingInfoCenter *infoCenter = [MPNowPlayingInfoCenter defaultCenter];
    infoCenter.nowPlayingInfo = @{MPMediaItemPropertyAlbumTitle: self.currentTrack.album,
                                  MPMediaItemPropertyArtist: self.currentTrack.artist,
                                  MPMediaItemPropertyArtwork: [[MPMediaItemArtwork alloc] initWithImage:self.currentTrack.albumArtwork],
                                  MPMediaItemPropertyTitle: self.currentTrack.title};
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
    if (currentTrackIndex == [self.tracks count] - 1) {
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

- (void)togglePlayPause
{
    if (self.state == STKAudioPlayerStatePlaying) {
        [self pause];
    } else if (self.state == STKAudioPlayerStatePaused) {
        [self resume];
    }
}

@end
