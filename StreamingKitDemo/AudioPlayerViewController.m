//
//  AudioPlayerViewController.m
//  StreamingKitDemo
//
//  Created by Nikolas Gelo on 10/15/14.
//  Copyright (c) 2014 Nikolas Gelo. All rights reserved.
//

#import "AudioPlayerViewController.h"

#import <StreamingKit/STKAudioPlayer.h>

#import "AudioPlayer.h"
#import "Track.h"

@interface AudioPlayerViewController () <STKAudioPlayerDelegate>

@property (nonatomic, weak) IBOutlet UIButton *toggleAudioPlayerButton;
@property (nonatomic, weak) IBOutlet UIButton *previousTrackButton;
@property (nonatomic, weak) IBOutlet UIButton *nextTrackButton;

@property (nonatomic, weak) IBOutlet UILabel *trackTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *trackArtistAlbumLabel;
@property (nonatomic, weak) IBOutlet UIImageView *albumArtworkImageView;

@property (nonatomic, strong) AudioPlayer *audioPlayer;

- (IBAction)toggleAudioPlayer:(UIButton *)toggleAudioPlayerButton;
- (IBAction)playPreviousTrack:(UIButton *)previousTrackButton;
- (IBAction)playNextTrack:(UIButton *)nextTrackButton;

- (void)setPreviousTrackButtonEnabled:(BOOL)previousTrackButtonEnabled
               nextTrackButtonEnabled:(BOOL)nextTrackButtonEnabled;

@end

@implementation AudioPlayerViewController

//- (void)setCurrentTrackIndex:(NSUInteger)currentTrackIndex
//{
//    _currentTrackIndex = currentTrackIndex;
//    
//    if (_currentTrackIndex == 0) {
//        self.previousTrackButton.enabled = NO;
//        self.nextTrackButton.enabled = YES;
//    } else if (_currentTrackIndex == [self.tracks count] - 1) {
//        self.previousTrackButton.enabled = YES;
//        self.nextTrackButton.enabled = NO;
//    } else {
//        self.previousTrackButton.enabled = YES;
//        self.nextTrackButton.enabled = YES;
//    }
//}

#pragma mark - ViewController

- (IBAction)toggleAudioPlayer:(UIButton *)toggleAudioPlayerButton
{
    // Pause the current track.
    if (self.audioPlayer.state == STKAudioPlayerStatePlaying) {
        [self.audioPlayer pause];
        
//        [toggleAudioPlayerButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
    }
    
    // Play the current track.
    else if (self.audioPlayer.state == STKAudioPlayerStateStopped ||
             self.audioPlayer.state == STKAudioPlayerStateReady) {
        // Play the song.
        [self.audioPlayer playCurrentTrack];
        
        BOOL previousTrackButtonEnabled = !(self.audioPlayer.currentTrackIndex == 0);
        BOOL nextTrackButtonEnabled = !(self.audioPlayer.currentTrackIndex == [self.audioPlayer.tracks count] - 1);
        [self setPreviousTrackButtonEnabled:previousTrackButtonEnabled nextTrackButtonEnabled:nextTrackButtonEnabled];
        
//        [toggleAudioPlayerButton setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
    }
    
    // Resume playing the current track.
    else if (self.audioPlayer.state == STKAudioPlayerStatePaused) {
        [self.audioPlayer resume];
        
//        [toggleAudioPlayerButton setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
    }
}


- (IBAction)playPreviousTrack:(UIButton *)previousTrackButton
{
    [self.audioPlayer playPreviousTrack];
    
    BOOL previousTrackButtonEnabled = !(self.audioPlayer.currentTrackIndex == 0);
    [self setPreviousTrackButtonEnabled:previousTrackButtonEnabled nextTrackButtonEnabled:YES];
}

