//
//  ViewController.m
//  Flutter
//
//  Created by Nico Hämäläinen on 28/10/13.
//  Copyright (c) 2013 Nico Hämäläinen. All rights reserved.
//

#import "ViewController.h"
#import "TheAmazingAudioEngine.h"
#import "FlutterLayer.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@property (nonatomic, retain) AEAudioController *audioController;
@property (nonatomic, retain) AEBlockChannel *oscillator;
@property (nonatomic, retain) AEAudioUnitChannel *audioUnitPlayer;
@property (nonatomic, retain) FlutterLayer *inputLayer;

@end

@implementation ViewController

- (id)initWithAudioController:(AEAudioController *)audioController
{
    if (self = [super init]) {
        self.audioController = audioController;

        // Create a block-based channel, with an implementation of an oscillator
        __block float oscillatorPosition = 0;
        __block float oscillatorRate = 622.0/44100.0;
        self.oscillator = [AEBlockChannel channelWithBlock:^(const AudioTimeStamp  *time,
                                                             UInt32           frames,
                                                             AudioBufferList *audio) {
            for ( int i=0; i<frames; i++ ) {
                // Quick sin-esque oscillator
                float x = oscillatorPosition;
                x *= x; x -= 1.0; x *= x;       // x now in the range 0...1
                x *= INT16_MAX;
                x -= INT16_MAX / 2;
                oscillatorPosition += oscillatorRate;
                if ( oscillatorPosition > 1.0 ) oscillatorPosition -= 2.0;

                ((SInt16*)audio->mBuffers[0].mData)[i] = x;
                ((SInt16*)audio->mBuffers[1].mData)[i] = x;
            }
        }];

        _oscillator.audioDescription = [AEAudioController nonInterleaved16BitStereoAudioDescription];
        _oscillator.channelIsMuted = YES;

        self.audioUnitPlayer = [[[AEAudioUnitChannel alloc] initWithComponentDescription:AEAudioComponentDescriptionMake(kAudioUnitManufacturer_Apple, kAudioUnitType_Generator, kAudioUnitSubType_AudioFilePlayer)
                                                                         audioController:_audioController
                                                                                   error:NULL] autorelease];

        [_audioController addChannels:@[_oscillator]];
        [_audioController addChannels:@[_audioUnitPlayer]];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.inputLayer = [[[FlutterLayer alloc] initWithAudioController:_audioController] autorelease];
    _inputLayer.frame = CGRectMake(0, 0, 568, 320);
    _inputLayer.lineColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1.0 alpha:1.0];
    [self.view.layer addSublayer:_inputLayer];
    [_audioController addInputReceiver:_inputLayer];
    [_inputLayer start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
