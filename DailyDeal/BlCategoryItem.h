//
//  BlCategoryItem.h
//  DailyDeal
//
//  Created by Thomas Taussi on 7/31/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlCategoryItem : NSObject {
    BOOL            _isNew;
    NSString*       _wId;
    long            _dealId;
    NSString*       _title;
    NSString*       _description;
    NSString*       _category;
    NSString*       _location;
    double          _price;
    int             _bought;
    NSDate*         _startDate;
    NSDate*         _endDate;
    NSString*       _trackintUrl;
    NSString*       _discount;
    NSString*       _imgUrl;
    NSString*       _merchantAvatar;
    NSString*       _provider;
    double          _latitude;
    double          _longtitude;
    
    NSString*       _timeDD;
    NSString*       _timeHH;
    NSString*       _timeMM;
    
    NSString*       _actualPrice;
    
    UIImage*        _thumbImage;
    UIImage*        _providerImage;
}

@property (nonatomic)       BOOL            isNew;
@property (nonatomic, copy) NSString*       wId;
@property (nonatomic)       long            dealId;
@property (nonatomic, copy) NSString*       title;
@property (nonatomic, copy) NSString*       description;
@property (nonatomic, copy) NSString*       category;
@property (nonatomic, copy) NSString*       location;
@property (nonatomic)       double          price;
@property (nonatomic)       int             bought;
@property (nonatomic, copy) NSDate*         startDate;
@property (nonatomic, copy) NSDate*         endDate;
@property (nonatomic, copy) NSString*       trackintUrl;
@property (nonatomic, copy) NSString*       discount;
@property (nonatomic, copy) NSString*       imgUrl;
@property (nonatomic, copy) NSString*       merchantAvatar;
@property (nonatomic, copy) NSString*       provider;
@property (nonatomic)       double          latitude;
@property (nonatomic)       double          longtitude;
@property (nonatomic, copy) NSString*       timeDD;
@property (nonatomic, copy) NSString*       timeHH;
@property (nonatomic, copy) NSString*       timeMM;
@property (nonatomic, copy) NSString*       actualPrice;

@property (nonatomic, retain) UIImage*      thumbImage;
@property (nonatomic, retain) UIImage*      providerImage;

@end