- (IBAction)playNextTrack:(UIButton *)previousTrackButton
{
    [self.audioPlayer playNextTrack];
    
    BOOL nextTrackButtonEnabled = !(self.audioPlayer.currentTrackIndex == [self.audioPlayer.tracks count] - 1);
    [self setPreviousTrackButtonEnabled:YES nextTrackButtonEnabled:nextTrackButtonEnabled];
}

- (void)setPreviousTrackButtonEnabled:(BOOL)previousTrackButtonEnabled
               nextTrackButtonEnabled:(BOOL)nextTrackButtonEnabled
{
    self.previousTrackButton.enabled = previousTrackButtonEnabled;
    self.nextTrackButton.enabled = nextTrackButtonEnabled;
}


//- (void)playCurrentTrack
//{
//    // Get the current track.
//    Track *currentTrack = [self.tracks objectAtIndex:self.currentTrackIndex];
//    
//    NSLog(@"%@", [currentTrack description]);
//    
//    // Update the UI elements 
//    self.trackTitleLabel.text = currentTrack.title;
//    self.trackArtistAlbumLabel.text = [NSString stringWithFormat:@"%@ -- %@", currentTrack.artist, currentTrack.album];
//    self.albumArtworkImageView.image = currentTrack.albumArtwork;
//    
//    // Stop the current track.
//    [self.audioPlayer stop];
//    
//    NSLog(@"Current audio player state: %d", self.audioPlayer.state);
//    
//    // Start streaming the track.
//    [self.audioPlayer playURL:currentTrack.streamingURL];
//}

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
    
    self.audioPlayer = [[AudioPlayer alloc] initWithTracks:[Track allTracks]];
    [self.audioPlayer configureBackgroundAudio];
    self.audioPlayer.delegate = self;
    
    // Observer pattern implementation.
//    [self.audioplayer addObserver:self
//                       forKeyPath:@"state"
//                          options:NSKeyValueObservingOptionNew
//                          context:nil];
    
}

#pragma mark - STKAudioPlayerDelegate Protocol

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didStartPlayingQueueItemId:(NSObject *)queueItemId
{
    // Checking what the instance's class is for mp3 data extraction.
//    NSLog(@"Queue Item Class: %@", NSStringFromClass([queueItemId class]));
    
//    NSLog(@"Current track duration: %.2f", audioPlayer.duration);
    
    NSLog(@"Did start playing song");
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject *)queueItemId
{
    NSLog(@"Current track duration: %.2f", audioPlayer.duration);
    
    NSLog(@"Did finish buffering");
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState
{
    NSLog(@"Audio player state changed to %d from %d", state, previousState);
    
    if (state & STKAudioPlayerStateRunning) {
        self.trackTitleLabel.text = self.audioPlayer.currentTrack.title;
        self.trackArtistAlbumLabel.text = [NSString stringWithFormat:@"%@ -- %@", self.audioPlayer.currentTrack.artist, self.audioPlayer.currentTrack.album];
        self.albumArtworkImageView.image = self.audioPlayer.currentTrack.albumArtwork;
    }
    
    if (state == STKAudioPlayerStatePaused) {
        [self.toggleAudioPlayerButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
    } else if (state == STKAudioPlayerStatePlaying) {
        [self.toggleAudioPlayerButton setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
    }
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishPlayingQueueItemId:(NSObject *)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
    NSLog(@"Finished playing");
    
//    // Check if last song.
//    if (self.currentTrackIndex == [self.tracks count] - 1) {
//        NSLog(@"Played last song");
//        
////        self.currentTrackIndex = 0;
//        
////        [self playCurrentTrack];
//    }
//    
//    // Play next song
//    else {
////        self.currentTrackIndex++;
//        
//        [self playCurrentTrack];
//    }
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode
{
    NSLog(@"Audio player encountered unexpected error #%d", errorCode);
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer logInfo:(NSString *)line
{
    NSLog(@"Audio player log info: %@", line);
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didCancelQueuedItems:(NSArray *)queuedItems
{
    NSLog(@"# queue items were cancelled: %lu", (unsigned long)[queuedItems count]);
}

@end
