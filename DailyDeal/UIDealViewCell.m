//
//  UIDealViewCell.m
//  DailyDeal
//
//  Created by Thomas Taussi on 7/31/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import "UIDealViewCell.h"

@implementation UIDealViewCell

@synthesize logoImageView, providerImageView, titleLabel, fullpriceLabel, discountLabel, boughtLabel, isnewLabel;
@synthesize timeDayLabel, timeHourLabel, timeMinuteLabel, priceLabel, locationLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end