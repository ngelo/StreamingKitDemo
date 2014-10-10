//
//  Track.m
//  StreamingKitDemo
//
//  Created by Nikolas Gelo on 10/9/14.
//  Copyright (c) 2014 Nikolas Gelo. All rights reserved.
//

#import "Track.h"

@implementation Track

- (NSString *)description
{
    return [NSString stringWithFormat:@"Track:\n\tTitle: %@\n\tAlbum: %@\n\tArtist: %@", self.title, self.album, self.artist];
}

+ (NSArray *)allSongs
{
    Track *simpleThings = [[Track alloc] init];
    simpleThings.title = @"Simple Things";
    simpleThings.album = @"Simple Things - Single";
    simpleThings.artist = @"Something Like Seduction";
    simpleThings.albumArtwork = [UIImage imageNamed:@"Simple Things"];
    simpleThings.streamingURL = [NSURL URLWithString:@"http://slseduction.parseapp.com/music/SimpleThings-Single.mp3"];
    
    Track *inhaleTheFumes = [[Track alloc] init];
    inhaleTheFumes.title = @"Inhale the Fumes";
    inhaleTheFumes.album = @"Lost In Emerald Cove";
    inhaleTheFumes.artist = @"Something Like Seduction";
    inhaleTheFumes.albumArtwork = [UIImage imageNamed:@"Lost In Emerald Cove"];
    inhaleTheFumes.streamingURL = [NSURL URLWithString:@"http://slseduction.parseapp.com/music/InhaleTheFumes-LIEC.mp3"];
    
    Track *obligations = [[Track alloc] init];
    obligations.title = @"Obligations";
    obligations.album = @"Lost In Emerald Cove";
    obligations.artist = @"Something Like Seduction";
    obligations.albumArtwork = [UIImage imageNamed:@"Lost In Emerald Cove"];
    obligations.streamingURL = [NSURL URLWithString:@"http://slseduction.parseapp.com/music/Obligations-LIEC.mp3"];
    
    return @[simpleThings, inhaleTheFumes, obligations];
}

@end
