//
//  ConfigManager.h
//  Headlinepedia
//
//  Created by Lion User on 05/06/2013.
//
//

#import <Foundation/Foundation.h>
#import "BlUserInfo.h"

@interface ConfigManager : NSObject

+ (void) rememberUserInfo:(BlUserInfo*)userinfo;
+ (void) clearUserInfo;

+ (BlUserInfo*) getRememberedUserinfo;

@end
