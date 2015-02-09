//
//  ConfigManager.m
//  Headlinepedia
//
//  Created by Lion User on 05/06/2013.
//
//

#import "WatchListManager.h"
#import "ActivityIndicator.h"
#import "Constants.h"

#define FLAG_ADD      1001
#define FLAG_REMOVE   1002

@implementation WatchListManager

static WatchListManager* instance;
+ (WatchListManager*) sharedInstance {
    if (instance == nil) {
        instance = [[WatchListManager alloc] init];
    }
    
    return instance;
}

- (void) addToWatchList:(NSString*)uid forNid:(NSString*)nid {
    responseData = [[NSMutableData alloc] init];
    [[ActivityIndicator currentIndicator] show];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:API_ADDWATCH_URL, uid, nid, nil]];
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
}

- (void) removeWatchList:(NSString*)wid {
    responseData = [[NSMutableData alloc] init];
    [[ActivityIndicator currentIndicator] show];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:API_REMOVEWATCH_URL, wid, nil]];
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
}

#pragma mark - NSURL Connection Delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[ActivityIndicator currentIndicator] hide];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Cannot connect to server!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseString);

    [[ActivityIndicator currentIndicator] hide];
}
@end
