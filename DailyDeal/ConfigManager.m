//
//  ConfigManager.m
//  Headlinepedia
//
//  Created by Lion User on 05/06/2013.
//
//

#import "ConfigManager.h"

@implementation ConfigManager

+ (void) rememberUserInfo:(BlUserInfo*)userinfo {
    NSString *config_path = [self dataFilePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:config_path]) {
        [self initConfigFile];
    }

    NSMutableDictionary *config_dic = [[NSMutableDictionary alloc] init];
    [config_dic setObject:userinfo.UID forKey:@"UID"];
    [config_dic setObject:userinfo.SESSION_ID forKey:@"SESSION_ID"];
    [config_dic setObject:userinfo.SESSION_NAME forKey:@"SESSION_NAME"];
    [config_dic setObject:userinfo.TOKEN forKey:@"TOKEN"];
    [config_dic setObject:userinfo.LOCATION_ID forKey:@"LOCATION_ID"];
    
    [config_dic writeToFile:config_path atomically:YES];
}

+ (void) clearUserInfo {
    NSString *config_path = [self dataFilePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:config_path]) {
        [self initConfigFile];
    }
    
    NSMutableDictionary *config_dic = [[NSMutableDictionary alloc] init];
    
    [config_dic writeToFile:config_path atomically:YES];
}

+ (BlUserInfo*) getRememberedUserinfo {
    NSString *config_path = [self dataFilePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:config_path]) {
        [self initConfigFile];
    }
    
    NSMutableDictionary *config_dic = [[NSMutableDictionary alloc] initWithContentsOfFile:config_path];
    if ([config_dic objectForKey:@"UID"] == nil)
        return nil;
    else {
        BlUserInfo *userinfo = [[BlUserInfo alloc] init];
        userinfo.UID = [config_dic objectForKey:@"UID"];
        userinfo.SESSION_ID = [config_dic objectForKey:@"SESSION_ID"];
        userinfo.SESSION_NAME = [config_dic objectForKey:@"SESSION_NAME"];
        userinfo.TOKEN = [config_dic objectForKey:@"TOKEN"];
        userinfo.LOCATION_ID = [config_dic objectForKey:@"LOCATION_ID"];
        
        return userinfo;
    }
}

+ (void) initConfigFile {
    NSString *config_path = [self dataFilePath];
    
    NSMutableDictionary *config_dic = [[NSMutableDictionary alloc] init];
    
    [config_dic writeToFile:config_path atomically:YES];
}

+(NSString *)dataFilePath {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"config"];
}

@end
