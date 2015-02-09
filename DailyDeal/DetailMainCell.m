//
//  DetailMainCell.m
//  DailyDeal
//
//  Created by Thomas Taussi on 8/6/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import "DetailMainCell.h"

@implementation DetailMainCell

@synthesize locationLabel, logoImage, providerImage, titleLabel, fullPriceLabel, actualPriceLabel, discountLabel, boughtLabel;

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
