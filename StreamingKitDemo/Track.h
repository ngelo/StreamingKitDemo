//
//  Track.h
//  StreamingKitDemo
//
//  Created by Nikolas Gelo on 10/9/14.
//  Copyright (c) 2014 Nikolas Gelo. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit.UIImage;

@interface Track : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *album;
@property (nonatomic, strong) NSString *artist;

@property (nonatomic, strong) UIImage *albumArtwork;

@property (nonatomic, strong) NSURL *streamingURL;

+ (NSArray *)allTracks;

@end
