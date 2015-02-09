//
//  SharedSoundPlayer.m
//  DailyDeal
//
//  Created by Thomas Taussi on 8/7/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import "SharedSoundPlayer.h"

@implementation SharedSoundPlayer

@synthesize theAudio;

static SharedSoundPlayer* sharedInstance;

+ (SharedSoundPlayer*) sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[SharedSoundPlayer alloc] init];
    }
    
    return sharedInstance;
}

- (void) playSound:(NSString*) soundFileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:soundFileName ofType:@"wav"];
    theAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
    
    theAudio.delegate = self;
    theAudio.volume = 1.0f;
    if ([theAudio prepareToPlay]) {
        [theAudio play];
    }
}
@end
