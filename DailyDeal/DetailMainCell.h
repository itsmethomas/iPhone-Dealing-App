//
//  DetailMainCell.h
//  DailyDeal
//
//  Created by Thomas Taussi on 8/6/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailMainCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *logoImage;
@property (nonatomic, retain) IBOutlet UIImageView *providerImage;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UILabel *fullPriceLabel;
@property (nonatomic, retain) IBOutlet UILabel *actualPriceLabel;
@property (nonatomic, retain) IBOutlet UILabel *discountLabel;
@property (nonatomic, retain) IBOutlet UILabel *boughtLabel;

@end
