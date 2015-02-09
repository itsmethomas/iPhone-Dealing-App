//
//  BlUserInfo.h
//  DailyDeal
//
//  Created by Thomas Taussi on 8/26/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlUserInfo : NSObject {
    NSString* _uid;
    NSString* _name;
    NSString* _sessid;
    NSString* _session_name;
    NSString* _token;
    NSString* _locid;
    NSString* _facebookImageUrl;
}

@property (nonatomic, retain) NSString * UID;
@property (nonatomic, retain) NSString * NAME;
@property (nonatomic, retain) NSString * SESSION_ID;
@property (nonatomic, retain) NSString * SESSION_NAME;
@property (nonatomic, retain) NSString * TOKEN;
@property (nonatomic, retain) NSString * LOCATION_ID;
@property (nonatomic, retain) NSString * FACEBOOK_IMG_URL;

@end
