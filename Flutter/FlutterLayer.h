//
//  FlutterLayer.h
//  Flutter
//
//  Created by Nico Hämäläinen on 28/10/13.
//  Copyright (c) 2013 Nico Hämäläinen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TheAmazingAudioEngine.h"

@interface FlutterLayer : CALayer <AEAudioReceiver>

/**
 * Initialize with an audio controller
 */
- (id)initWithAudioController:(AEAudioController *)audioController;

/**
 * Begin rendering
 *
 * Register with the audio controller to start receiving outgoing
 * audio samples, and begins rendering.
 */
- (void)start;

/**
 * Stop rendering
 *
 * Stop rendering and unregisters from the audio controller;
 */
- (void)stop;

/** The base line color to render with */
@property (nonatomic, retain) UIColor *lineColor;

- (AEAudioControllerAudioCallback)receiverCallback;

@end
