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

@property (nonatomic, weak) IBOutlet UIButton *previousTrackButton;
@property (nonatomic, weak) IBOutlet UIButton *nextTrackButton;

@property (nonatomic, weak) IBOutlet UILabel *trackTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *trackArtistAlbumLabel;
@property (nonatomic, weak) IBOutlet UIImageView *albumArtworkImageView;

@property (nonatomic, strong) STKAudioPlayer *audioplayer;

@property (nonatomic, strong) NSArray *tracks;
@property (nonatomic) NSUInteger currentTrackIndex;

- (IBAction)toggleAudioPlayer:(UIButton *)toggleAudioPlayerButton;
- (IBAction)playPreviousTrack:(UIButton *)previousTrackButton;
- (IBAction)playNextTrack:(UIButton *)nextTrackButton;
- (IBAction)volumeDidChange:(UISlider *)volumeSlider;

- (void)playCurrentTrack;

@end

@implementation ViewController

- (void)setCurrentTrackIndex:(NSUInteger)currentTrackIndex
{
    _currentTrackIndex = currentTrackIndex;
    
    if (_currentTrackIndex == 0) {
        self.previousTrackButton.enabled = NO;
        self.nextTrackButton.enabled = YES;
    } else if (_currentTrackIndex == [self.tracks count] - 1) {
        self.previousTrackButton.enabled = YES;
        self.nextTrackButton.enabled = NO;
    } else {
        self.previousTrackButton.enabled = YES;
        self.nextTrackButton.enabled = YES;
    }
}

- (IBAction)toggleAudioPlayer:(UIButton *)toggleAudioPlayerButton
{
    // Pause the current track.
    if (self.audioplayer.state == STKAudioPlayerStatePlaying) {
        [self.audioplayer pause];
        
        [toggleAudioPlayerButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
    }
    
    // Play the current track.
    else if (self.audioplayer.state == STKAudioPlayerStatePaused ||
             self.audioplayer.state == STKAudioPlayerStateStopped ||
             self.audioplayer.state == STKAudioPlayerStateReady) {
        // Play the song.
        [self playCurrentTrack];
        
        [toggleAudioPlayerButton setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
    }
}


- (IBAction)playPreviousTrack:(UIButton *)previousTrackButton
{
    self.currentTrackIndex--;
    
    [self playCurrentTrack];
}

- (IBAction)playNextTrack:(UIButton *)previousTrackButton
{
    self.currentTrackIndex++;
    
    [self playCurrentTrack];
}

- (IBAction)volumeDidChange:(UISlider *)volumeSlider
{
    self.audioplayer.volume = volumeSlider.value;
}

- (void)playCurrentTrack
{
    // Get the current track.
    Track *currentTrack = [self.tracks objectAtIndex:self.currentTrackIndex];
    
    // Update the UI elements 
    self.trackTitleLabel.text = currentTrack.title;
    self.trackArtistAlbumLabel.text = [NSString stringWithFormat:@"%@ -- %@", currentTrack.artist, currentTrack.album];
    self.albumArtworkImageView.image = currentTrack.albumArtwork;
    
    // Start streaming the track.
    [self.audioplayer playURL:currentTrack.streamingURL];
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
    self.currentTrackIndex = 0;
    
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
    
    NSLog(@"Did start playing song");
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject *)queueItemId
{
    NSLog(@"Did finish buffering");
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState
{
    NSLog(@"Audio player state changed to %d from %d", state, previousState);
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishPlayingQueueItemId:(NSObject *)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
    NSLog(@"Finished playing");
    
    // Check if last song.
    if (self.currentTrackIndex == [self.tracks count] - 1) {
        NSLog(@"Played last song");
        
//        self.currentTrackIndex = 0;
        
//        [self playCurrentTrack];
    }
    
    // Play next song
    else {
        self.currentTrackIndex++;
        
        [self playCurrentTrack];
    }
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
    NSLog(@"# queue items were cancelled: %d", [queuedItems count]);
}

@end
