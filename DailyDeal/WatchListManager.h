//
//  ConfigManager.h
//  Headlinepedia
//
//  Created by Lion User on 05/06/2013.
//
//

#import <Foundation/Foundation.h>

@interface WatchListManager : NSObject <NSURLConnectionDataDelegate> {
    NSMutableData *responseData;
    int _currentConnFlag;
}

+ (WatchListManager*) sharedInstance;

- (void) addToWatchList:(NSString*)uid forNid:(NSString*)nid;
- (void) removeWatchList:(NSString*)wid;
@end
