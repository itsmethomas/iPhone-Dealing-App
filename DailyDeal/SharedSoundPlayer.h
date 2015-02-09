//
//  SharedSoundPlayer.h
//  DailyDeal
//
//  Created by Thomas Taussi on 8/7/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SharedSoundPlayer : NSObject <AVAudioPlayerDelegate>{
}

@property (strong, nonatomic) AVAudioPlayer *theAudio;

+ (SharedSoundPlayer*) sharedInstance;

- (void) playSound:(NSString*) soundFileName;
@end
