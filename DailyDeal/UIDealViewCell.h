//
//  UIDealViewCell.h
//  DailyDeal
//
//  Created by Thomas Taussi on 7/31/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

@interface UIDealViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *logoImageView;
@property (nonatomic, retain) IBOutlet UIImageView *providerImageView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UILabel *fullpriceLabel;
@property (nonatomic, retain) IBOutlet UILabel *discountLabel;
@property (nonatomic, retain) IBOutlet UILabel *boughtLabel;
@property (nonatomic, retain) IBOutlet UILabel *isnewLabel;

@property (nonatomic, retain) IBOutlet UILabel *timeDayLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeHourLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeMinuteLabel;

@property (nonatomic, retain) IBOutlet UILabel *priceLabel;
@end
