//
//  AppDelegate.h
//  Flutter
//
//  Created by Nico Hämäläinen on 28/10/13.
//  Copyright (c) 2013 Nico Hämäläinen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AEAudioController;
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) ViewController *viewController;
@property (retain, nonatomic) AEAudioController *audioController;

@end
